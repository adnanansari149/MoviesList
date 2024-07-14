//
//  MainViewController.swift
//  MoviesListApp
//
//  Created by Adnan Ansari on 13/07/24.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Variables
    private var viewModel = MoviesViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // To handle multiple fast clicks on tableview cell
    var isPushingViewController = false
    
    // To create a delay after every button pressed to search on the searchbar
    let debouncer = Debouncer(delay: 0.8)
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        bindViewModel()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "MovieListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MovieListCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

//MARK: - TableView Delegate & Datasource
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as? MovieListCell else {
            return UITableViewCell()
        }
        let movieViewModel = viewModel.movies[indexPath.row]
        cell.configure(with: movieViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isPushingViewController else { return }
        isPushingViewController = true
        searchBar.resignFirstResponder()
        
        let movieViewModel = viewModel.movies[indexPath.row]
        
        viewModel.fetchMovieDetails(imdbID: movieViewModel.imdbID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isPushingViewController = false
                if case .failure(let error) = completion {
                    print("Failed to fetch movie details: \(error)")
                    self?.isPushingViewController = false
                }
            }, receiveValue: { [weak self] movieDetailsViewModel in
                let storyboard = UIStoryboard(name: "MovieDetailView", bundle: nil)
                if let detailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
                    detailsVC.movieViewModel = movieDetailsViewModel
                    self?.navigationController?.pushViewController(detailsVC, animated: true)
                }
            })
            .store(in: &cancellables)
    }
}

//MARK: - SearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
        debouncer.debounce {
            self.viewModel.fetchMovies(searchTerm: searchTerm)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
