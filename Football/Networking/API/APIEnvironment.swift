//
//  APIEnvironment.swift
//  
//
//  Created by Nikita Galaganov on 07/08/2022.
//

import Foundation

enum APIEnvironment: EnvironmentProtocol {
    /// The development environment.
    case development
    /// The production environment.
    case production
    
    /// The default HTTP request headers for the given environment.
    var headers: ReaquestHeaders? {
        switch self {
        case .development:
            return [
                "Content-Type" : "application/json"
            ]
        case .production:
            return [:]
        }
    }

    /// The base URL of the given environment.
    var baseURL: String {
        switch self {
        case .development:
            return "https://api-football-standings.azharimm.site"
        case .production:
            return ""
        }
    }
}
