//
//  NetNeuronError.swift
//  
//
//  Created by Hugo Pivaral on 3/06/23.
//

import Foundation

/// This enum defines the different types of errors that can occur when making a network request
public enum NetNeuronError: Error {
    
    /// An API error occurred, including an HTTP status code and a custom error message
    case apiError(Int, error: Decodable)
    
    /// An API error occurred, including an HTTP status code and the response itself
    case apiError(Int, response: HTTPURLResponse)
    
    /// The data returned from the API could not be parsed
    case badData
    
    /// The API request was malformed
    case badRequest
    
    /// There is no internet connection
    case noInternetConnection
    
    /// The requested resource was not found on the server
    case notFound
    
    /// An error occurred while parsing the response from the API
    case parsingError(String, Error)
    
    /// The request was not authorized
    case unauthorized
    
    /// An unexpected error occurred
    case unexpectedError(Error)
}
