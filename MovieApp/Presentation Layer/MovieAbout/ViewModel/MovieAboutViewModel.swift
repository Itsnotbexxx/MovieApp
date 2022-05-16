//
//  MovieAboutViewModel.swift
//  MovieApp
//
//  Created by Бексултан Нурпейс on 16.05.2022.
//

import Foundation
import UIKit

class MovieAboutViewModel{
    
    let movie: MovieTable
    let movieService: MovieService
    var posterImage: UIImage?
    var backDropImage: UIImage?
    var title: String?
    var tagline: String?
    var overview: String?
    var releaseData: String?
    var didLoadDetails: (() -> Void)?
    var updatePosterImage: (() -> Void)?
    var updateBackdropImage: (() -> Void)?
    
    init(movie: MovieTable, movieService: MovieService){
        self.movie = movie
        self.movieService = movieService
    }
    
    func fetchMovie(){
        movieService.getMovie(movieId: movie.id,
                                     success: { [weak self] (movieAbout) in
            self?.title = movieAbout.title
            self?.tagline = movieAbout.tagline
            self?.overview = movieAbout.overview
            self?.releaseData = movieAbout.releaseDate
            self?.didLoadDetails?()
            }, failure: { (error) in
                print("Error while requestion a movie detail with message \(error)")
        })
    }
    
    func fetchPosterImage(){
        if let path = movie.posterPath {
            movieService.getMovieImage(path: path, success: { [weak self] (image) in
                self?.posterImage = image
                self?.updatePosterImage?()
                }, failure: { (error) in
                    print("Error while requestion a movie poster image with message \(error)")
            })
        } else {
            posterImage = UIImage(named: "placeholder")
            updatePosterImage?()
        }
    }
    
    func fetchBackdropImage(){
        if let path = movie.backdropPath {
            movieService.getMovieImage(path: path, success: { [weak self] (image) in
                self?.backDropImage = image
                self?.updateBackdropImage?()
                }, failure: { (error) in
                    print("Error while requestion a movie backdrop image with message \(error)")
            })
        } else {
            if let path = movie.posterPath {
                movieService.getMovieImage(path: path, success: { [weak self] (image) in
                    self?.backDropImage = image
                    self?.updateBackdropImage?()
                    }, failure: { (error) in
                        print("Error while requestion a movie backdrop image with message \(error)")
                })
            } else {
                backDropImage = UIImage(named: "placeholder")
                updatePosterImage?()
            }
            
        }
    }
}
