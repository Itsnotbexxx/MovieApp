//
//  MovieNameTableViewCell.swift
//  MovieApp
//
//  Created by Бексултан Нурпейс on 16.05.2022.
//

import UIKit

typealias MovieNameCellConfigurator = TableCellConfigurator<MovieNameTableViewCell, MovieTable>

class MovieNameTableViewCell: UITableViewCell, ConfigurableCell {
    typealias DataType = MovieTable

    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let movieDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        return button
    }()
    
    private lazy var stackViewLabel: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieTitleLabel, movieDateLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var StackViewMain: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackViewLabel, infoButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(StackViewMain)
        StackViewMain.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        infoButton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: MovieTable) {
        movieTitleLabel.text = data.title
        movieDateLabel.text = data.releaseDate
    }
    
}
