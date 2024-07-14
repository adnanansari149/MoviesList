//
//  MovieListCell.swift
//  MoviesListApp
//
//  Created by Adnan Ansari on 13/07/24.
//

import UIKit
import Combine

class MovieListCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var viewModel: MovieViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func configure(with viewModel: MovieViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        releaseDateLabel.text = viewModel.year
        
        // Subscribe to favorite state changes
        UserDefaultsManager.shared.isFavoritePublisher(movieID: viewModel.imdbID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                self?.updateFavoriteButton(isFavorite: isFavorite)
            }
            .store(in: &cancellables)
        
        // Load poster image with Combine
        viewModel.loadPosterImage()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.posterImageView.image = image
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Button Tapped
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        
        // Toggle favorite state and save to UserDefaults
        guard let viewModel = viewModel else { return }
        let isFavorite = UserDefaultsManager.shared.isFavorite(movieID: viewModel.imdbID)
        if isFavorite {
            UserDefaultsManager.shared.removeFavorite(movieID: viewModel.imdbID)
        } else {
            UserDefaultsManager.shared.saveFavorite(movieID: viewModel.imdbID)
        }
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
