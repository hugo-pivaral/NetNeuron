//
//  NetNeuronResource.swift
//  
//
//  Created by Hugo Pivaral on 3/06/23.
//

import Foundation

/// This protocol defines a networking resource, which is any endpoint that can be accessed through HTTP requests
public protocol NetNeuronResource {
    
    var resource: Resource { get }
}

/// This struct defines a networking resource, which includes the HTTP method, the endpoint, and optional query parameters
public struct Resource {
    
    /// The HTTP method used to access the endpoint *(e.g., GET, POST, PUT, DELETE)*
    let method: HTTPMethod
    /// The URL path of the endpoint
    let endpoint: String
    /// Optional query parameters to include in the request URL
    let queryItems: [URLQueryItem]?
    
    /// Creates a new resource with the method, endpoint and query items you specify.
    public init(
        _ method: HTTPMethod,
        _ endpoint: String,
        queryItems: [URLQueryItem]? = nil
    ) {
        self.method = method
        self.endpoint = endpoint
        self.queryItems = queryItems
    }
    
    /// Returns a new Resource by appending the specified route to the existing endpoint
    public func appending(_ route: String) -> Resource {
        let cleanedRoute = route.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let cleanEndpoint = endpoint.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return Resource(self.method,
                        cleanEndpoint + "/\(cleanedRoute)",
                        queryItems: self.queryItems)
    }
    
    /// Returns a new Resource by appending the specified query parameters to the existing ones
    public func appending(parameters: [URLQueryItem]) -> Resource {
        var queryItems = self.queryItems ?? []
        queryItems.append(contentsOf: parameters)
        
        return Resource(self.method, self.endpoint, queryItems: queryItems)
    }
}
