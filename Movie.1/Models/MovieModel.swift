//
//  MovieModel.swift
//  Movie.1
//
//  Created by Мария Аверина on 17.12.2021.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [MovieModel]
}

// MARK: - MovieModel
struct MovieModel: Decodable {
    var backdropPath: String?
    var id: Int
    var originalLanguage: String
    var originalTitle: String
    var overview: String?
    var popularity: Double
    var posterPath, releaseDate, title: String
    var voteCount: Int
    var poster: String?
    var voteAverage: Double
    var posterImageData: Data?

    enum CodingKeys: String, CodingKey {
        case id, title
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

