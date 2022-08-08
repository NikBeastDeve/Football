//
//  OperationResult.swift
//  
//
//  Created by Nikita Galaganov on 07/08/2022.
//

import Foundation

/// The expected result of an API Operation.
enum OperationResult {
    /// JSON reponse.
    case json(_ : Data, _ : HTTPURLResponse?)
    /// An error.
    case error(_ : APIError, _ : HTTPURLResponse?)
}
