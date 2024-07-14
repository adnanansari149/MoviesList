//
//  UserDefaultManagerTests.swift
//  MoviesListAppTests
//
//  Created by Adnan Ansari on 14/07/24.
//

import XCTest
import Combine
@testable import MoviesListApp

final class UserDefaultManagerTests: XCTestCase {
    
    var userDefaultsManager: UserDefaultsManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        userDefaultsManager = UserDefaultsManager.shared
        cancellables = Set<AnyCancellable>()
        UserDefaults.standard.removeObject(forKey: userDefaultsManager.favoritesKey)
    }
    
    override func tearDown() {
        userDefaultsManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSaveFavorite() {
        let movieID = "tt1234567"
        userDefaultsManager.saveFavorite(movieID: movieID)
        XCTAssertTrue(userDefaultsManager.isFavorite(movieID: movieID))
    }
    
    func testRemoveFavorite() {
        let movieID = "tt1234567"
        userDefaultsManager.saveFavorite(movieID: movieID)
        userDefaultsManager.removeFavorite(movieID: movieID)
        XCTAssertFalse(userDefaultsManager.isFavorite(movieID: movieID))
    }
    
    func testIsFavoritePublisher() {
        let movieID = "tt1234567"
        let expectation = self.expectation(description: "Favorite status should change")
        
        userDefaultsManager.isFavoritePublisher(movieID: movieID)
            .sink { isFavorite in
                if isFavorite {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        userDefaultsManager.saveFavorite(movieID: movieID)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetFavorites() {
        let movieID1 = "tt1234567"
        let movieID2 = "tt7654321"
        
        userDefaultsManager.saveFavorite(movieID: movieID1)
        userDefaultsManager.saveFavorite(movieID: movieID2)
        
        let favorites = userDefaultsManager.getFavorites()
        XCTAssertEqual(favorites.count, 2)
        XCTAssertTrue(favorites.contains(movieID1))
        XCTAssertTrue(favorites.contains(movieID2))
    }
}
