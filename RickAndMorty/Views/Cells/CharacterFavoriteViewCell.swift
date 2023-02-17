//
//  CharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 17.02.2023.
//

import UIKit
import SnapKit
import Kingfisher

class CharacterFavoriteViewCell: UICollectionViewCell {
    static let reusableId = "CharacterFavoriteCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func configure(at model: FavoriteEntity) {
        nameLabel.text = model.name
        image.kf.setImage(with: URL(string: model.imageUrl!))
        locationLabel.text = model.locationName
    }
    
    private func setupViews() {
        addSubview(nameLabel)
        addSubview(image)
        addSubview(locationLabel)
        
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 6
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 3)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(image.snp.width).multipliedBy(0.7)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(8)
            make.top.equalTo(image.snp.bottom).offset(8)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(8)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
    }
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 6
        
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemOrange
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
