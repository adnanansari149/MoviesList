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

//class NetworkManager {
//    static let shared = NetworkManager()
//    private let apiKey = "b4af4eaf"
//    private let baseURL = "https://www.omdbapi.com/"
//
//    private init() {}
//
//    func fetchMovies(searchTerm: String, completion: @escaping (Result<[Movies], Error>) -> Void) {
//        let urlString = "\(baseURL)?apikey=\(apiKey)&type=movie&s=\(searchTerm)"
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else { return }
//
//            do {
//                let searchResult = try JSONDecoder().decode(MovieSearchResultModel.self, from: data)
//                completion(.success(searchResult.search))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//    func fetchMovieDetails(imdbID: String, completion: @escaping (Result<MovieDetailModel, Error>) -> Void) {
//        let urlString = "\(baseURL)?i=\(imdbID)&apikey=\(apiKey)"
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else { return }
//
//            do {
//                let movieDetail = try JSONDecoder().decode(MovieDetailModel.self, from: data)
//                completion(.success(movieDetail))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}
