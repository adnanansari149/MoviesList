//
//  NetworkManagerTests.swift
//  MoviesListAppTests
//
//  Created by Adnan Ansari on 14/07/24.
//

import XCTest
import Combine
@testable import MoviesListApp

final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager.shared
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        networkManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchMovies() {
        let expectation = self.expectation(description: "Movies should be fetched")
        
        networkManager.fetchMovies(searchTerm: "Inception")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed to fetch movies: \(error)")
                }
            }, receiveValue: { movies in
                XCTAssertGreaterThan(movies.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchMovieDetails() {
        let expectation = self.expectation(description: "Movie details should be fetched")
        
        networkManager.fetchMovieDetails(imdbID: "tt1375666")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed to fetch movie details: \(error)")
                }
            }, receiveValue: { movieDetail in
                XCTAssertNotNil(movieDetail)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
