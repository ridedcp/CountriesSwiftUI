//
//  CountryListViewModelTests.swift
//  CountriesSwiftUITests
//
//  Created by Daniel Cano on 14/5/25.
//

import Testing
import XCTest
import Combine
@testable import CountriesSwiftUI

final class CountryListViewModelTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []

    func testFetchCountriesPublishesResults() {
        // Given
        let mockService = MockCountryService()
        let viewModel = CountryListViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "Countries loaded")

        // When
        viewModel.$countries
            .dropFirst()
            .sink { countries in
                // Then
                let names = countries.map { $0.name.common }
                XCTAssertEqual(countries.count, 2)
                XCTAssertEqual(Set(names), Set(["Spain", "France"]))
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchCountries()
        wait(for: [expectation], timeout: 1)
    }
}
