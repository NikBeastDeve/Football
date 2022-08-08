//
//  DataState.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation

enum DataState<T> {
    case initial
    case loading
    case failed(error: NSError)
    case loaded(data: T)
    case unavailable
}
