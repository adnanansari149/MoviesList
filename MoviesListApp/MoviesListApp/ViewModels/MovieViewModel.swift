//
//  MovieViewModel.swift
//  MoviesListApp
//
//  Created by Adnan Ansari on 13/07/24.
//

import Foundation
import Combine
import UIKit

class MoviesViewModel {
    @Published var movies: [MovieViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMovies(searchTerm: String) {
        NetworkManager.shared.fetchMovies(searchTerm: searchTerm)
            .map { $0.map { MovieViewModel(movie: $0) } }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.movies, on: self)
            .store(in: &cancellables)
    }
    
    func fetchMovieDetails(imdbID: String) -> AnyPublisher<MovieDetailsViewModel, Error> {
        return NetworkManager.shared.fetchMovieDetails(imdbID: imdbID)
            .map { MovieDetailsViewModel(movieDetail: $0) }
            .eraseToAnyPublisher()
    }
}

struct MovieViewModel {
    
    let title: String
    let year: String
    let imdbID: String
    let posterURL: String
    let type: String

    init(movie: Movies) {
        self.title = movie.title ?? ""
        self.year = movie.year ?? ""
        self.imdbID = movie.imdbID ?? ""
        self.type = movie.type ?? ""
        self.posterURL = movie.poster ?? ""
    }
    
    // Function to load the poster image with Combine
    func loadPosterImage() -> AnyPublisher<UIImage?, Never> {
        guard let url = URL(string: posterURL) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in UIImage(data: data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
