//
//  Service.swift
//  MovieApp
//
//  Created by Бексултан Нурпейс on 14.05.2022.
//


import UIKit
import Alamofire
import AlamofireImage

protocol MovieService{
    func getPopularMovies(page: Int, success: @escaping (MovieTable, UIImage?) -> Void, failure: @escaping(Error) -> Void)
    func getMovieImage(path: String, success: @escaping(UIImage) -> Void, failure: @escaping(Error) -> Void)
    func getMovie(movieId: Int, success: @escaping(MovieAbout) -> Void, failure: @escaping(Error) -> Void)
}

class MovieServiceImplementation: MovieService{
    func getPopularMovies(page: Int, success: @escaping (MovieTable, UIImage?) -> Void, failure: @escaping (Error) -> Void) {
        let urlString = String(format: "%@/movie/popular", EndPoint.baseUrl)
        guard let url = URL(string: urlString) else {return}
        let query: Parameters = [
            "api_key": EndPoint.key,
            "language": EndPoint.language,
            "page": page
        ]
        AF.request(url, method: .get, parameters: query).responseDecodable { (dataResponse: DataResponse<MovieData, AFError>) in
            switch dataResponse.result{
            case .success(let wrapper):
                let movies = wrapper.results
                EndPoint.totalPages = wrapper.totalPages
                movies.forEach {
                    if let path = $0.posterPath{
                        if let urlImage = URL(string: String(format: "%@%@", EndPoint.imageBaseUrl, path)){
                            if let newData = try? Data(contentsOf: urlImage), let image = UIImage(data: newData){
                                success($0, image)
                            }
                        }
                    }else {
                        success($0, nil)
                    }
                }
            case .failure(let error): failure(error)
                
            }
        }
    }
    
    func getMovieImage(path: String, success: @escaping (UIImage) -> Void, failure: @escaping (Error) -> Void) {
        let urlString = String(format: "%@%@", EndPoint.imageBaseUrl, path)
        guard let url = URL(string: urlString) else { return }
        AF.request(url, method: .get).responseImage { (response) in
            switch response.result {
                case .success(let image):
                    success(image)
                case .failure(let error):
                    failure(error)
            }
        }
    }
    
    func getMovie(movieId: Int, success: @escaping (MovieAbout) -> Void, failure: @escaping (Error) -> Void) {
        let urlString = String(format: "%@/movie/%@", EndPoint.baseUrl, "\(movieId)")
        guard let url = URL(string: urlString) else { return }
        let query: Parameters = [
            "api_key": EndPoint.key,
            "language": EndPoint.language,
        ]
        AF.request(url, method: .get, parameters: query).responseDecodable { (dataResponse: DataResponse<MovieAbout, AFError>) in
            switch dataResponse.result {
             case .success(let detail):
                success(detail)
             case .failure(let error):
                failure(error)
            }
        }
    }
    
    private func parseMovieData(_ data: Data) -> MovieData? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(MovieData.self, from: data)
            let page = decodedData.page
            let totalResults = decodedData.totalResults
            let totalPages = decodedData.totalPages
            let results = decodedData.results
            let movieData = MovieData(page: page, results: results, totalResults: totalResults, totalPages: totalPages)
            return movieData
        } catch {
            print("Error while parsing a Movie data with message \(error)")
            return nil
        }
    }

    private func parseMovieDetails(_ data: Data) -> MovieAbout? {
        
        let decoder = JSONDecoder()
       
        do {
            let decodedData = try decoder.decode(MovieAbout.self, from: data)
            let backdropPath = decodedData.backdropPath
            let posterPath = decodedData.posterPath
            let overview = decodedData.overview
            let releaseData = decodedData.releaseDate
            let title = decodedData.title
            let tagline = decodedData.tagline
            let movieData = MovieAbout(backdropPath: backdropPath, overview: overview, posterPath: posterPath, releaseDate: releaseData, tagline: tagline, title: title)
            return movieData
        } catch {
            print("Error while parsing a Movie details with message \(error)")
            return nil
        }
    }
    
}
