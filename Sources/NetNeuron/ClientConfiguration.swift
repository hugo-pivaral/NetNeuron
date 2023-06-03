//
//  ClientConfiguration.swift
//  
//
//  Created by Hugo Pivaral on 3/06/23.
//

import Foundation

public typealias HTTPHeaders = [String: String]

/// This struct defines the configuration options for a ``NetNeuronClient`` instance, including the base URL of the server,
/// the default headers to include in all requests, the URLSession to use for networking, and the JSON encoder and decoder
/// to use for converting between Swift objects and JSON data.
public struct ClientConfiguration {
    
    /// The base URL of the server
    let hostURL: String
    /// Optional default headers to include in all requests
    let headers: HTTPHeaders?
    /// The URLSession to use for networking
    let session: URLSession
    /// The JSON encoder to use for converting Swift objects to JSON data
    let encoder: JSONEncoder
    /// The JSON decoder to use for converting JSON data to Swift objects
    let decoder: JSONDecoder
    
    public init(
        hostURL: String,
        headers: HTTPHeaders? = nil,
        session: URLSession = .shared,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.hostURL = hostURL
        self.headers = headers
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }
}
