//
//  MoviewAboutViewController.swift
//  MovieApp
//
//  Created by Бексултан Нурпейс on 16.05.2022.
//

import UIKit

class MovieAboutViewController: UIViewController {

    private let viewModel: MovieAboutViewModel
    
    init(viewModel:MovieAboutViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backDropImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let movieTitleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    private let movieReleaseData: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let movieTaglineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let moviewOverviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
        
    private lazy var stackViewMain: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieTitleLable, movieReleaseData,  movieTaglineLabel, moviewOverviewLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setUp()
        fetchImage()
        fetchMovie()
        bindViewModel()
    }

    
    private func setUp(){
        view.addSubview(backDropImage)
        view.addSubview(backDropImage)
        backDropImage.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(UIScreen.main.bounds.height / 2)
        }
        
        view.addSubview(stackViewMain)
        stackViewMain.snp.makeConstraints {
            $0.top.equalTo(backDropImage.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            
        }
        
    }
    
    private func fetchImage(){
        viewModel.fetchBackdropImage()
        viewModel.fetchPosterImage()
    }
    
    private func fetchMovie(){
        viewModel.fetchMovie()
    }
    
    private func bindViewModel(){
        viewModel.updateBackdropImage = { [weak self] in
            self?.backDropImage.image = self?.viewModel.backDropImage
        }
        
        viewModel.didLoadDetails = { [weak self] in
            self?.movieTitleLable.text = self?.viewModel.title
            self?.movieTaglineLabel.text = self?.viewModel.tagline
            self?.moviewOverviewLabel.text = self?.viewModel.overview
            self?.movieReleaseData.text = self?.viewModel.releaseData
        }
    }
}
