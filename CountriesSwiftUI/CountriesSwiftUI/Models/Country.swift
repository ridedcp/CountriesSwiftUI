//
//  Country.swift
//  CountriesSwiftUI
//
//  Created by Daniel Cano on 13/5/25.
//

import Foundation

struct Country: Decodable, Identifiable {
    var id: String { cca3 }

    let name: Name
    let capital: [String]?
    let flags: Flags
    let cca3: String
    let region: String
    let population: Int
}

struct Name: Decodable {
    let common: String
}

struct Flags: Decodable {
    let png: String
}

extension Country {
    var isFavorite: Bool {
        FavoriteManager.shared.isFavorite(cca3: cca3)
    }
}
