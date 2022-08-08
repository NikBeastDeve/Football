//
//  FootballDataService.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation

protocol FootballDataServiceLogic {
    func getLeagues(completion: @escaping (Result<LeaguesModel, APIError>) -> Void)
    func getStandings(by id: String, completion: @escaping (Result<StandingsModel, APIError>) -> Void)
    func getSeasonsAvailable(by id: String, completion: @escaping (Result<SeasonsAvailableModel, APIError>) -> Void)
    func getLeagueDetails(by id: String, completion: @escaping (Result<League, APIError>) -> Void)
}

struct FootballDataService: FootballDataServiceLogic {
    private let requestDispatcher = APIRequestDispatcher(environment: APIEnvironment.development, networkSession: APINetworkSession())
    
    func getLeagues(completion: @escaping (Result<LeaguesModel, APIError>) -> Void) {
        let leaguesRequest = FootballEndpoint.leagues

        let footballOperation = APIOperation(leaguesRequest)
        footballOperation.execute(in: requestDispatcher) { result in
            switch result {
            case .json(let data, _):
                let leagues = try? JSONDecoder().decode(LeaguesModel.self, from: data)
                
                guard let obj = leagues else {
                    return completion(.failure(APIError.parseError("Couldn't parse JSON")))
                }
                
                return completion(.success(obj))
            case .error(let error, _):
                return completion(.failure(error))
            }
        }
    }
    
    func getStandings(by id: String, completion: @escaping (Result<StandingsModel, APIError>) -> Void) {
        let standingsRequest = FootballEndpoint.standings(identifier: id)

        let footballOperation = APIOperation(standingsRequest)
        footballOperation.execute(in: requestDispatcher) { result in
            switch result {
            case .json(let data, _):
                let standings = try? JSONDecoder().decode(StandingsModel.self, from: data)
                
                guard let obj = standings else {
                    return completion(.failure(APIError.parseError("Couldn't parse JSON")))
                }
                
                return completion(.success(obj))
            case .error(let error, _):
                return completion(.failure(error))
            }
        }
    }
    
    func getSeasonsAvailable(by id: String, completion: @escaping (Result<SeasonsAvailableModel, APIError>) -> Void) {
        let seasonsRequest = FootballEndpoint.seasonsAvailable(identifier: id)

        let footballOperation = APIOperation(seasonsRequest)
        footballOperation.execute(in: requestDispatcher) { result in
            switch result {
            case .json(let data, _):
                let seasons = try? JSONDecoder().decode(SeasonsAvailableModel.self, from: data)
                
                guard let obj = seasons else {
                    return completion(.failure(APIError.parseError("Couldn't parse JSON")))
                }
                
                return completion(.success(obj))
            case .error(let error, _):
                return completion(.failure(error))
            }
        }
    }
    
    func getLeagueDetails(by id: String, completion: @escaping (Result<League, APIError>) -> Void) {
        let leagueRequest = FootballEndpoint.leagueDetail(identifier: id)

        let footballOperation = APIOperation(leagueRequest)
        footballOperation.execute(in: requestDispatcher) { result in
            switch result {
            case .json(let data, _):
                let league = try? JSONDecoder().decode(League.self, from: data)
                
                guard let obj = league else {
                    return completion(.failure(APIError.parseError("Couldn't parse JSON")))
                }
                
                return completion(.success(obj))
            case .error(let error, _):
                return completion(.failure(error))
            }
        }
    }
}
