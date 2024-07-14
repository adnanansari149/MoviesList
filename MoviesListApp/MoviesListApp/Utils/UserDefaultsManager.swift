//
//  UserDefaultsManager.swift
//  MoviesListApp
//
//  Created by Adnan Ansari on 13/07/24.
//

import Foundation
import Combine

// created UserDefault Manager to save/remove the favorite movie in UserDefaults.
class UserDefaultsManager {
    
    let favoritesKey = "favoriteMovies"
    static let shared = UserDefaultsManager()
    
    // A subject to publish changes to favorite state
    private var favoriteSubject = PassthroughSubject<String, Never>()
    
    // A publisher that emits changes to the favorite state
    func isFavoritePublisher(movieID: String) -> AnyPublisher<Bool, Never> {
        favoriteSubject
            .filter { $0 == movieID }
            .map { [weak self] _ in
                return self?.isFavorite(movieID: movieID) ?? false
            }
            .prepend(isFavorite(movieID: movieID))
            .eraseToAnyPublisher()
    }
    
    func saveFavorite(movieID: String) {
        var favorites = getFavorites()
        if !favorites.contains(movieID) {
            favorites.append(movieID)
            UserDefaults.standard.setValue(favorites, forKey: favoritesKey)
            favoriteSubject.send(movieID)
        }
    }
    
    func removeFavorite(movieID: String) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(of: movieID) {
            favorites.remove(at: index)
            UserDefaults.standard.setValue(favorites, forKey: favoritesKey)
            favoriteSubject.send(movieID)
        }
    }
    
    func getFavorites() -> [String] {
        return UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
    }
    
    func isFavorite(movieID: String) -> Bool {
        return getFavorites().contains(movieID)
    }
}
