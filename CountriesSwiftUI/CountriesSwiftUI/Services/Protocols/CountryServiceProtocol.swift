//
//  CountryServiceProtocol.swift
//  CountriesSwiftUI
//
//  Created by Daniel Cano on 14/5/25.
//

import Foundation
import Combine

protocol CountryServiceProtocol {
    func fetchCountries() -> AnyPublisher<[Country], Error>
}

