//
//  UIImageViewExtensionTests.swift
//  MoviesListAppTests
//
//  Created by Adnan Ansari on 14/07/24.
//

import XCTest
@testable import MoviesListApp

final class UIImageViewExtensionTests: XCTestCase {
    
    func testLoadPosterImage() {
        let imageView = UIImageView()
        let expectation = self.expectation(description: "Image should be loaded")
        
        let urlString = "https://m.media-amazon.com/images/M/MV5BNjM0NTc0NzItM2FlYS00YzEwLWE0YmUtNTA2ZWIzODc2OTgxXkEyXkFqcGdeQXVyNTgwNzIyNzg@._V1_SX300.jpg"
        imageView.loadPosterImage(from: urlString)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(imageView.image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
