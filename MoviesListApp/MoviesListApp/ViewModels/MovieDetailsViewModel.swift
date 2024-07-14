//
//  MovieDetailsViewModel.swift
//  MoviesListApp
//
//  Created by Adnan Ansari on 13/07/24.
//

import Foundation
import Combine

class MovieDetailsViewModel {
    
    // Published properties to update the view controller
    @Published var title: String = ""
    @Published var year: String = ""
    @Published var plot: String = ""
    @Published var genre: String = ""
    @Published var imdbRating: String = ""
    @Published var posterURL: String = ""
    @Published var imdbID: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(movieDetail: MovieDetailModel) {
        self.title = movieDetail.title ?? ""
        self.year = movieDetail.year ?? ""
        self.plot = movieDetail.plot ?? ""
        self.genre = movieDetail.genre ?? ""
        self.imdbRating = movieDetail.imdbRating ?? ""
        self.posterURL = movieDetail.poster ?? ""
        self.imdbID = movieDetail.imdbID ?? ""
    }
}
