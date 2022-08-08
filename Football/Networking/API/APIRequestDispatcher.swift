//
//  APIRequestDispatcher.swift
//  
//
//  Created by Nikita Galaganov on 07/08/2022.
//

import Foundation

/// Class that handles the dispatch of requests to an environment with a given configuration.
class APIRequestDispatcher: RequestDispatcherProtocol {

    /// The environment configuration.
    private var environment: EnvironmentProtocol

    /// The network session configuration.
    private var networkSession: NetworkSessionProtocol

    /// Required initializer.
    /// - Parameters:
    ///   - environment: Instance conforming to `EnvironmentProtocol` used to determine on which environment the requests will be executed.
    ///   - networkSession: Instance conforming to `NetworkSessionProtocol` used for executing requests with a specific configuration.
    required init(environment: EnvironmentProtocol, networkSession: NetworkSessionProtocol) {
        self.environment = environment
        self.networkSession = networkSession
    }
    
    /// Executes a request.
        /// - Parameters:
        ///   - request: Instance conforming to `RequestProtocol`
        ///   - completion: Completion handler.
        func execute(request: RequestProtocol, completion: @escaping (OperationResult) -> Void) -> URLSessionTask? {
            // Create a URL request.
            guard var urlRequest = request.urlRequest(with: environment) else {
                completion(.error(APIError.badRequest("Invalid URL for: \(request)"), nil))
                return nil
            }
            // Add the environment specific headers.
            environment.headers?.forEach({ (key: String, value: String) in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            })

            // Create a URLSessionTask to execute the URLRequest.
            var task: URLSessionTask?
            switch request.requestType {
            case .data:
                task = networkSession.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
                    self.handleJsonTaskResponse(data: data, urlResponse: urlResponse, error: error, completion: completion)
                })
            }
            // Start the task.
            task?.resume()

            return task
        }

    /// Handles the data response that is expected as a JSON object output.
    /// - Parameters:
    ///   - data: The `Data` instance to be serialized into a JSON object.
    ///   - urlResponse: The received  optional `URLResponse` instance.
    ///   - error: The received  optional `Error` instance.
    ///   - completion: Completion handler.
    private func handleJsonTaskResponse(data: Data?, urlResponse: URLResponse?, error: Error?, completion: @escaping (OperationResult) -> Void) {
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            completion(OperationResult.error(APIError.serverError(nil), nil))
            return
        }
        
        // Verify the HTTP status code.
        let result = verify(data: data, urlResponse: urlResponse, error: error)
        switch result {
        case .success(let data):
            DispatchQueue.main.async {
                completion(OperationResult.json(data, urlResponse))
            }
        case .failure(let error):
            DispatchQueue.main.async {
                completion(OperationResult.error(error, urlResponse))
            }
        }
    }

    /// Checks if the HTTP status code is valid and returns an error otherwise.
    /// - Parameters:
    ///   - data: The data or file  URL .
    ///   - urlResponse: The received  optional `URLResponse` instance.
    ///   - error: The received  optional `Error` instance.
    /// - Returns: A `Result` instance.
    private func verify(data: Data?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Data, APIError> {
        switch urlResponse.statusCode {
        case 200...299:
            if let data = data {
                return .success(data)
            } else {
                return .failure(APIError.noData)
            }
        case 400...499:
            return .failure(APIError.badRequest(error?.localizedDescription))
        case 500...599:
            return .failure(APIError.serverError(error?.localizedDescription))
        default:
            return .failure(APIError.unknown)
        }
    }
}
