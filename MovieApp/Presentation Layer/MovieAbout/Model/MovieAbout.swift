//
//  MovieAbout.swift
//  MovieApp
//
//  Created by Бексултан Нурпейс on 16.05.2022.
//

import Foundation

struct MovieAbout: Codable {
    let backdropPath: String?
    let  overview: String
    let posterPath: String?
    let releaseDate: String
    let tagline, title: String

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case tagline, title
    }
}
