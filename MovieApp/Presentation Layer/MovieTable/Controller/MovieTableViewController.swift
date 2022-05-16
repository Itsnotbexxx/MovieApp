//
//  ViewController.swift
//  MovieApp
//
//  Created by Бексултан Нурпейс on 14.05.2022.
//

import UIKit
import SnapKit

class MovieTableViewController: UIViewController {
    
    private let viewModel: MovieTableViewModel
    
    init(viewModel: MovieTableViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemTeal
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        title = "Movies"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageCellConfigurator.reuseId)
        tableView.register(MovieNameTableViewCell.self, forCellReuseIdentifier: MovieNameCellConfigurator.reuseId)
        setUp()
        fetchPopularMovies()
        bindViewModel()
        
    }
    
    private func setUp(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func fetchPopularMovies(){
        viewModel.fetchPopularMovies()
    }
    
    private func bindViewModel(){
        viewModel.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    

}

extension MovieTableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let config = viewModel.movies[indexPath.row] as? MovieNameCellConfigurator {
            let selectedMovie = config.item
            let movieAboutViewModel = MovieAboutViewModel(movie: selectedMovie, movieService: MovieServiceImplementation())
            let page = MovieAboutViewController(viewModel: movieAboutViewModel)
            
            navigationController?.pushViewController(page, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ImageTableViewCell {
            cell.selectionStyle = .none
        }
        cell.contentView.layer.masksToBounds = true
    }
}
extension MovieTableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: item).reuseId)!
        cell.backgroundColor = .systemTeal
        item.configure(cell: cell)
        return cell
    }

}
