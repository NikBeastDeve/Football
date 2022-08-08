//
//  SeasonsManager.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation

protocol SeasonsManager {
    
    // MARK: - Properties
    var selectedId: String { get }
    var leaguesDataState: DataState<SeasonsData> { get }
    
    // MARK: - Instance Methods
    
    func loadSeasons(id: String, completion: @escaping (() -> Void))
}
