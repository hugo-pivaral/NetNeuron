//
//  NetNeuronClient.swift
//
//
//  Created by Hugo Pivaral on 3/06/23.
//

import Foundation

/// A networking client class that uses URLSession to make API requests and handle responses.
public class NetNeuronClient {
    
    private let configuration: ClientConfiguration
    
    public init(configuration: ClientConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: Public methods
    
    /// Send a request without a body and expect a response of the specified type.
    ///
    /// - Parameters:
    ///   - resource: The resource to send the request to.
    ///   - responseType: The type of the expected response.
    ///   - additionalHeaders: Any additional headers to include in the request.
    ///   - errorType: The type of error response expected from the server.
    ///
    /// - Returns: The decoded response object of the specified type.
    /// - Throws: A NetworkingError if there is an issue with the network request, an error in the decoding process, or an API error response
    public func request<T: Decodable, U: Decodable>(
        to resource: Resource,
        expecting responseType: T.Type,
        additionalHeaders: HTTPHeaders = HTTPHeaders(),
        errorType: U.Type
    ) async throws -> T {
        return try await request(resource: resource, responseType: responseType, additionalHeaders: additionalHeaders, errorType: errorType)
    }
    
    /// Send a request with a body and expect a response of the specified type.
    ///
    /// - Parameters:
    ///   - resource: The resource to send the request to.
    ///   - body: The body of the request.
    ///   - responseType: The type of the expected response.
    ///   - additionalHeaders: Any additional headers to include in the request.
    ///   - errorType: The type of error response expected from the server.
    ///
    /// - Returns: The decoded response object of the specified type.
    /// - Throws: A NetworkingError if there is an issue with the network request, an error in the decoding process, or an API error response
    public func request<T: Decodable, U: Decodable>(
        to resource: Resource,
        withBody body: Encodable,
        expecting responseType: T.Type,
        additionalHeaders: HTTPHeaders = HTTPHeaders(),
        errorType: U.Type
    ) async throws -> T {
        do {
            let data = try configuration.encoder.encode(body)
            return try await request(resource: resource, body: data, responseType: responseType, additionalHeaders: additionalHeaders, errorType: errorType)
        } catch (let error) {
            throw error
        }
    }
    
    // MARK: Private methods
    
    private func request<T: Decodable, U: Decodable>(
        resource: Resource,
        body: Data? = nil,
        responseType: T.Type,
        additionalHeaders: HTTPHeaders = HTTPHeaders(),
        errorType: U.Type
    ) async throws -> T {
        // The combined string of the defined host and endpoint paths
        let fullURLString = configuration.hostURL + resource.endpoint
        guard var url = URL(string: fullURLString) else {
            #if DEBUG
            print("❌ Invalid URL: \(fullURLString)")
            #endif
            
            throw URLError(.badURL)
        }
        
        // If there are any query items, append them to the URL
        if let queryItems = resource.queryItems {
            url = url.appending(queryItems: queryItems)
        }
        
        // Create the request object
        var request = URLRequest(url: url)
        
        // Set the HTTP method of the request to the method defined by the resource
        request.httpMethod = resource.method.rawValue
        
        // Combine the headers defined by the configuration with any additional headers provided
        request.allHTTPHeaderFields = configuration.headers?.merging(additionalHeaders, uniquingKeysWith: { $1 })
        
        // If a request body is provided, add it to the request
        if let body {
            assert(resource.method != .GET, "⚠️ GET requests should not contain a body.")
            request.httpBody = body
        }
        
        do {
            #if DEBUG
            print("🚀 Sending request to: \(url)")
            #endif
            
            let (data, response) = try await configuration.session.data(for: request)
            
            // Ensure that the response is an HTTPURLResponse object
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            #if DEBUG
            print("📦 Recevied response from: \(url) | Status code: \(httpResponse.statusCode)")
            print("📦 Body: \(String(data: data, encoding: .utf8) ?? "")")
            #endif
            
            switch httpResponse.statusCode {
            case 200...399:
                do {
                    // Parse and return the response body as the expected generic type `T`
                    let decodedResponse = try configuration.decoder.decode(T.self, from: data)
                    return decodedResponse
                } catch (let error) {
                    throw NetNeuronError.parsingError("⚠️ Failed parsing object: \(String(describing: T.self))", error)
                }
            case 401:
                // Unauthorized request with status code 401
                throw NetNeuronError.unauthorized
            case 404:
                // Resource not found with status code 404
                throw NetNeuronError.notFound
            case 400, 402, 403, 405...599:
                var apiError: U
                
                do {
                    // Try to parse the response body as the expected error type `U`
                    apiError = try configuration.decoder.decode(U.self, from: data)
                } catch {
                    // Parsing failed. Throw a `NetworkingError.apiError` error with the original status code and response object
                    throw NetNeuronError.apiError(httpResponse.statusCode, response: httpResponse)
                }
                
                // Parsing succeeded. Throw a `NetworkingError.apiError` error with the original status code and the parsed error object
                throw NetNeuronError.apiError(httpResponse.statusCode, error: apiError)
            default:
                // Other server errors with status codes not covered above
                throw URLError(.unknown)
            }
            
        } catch (let error) {
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
                throw NetNeuronError.noInternetConnection
            }
            
            throw error
        }
    }
}
