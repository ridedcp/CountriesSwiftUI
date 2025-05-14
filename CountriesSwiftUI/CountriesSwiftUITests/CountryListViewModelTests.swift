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
    
    func testFetchCountriesPublishesError() {
        // Given
        let mockService = MockCountryService()
        mockService.shouldFail = true

        let viewModel = CountryListViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "Error received")

        // When
        viewModel.fetchCountries()
        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                // Then
                XCTAssertNotNil(error)
                XCTAssertEqual(viewModel.countries.count, 0)
                XCTAssertFalse(viewModel.isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
    
    func testSearchTextFiltersCountries() {
        // Given
        let mockService = MockCountryService()
        let viewModel = CountryListViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "Search filtered results")

        viewModel.$countries
            .dropFirst(2)
            .sink { countries in
                // Then
                XCTAssertEqual(countries.count, 1)
                XCTAssertEqual(countries[0].name.common, "France")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.fetchCountries()
        viewModel.searchText = "paris"

        wait(for: [expectation], timeout: 2)
    }

}
