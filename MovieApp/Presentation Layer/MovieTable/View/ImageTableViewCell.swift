//
//  ImageTableViewCell.swift
//  MovieApp
//
//  Created by Бексултан Нурпейс on 16.05.2022.
//

import UIKit

typealias ImageCellConfigurator = TableCellConfigurator<ImageTableViewCell, UIImage>

class ImageTableViewCell: UITableViewCell, ConfigurableCell {
    
    typealias DataType = UIImage
    
    private let movieImageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        addSubview(movieImageView)
        movieImageView.snp.makeConstraints {
            $0.size.equalTo(UIScreen.main.bounds.height / 2)
            $0.edges.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data image: UIImage) {
        movieImageView.image = image
    }
}
