//
//  CountriesSwiftUIApp.swift
//  CountriesSwiftUI
//
//  Created by Daniel Cano on 13/5/25.
//

import SwiftUI

@main
struct CountriesSwiftUIApp: App {
    
    @StateObject private var viewModel = CountryListViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                CountryListView(viewModel: viewModel)
                    .tabItem {
                        Label("All", systemImage: "globe")
                    }
                
                FavoriteCountriesView(viewModel: viewModel)
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
            }
        }
    }
}
