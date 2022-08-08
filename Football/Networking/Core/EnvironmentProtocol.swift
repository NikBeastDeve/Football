//
//  File.swift
//  
//
//  Created by Nikita Galaganov on 07/08/2022.
//

import Foundation

/// Protocol to which environments must conform.
protocol EnvironmentProtocol {
    /// The default HTTP request headers for the environment.
    var headers: ReaquestHeaders? { get }

    /// The base URL of the environment.
    var baseURL: String { get }
}
