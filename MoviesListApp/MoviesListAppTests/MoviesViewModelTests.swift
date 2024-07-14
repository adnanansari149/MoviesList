//
//  MoviesViewModelTests.swift
//  MoviesListAppTests
//
//  Created by Adnan Ansari on 14/07/24.
//

import XCTest
import Combine
@testable import MoviesListApp

final class MoviesViewModelTests: XCTestCase {
    
    var viewModel: MoviesViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = MoviesViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchMovies() {
        let expectation = self.expectation(description: "Movies should be fetched and published")
        
        viewModel.$movies
            .dropFirst()
            .sink(receiveValue: { movies in
                XCTAssertGreaterThan(movies.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.fetchMovies(searchTerm: "Inception")
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchMovieDetails() {
        let expectation = self.expectation(description: "Movie details should be fetched")
        
        viewModel.fetchMovieDetails(imdbID: "tt1375666")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed to fetch movie details: \(error)")
                }
            }, receiveValue: { movieDetailVM in
                XCTAssertEqual(movieDetailVM.imdbID, "tt1375666")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
