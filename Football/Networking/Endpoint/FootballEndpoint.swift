//
//  FootballEndpoint.swift
//  
//
//  Created by Nikita Galaganov on 07/08/2022.
//

import Foundation

/// Books endpoint
enum FootballEndpoint {
    /// Lists all the leagues.
    case leagues
    /// Fetches a league details
    case leagueDetail(identifier: String)
    /// View all seasons by given id
    case seasonsAvailable(identifier: String)
    /// View all standings by given id
    case standings(identifier: String)
}

extension FootballEndpoint: RequestProtocol {
    var path: String {
        switch self {
        case .leagues:
            return "/leagues"
        case .leagueDetail(let identifier):
            return "/leagues/\(identifier)"
        case .seasonsAvailable(let identifier):
            return "/leagues/\(identifier)/seasons"
        case .standings(let identifier):
            return "/leagues/\(identifier)/standings"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .leagues, .leagueDetail, .seasonsAvailable, .standings:
            return .get
        }
    }

    var headers: ReaquestHeaders? {
        return nil
    }

    var parameters: RequestParameters? {
        switch self {
        default:
            return nil
        }
    }

    var requestType: RequestType {
        return .data
    }

    var responseType: ResponseType {
        return .json
    }
}

