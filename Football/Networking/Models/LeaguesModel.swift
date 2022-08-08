//
//  LeaguesModel.swift
//  
//
//  Created by Nikita Galaganov on 07/08/2022.
//

import Foundation

// MARK: - LeaguesModel
struct LeaguesModel: Codable {
    let status: Bool
    let data: [League]
}

// MARK: - League
struct League: Codable {
    let id, name, slug, abbr: String
    let logos: Logos
}

// MARK: - Logos
struct Logos: Codable {
    let light: String
    let dark: String
}
