//
//  MovieDetailsViewController.swift
//  MoviesListApp
//
//  Created by Adnan Ansari on 13/07/24.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
   
    //MARK: - Outlets
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var movieImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var movieViewModel: MovieDetailsViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel = movieViewModel else { return }
        viewModel.$title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.headingLabel.text = title
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)
        
        viewModel.$plot
            .receive(on: DispatchQueue.main)
            .sink { [weak self] plot in
                self?.descriptionTextView.text = plot
            }
            .store(in: &cancellables)
        
        viewModel.$genre
            .receive(on: DispatchQueue.main)
            .sink { [weak self] genre in
                self?.genreLabel.text = genre
            }
            .store(in: &cancellables)
        
        viewModel.$imdbRating
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rating in
                self?.ratingLabel.text = rating
            }
            .store(in: &cancellables)
        
        viewModel.$posterURL
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                self?.movieImgView.loadPosterImage(from: url)
            }
            .store(in: &cancellables)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
