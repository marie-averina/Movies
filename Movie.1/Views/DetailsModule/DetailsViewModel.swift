//
//  DetailsViewModel.swift
//  Movie.1
//
//  Created by Мария Аверина on 05.09.2022.
//

import Foundation
import Alamofire

final class DetailsViewModel {
    
    //MARK: - Public properties
    var reloadData: ((MovieModel)->())?
    var reloadImageData: ((Data)->())?
    var updateLoadingStatus: (()->())?
    var updateImageLoadingStatus: (()->())?
    var onErrorHandling : ((String) -> Void)?
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var isImageLoading: Bool = false {
        didSet {
            self.updateImageLoadingStatus?()
        }
    }
    
    //MARK: - Private properties
    private let apiManager: APIManagerProtocol?
    
    //MARK: - Initialization
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Public methods
    func initFetchProcess(id: String) {
        isLoading = true
        
        do {
            try self.apiManager?.getFilmById(id: id) { [weak self] movie in
                self?.isLoading = false
                DispatchQueue.main.async {
                    self?.reloadData?(movie)
                }
            }
            
        } catch let error {
            if let requestError = error as? RequestErrors {
                onErrorHandling?(requestError.rawValue)
            } else {
                onErrorHandling?("Unknown error")
            }
        }
    }
    
   func loadImage(posterPath: String) {
        let futureImageData = ImageData(posterPath: posterPath)
        isImageLoading = true
        
        do {
            try futureImageData.loadImage { [weak self] imageData in
                self?.isImageLoading = false
                DispatchQueue.main.async {
                    self?.reloadImageData?(imageData)
                }
            }
        } catch let error {
            if let requestError = error as? RequestErrors {
                onErrorHandling?(requestError.rawValue)
            } else {
                onErrorHandling?("Unknown error")
            }
        }
    }
}


