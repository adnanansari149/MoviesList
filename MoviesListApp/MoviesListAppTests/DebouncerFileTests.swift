//
//  DebouncerFileTests.swift
//  MoviesListAppTests
//
//  Created by Adnan Ansari on 14/07/24.
//

import XCTest
@testable import MoviesListApp

final class DebouncerFileTests: XCTestCase {
    
    func testDebounce() {
        let expectation = self.expectation(description: "Action should be debounced")
        
        let debouncer = Debouncer(delay: 0.5)
        var actionExecuted = false
        
        debouncer.debounce {
            actionExecuted = true
            expectation.fulfill()
        }
        XCTAssertFalse(actionExecuted)
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(actionExecuted)
        }
    }
}
