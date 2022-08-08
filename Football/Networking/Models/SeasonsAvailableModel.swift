//
//  SeasonsAvailableModel.swift
//  
//
//  Created by Nikita Galaganov on 07/08/2022.
//

import Foundation

// MARK: - SeasonsAvailableModel
public struct SeasonsAvailableModel: Codable {
    let status: Bool
    let data: SeasonsData
}

// MARK: - SeasonsData
public struct SeasonsData: Codable {
    let name, desc, abbreviation: String
    let seasons: [Season]
}

// MARK: - Season
public struct Season: Codable {
    let year: Int
    let startDate, endDate, displayName: String
    let types: [SeasonInsights]
}

// MARK: - SeasonInsights
public struct SeasonInsights: Codable {
    let id, name, abbreviation, startDate: String
    let endDate: String
    let hasStandings: Bool
}
