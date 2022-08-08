//
//  LeaguesManager.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation

protocol LeaguesManager {
    
    // MARK: - Properties
    
    var leaguesDataState: DataState<LeaguesModel> { get }
    
    // MARK: - Instance Methods
    
    func loadLeagues(completion: @escaping (() -> Void))
}
