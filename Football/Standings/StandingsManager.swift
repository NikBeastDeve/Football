//
//  StandingsManager.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation

protocol StandingsManager {
    
    // MARK: - Properties
    var selectedId: String { get }
    var leaguesDataState: DataState<StandingsData> { get }
    
    // MARK: - Instance Methods
    
    func loadStandings(id: String, completion: @escaping (() -> Void))
    func reloadData(with season: StandingsData, completion: @escaping (() -> Void))
}
