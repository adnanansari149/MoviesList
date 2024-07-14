//
//  MovieSearchResultModel.swift
//  MoviesListApp
//
//  Created by Adnan Ansari on 13/07/24.
//

import Foundation

struct MovieSearchResultModel: Codable {
    let search: [Movies]

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
    
    init(search: [Movies]) {
        self.search = search
    }
}

struct Movies: Codable {
    
    let title: String?
    let year: String?
    let imdbID: String?
    let type: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
    
    init(title: String, year: String, imdbID: String, type: String, poster: String) {
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.type = type
        self.poster = poster
    }
}
