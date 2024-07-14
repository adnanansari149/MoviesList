//
//  NetworkManager.swift
//  MoviesListApp
//
//  Created by Adnan Ansari on 13/07/24.
//

import Foundation
import Combine

// created Network Manager to handle the API calls
class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "b4af4eaf"
    private let baseURL = "https://www.omdbapi.com/"
    
    private init() {}
    
    // Generic function to fetch the API response using Combine
    private func fetch<T: Decodable>(urlString: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchMovies(searchTerm: String) -> AnyPublisher<[Movies], Error> {
        let urlString = "\(baseURL)?s=\(searchTerm)&apikey=\(apiKey)"
        return fetch(urlString: urlString)
            .map { (result: MovieSearchResultModel) in result.search }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetails(imdbID: String) -> AnyPublisher<MovieDetailModel, Error> {
        let urlString = "\(baseURL)?i=\(imdbID)&apikey=\(apiKey)"
        return fetch(urlString: urlString)
    }
}
