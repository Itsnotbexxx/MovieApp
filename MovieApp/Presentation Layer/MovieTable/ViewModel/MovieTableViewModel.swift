//
//  MovieTableViewModel.swift
//  MovieApp
//
//  Created by Бексултан Нурпейс on 16.05.2022.
//

import Foundation
import UIKit

class MovieTableViewModel{
    var movies: [CellConfigurator] = []
    let movieService: MovieService
    var currentPage = 1
    var isRequestPerforming = false
    var didLoadTableItems: (() -> Void)?
    
    init(movieService: MovieService){
        self.movieService = movieService
    }
    
    func fetchPopularMovies(){
        isRequestPerforming = true
        
        movieService.getPopularMovies(page: currentPage, success: { [weak self] (movie, image) in
            if let image = image {
                self?.movies.append(ImageCellConfigurator(item: image))
            } else {
                self?.movies.append(ImageCellConfigurator(item: UIImage(named: "placeholder")!))
            }
            self?.movies.append(MovieNameCellConfigurator(item: movie))
            
            DispatchQueue.main.async {
                self?.didLoadTableItems?()
            }
        }, failure: { (error) in
            print("Error while requesting a popular movies, with message \(error)")
        })
        isRequestPerforming = false
        currentPage += 1
    }
}
