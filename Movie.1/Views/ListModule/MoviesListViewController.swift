//
//  ListViewController.swift
//  Movie.1
//
//  Created by Мария Аверина on 17.12.2021.
//

import UIKit

final class MoviesListViewController: UIViewController {
    
    //MARK: - Private properties
    private let viewModel: MoviesListViewModel
    
    //MARK: - @IBOutlet
    @IBOutlet private var movieTableView: UITableView!
    
    //MARK: - Initialization
    init(viewModel: MoviesListViewModel) {
        let viewModel = MoviesListViewModel()
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = MoviesListViewModel()
        
        super.init(coder: coder)
    }
    
    // MARK: ListViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        initViewModel()
    }
    
    @objc func didPullToRefresh(_ sender : UIRefreshControl) {
        view.activityStartAnimating(activityColor: .red, backgroundColor: .gray)
        movieTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.viewModel.fetchMovieList()
        }
    }
    
    //MARK: - Private methods
    private func initViewModel() {
        updateLoadingStatus()
        reloadTabView()
        handleErrors()
        viewModel.fetchMovieList()
    }
    
    private func updateLoadingStatus() {
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.view.activityStartAnimating(activityColor: .red, backgroundColor: .black.withAlphaComponent(0.5))
                } else {
                    self?.view.activityStopAnimating()
                }
            }
        }
    }
    
    private func reloadTabView() {
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.movieTableView.reloadData()
            }
        }
    }
    
    private func handleErrors() {
        viewModel.onErrorHandling = { [weak self] errorText in
            self?.showAlert(title: "Error", message: errorText)
        }
    }
}

    //MARK: - UITableViewDelegate, UITableViewDataSource
extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell
        else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.cellModels[indexPath.row]
        cell.movieCellViewModel = cellViewModel
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userPressed(at: indexPath)
        let movie = viewModel.selectedMovie
        guard let movieId = movie?.id else { return }
        
        let detailsViewModel = DetailsViewModel()
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel, movieId: String(movieId))
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
