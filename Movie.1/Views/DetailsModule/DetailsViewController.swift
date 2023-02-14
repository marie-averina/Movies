//
//  DetailsViewController.swift
//  Movie.1
//
//  Created by Мария Аверина on 09.02.2023.
//

import UIKit

class DetailsViewController: UIViewController {

    //MARK: - Private properties
    private var viewModel: DetailsViewModel?
    private var movieId: String?
    
    //MARK: - @IBOutlet
    @IBOutlet private var moviePosterImageView: UIImageView!
    @IBOutlet private var movieVoteAverageLabel: UILabel!
    @IBOutlet private var movieVoteCountLabel: UILabel!
    @IBOutlet private var moviePopularityLabel: UILabel!
    @IBOutlet private var movieDateLabel: UILabel!
    @IBOutlet private var movieLanguageLabel: UILabel!
    @IBOutlet private var movieOverviewLabel: UILabel!

    //MARK: - Initialization
    convenience init() {
        self.init(viewModel: nil, movieId: nil)
    }
        
    init(viewModel: DetailsViewModel?, movieId: String?) {
        self.viewModel = viewModel
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: DetailsViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
    }
    
    //MARK: - Private methods
    
    private func initViewModel() {
        guard let movieId = movieId else { return }
        
        updateLoadingStatus()
        updateData()
        viewModel?.onErrorHandling = { errorText in
            self.showAlert(title: "Error", message: errorText)
        }
        viewModel?.initFetchProcess(id: movieId)
    }
    
    private func updateLoadingStatus() {
        viewModel?.updateLoadingStatus = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let isLoading = self.viewModel?.isLoading ?? false
                if isLoading {
                    self.view.activityStartAnimating(activityColor: .red, backgroundColor: .white.withAlphaComponent(1))
                } else {
                    self.view.activityStopAnimating()
                }
            }
        }
        viewModel?.updateImageLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel?.isImageLoading ?? false
                if isLoading {
                    self?.moviePosterImageView.activityStartAnimating(activityColor: .white, backgroundColor: .red.withAlphaComponent(0.5))
                } else {
                    self?.moviePosterImageView.activityStopAnimating()
                }
            }
        }
    }

    private func updateData() {
        viewModel?.reloadData = { [weak self] viewData in
            self?.setupData(movie: viewData)
        }
        
        viewModel?.reloadImageData = { [weak self] imageData in
            self?.moviePosterImageView.load(data: imageData)
        }
    }
   
    private func setupData(movie: MovieModel) {
        self.navigationController?.navigationBar.topItem?.title = movie.title
        movieDateLabel.text = movie.releaseDate.convertToDisplayFormat()
        movieVoteAverageLabel.text = String(round(movie.voteAverage))
        movieLanguageLabel.text = movie.originalLanguage
        moviePopularityLabel.text = String(round(movie.popularity))
        movieOverviewLabel.text = movie.overview?.count != 0 ? movie.overview : "The description of the movie will be avaliable soon."
        movieVoteCountLabel.text = String(movie.voteCount)
        viewModel?.loadImage(posterPath: movie.posterPath)
    }

}
