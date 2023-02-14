//
//  MovieTableViewCell.swift
//  Movie.1
//
//  Created by Мария Аверина on 17.12.2021.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
 
    //MARK: - @IBOutlet
    @IBOutlet private var movieImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var rateLabel: UILabel!
    @IBOutlet private var yearLabel: UILabel!
    
    
    //MARK: - Public properties
    var movieCellViewModel : MovieCellModel? {
        didSet {
            guard let posterData = movieCellViewModel?.imageData else { return }
            nameLabel.text = movieCellViewModel?.titleText
            rateLabel.text = movieCellViewModel?.rateText
            yearLabel.text = movieCellViewModel?.yearText.convertToDisplayFormat()
            movieImageView.load(data: posterData)
        }
    }
}


