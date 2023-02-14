//
//  MoviesListViewModel.swift
//  Movie.1
//
//  Created by Мария Аверина on 22.09.2022.
//

import Foundation
import Alamofire


final class MoviesListViewModel {
    
    //MARK: - Public properties
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var numberOfCells: Int {
        return cellModels.count
    }
    
    var selectedMovie: MovieModel?
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var onErrorHandling : ((String) -> Void)?
    var cellModels = [MovieCellModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    //MARK: - Private properties
    private let apiManager: APIManagerProtocol
    private var movies = [MovieModel]()
    
    //MARK: - Initialization
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Public methods
    func fetchMovieList() {
        isLoading = true
        
        do {
            try self.apiManager.getFilms() { [weak self] movies in
                self?.isLoading = false
                self?.processFetchedMovies(movies: movies)
            }
        } catch let error {
            if let requestError = error as? RequestErrors {
                onErrorHandling?(requestError.rawValue)
            } else {
                onErrorHandling?("Unknown error")
            }
        }
    }
    
    func userPressed(at indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        self.selectedMovie = movie
    }

    //MARK: - Private methods
    private func getImageData(posterPath: String) -> Data {
        let futureImageData = ImageData(posterPath: posterPath)
        var imageData = Data()
        
        do {
         try futureImageData.loadImage() { data in
                imageData = data
            }
        } catch let error {
            if let requestError = error as? RequestErrors {
                onErrorHandling?(requestError.rawValue)
            } else {
                onErrorHandling?("Unknown error")
            }
        }
        return imageData
    }
    
    private func processFetchedMovies(movies: [MovieModel]) {
        self.movies = movies
        var cellModels = [MovieCellModel]()
        
        for movie in movies {
            do {
                try cellModels.append(createCellViewModel(movie: movie))
            } catch let error {
                if let requestError = error as? RequestErrors {
                    onErrorHandling?(requestError.rawValue)
                } else {
                    onErrorHandling?("Unknown error")
                }
            }
        }
        self.cellModels = cellModels
    }
    
    private func createCellViewModel(movie: MovieModel) throws -> MovieCellModel {
        let imageData = getImageData(posterPath: movie.posterPath)
        return MovieCellModel(titleText: movie.title,
                              rateText: String(movie.voteAverage),
                              yearText: movie.releaseDate,
                              imageData: imageData)
    }
}

