//
//  SeasonsPresenter.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation

class SeasonsPresenter: SeasonsManager {
    // MARK: - Properties
    private let dataService: FootballDataService
    var selectedId: String = String()
    var leaguesDataState: DataState<SeasonsData> = DataState<SeasonsData>.initial
    
    private var selectedLeagueId: String = String()
    
    init(dataService: FootballDataService, id: String) {
        self.dataService = dataService
        selectedId = id
    }
    
    func loadSeasons(id: String, completion: @escaping (() -> Void)) {
        dataService.getSeasonsAvailable(by: id) { res in
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
