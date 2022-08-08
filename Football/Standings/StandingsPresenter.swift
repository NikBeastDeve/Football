//
//  StandingsPresenter.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation

class StandingsPresenter: StandingsManager {
    // MARK: - Properties
    private let dataService: FootballDataService
    var selectedId: String = String()
    var leaguesDataState: DataState<StandingsData> = DataState<StandingsData>.initial
    
    private var selectedLeagueId: String = String()
    
    init(dataService: FootballDataService, id: String) {
        self.dataService = dataService
        selectedId = id
    }
    
    func reloadData(with season: StandingsData, completion: @escaping (() -> Void)) {
        self.leaguesDataState = .loaded(data: season)
        completion()
    }
    
    func loadStandings(id: String, completion: @escaping (() -> Void)) {
        dataService.getStandings(by: id) { res in
            switch res {
            case .success(let seasons):
                self.leaguesDataState = .loaded(data: seasons.data)
                completion()
            case .failure(let error):
                self.leaguesDataState = .failed(error: error as NSError)
                completion()
            }
        }
    }
}
