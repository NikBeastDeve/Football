//
//  HTTPMethod.swift
//  
//
//  Created by Nikita Galaganov on 07/08/2022.
//

import Foundation

/// enum represents request method to acquire data
enum HTTPMethod: String {
    /// HTTP GET
    case get = "GET"
    /// HTTP POST
    case post = "POST"
    /// HTTP PUT
    case put = "PUT"
    /// HTTP PATCH
    case patch = "PATCH"
    /// HTTP DELETE
    case delete = "DELETE"
}

/// The request type that matches the URLSessionTask types.
enum RequestType {
    /// Will translate to a URLSessionDataTask.
    case data
}

/// The expected remote response type.
enum ResponseType {
    /// Used when the expected response is a JSON payload.
    case json
}
