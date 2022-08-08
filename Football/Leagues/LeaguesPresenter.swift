//
//  LeaguesPresenter.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation

class LeaguesPresenter: LeaguesManager {
    
    // MARK: - Properties
    private let dataService: FootballDataService
    var leaguesDataState: DataState<LeaguesModel> = DataState<LeaguesModel>.initial
    
    private var selectedLeagueId: String = String()
    
    init(dataService: FootballDataService) {
        self.dataService = dataService
    }
    
    func loadLeagues(completion: @escaping (() -> Void)) {
        dataService.getLeagues { res in
            switch res {
            case .success(let leagues):
                self.leaguesDataState = .loaded(data: leagues)
                completion()
            case .failure(let error):
                self.leaguesDataState = .failed(error: error as NSError)
                completion()
            }
        }
    }
}
