//
//  FavoriteManager.swift
//  CountriesSwiftUI
//
//  Created by Daniel Cano on 14/5/25.
//

import Foundation
import Combine

class FavoriteManager: ObservableObject {
    static let shared = FavoriteManager()

    @Published private(set) var favoriteIDs: Set<String> = []

    private let key = "favorite_countries"

    private init() {
        load()
    }

    func toggleFavorite(cca3: String) {
        if favoriteIDs.contains(cca3) {
            favoriteIDs.remove(cca3)
        } else {
            favoriteIDs.insert(cca3)
        }
        save()
    }

    func isFavorite(cca3: String) -> Bool {
        favoriteIDs.contains(cca3)
    }

    private func save() {
        let array = Array(favoriteIDs)
        UserDefaults.standard.set(array, forKey: key)
    }

    private func load() {
        if let array = UserDefaults.standard.stringArray(forKey: key) {
            favoriteIDs = Set(array)
        }
    }
}
