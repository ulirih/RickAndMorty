//
//  CharacterDetailViewCell.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 14.02.2023.
//

import UIKit

class CharacterDetailViewCell: UITableViewCell {
    static let reusableId = "CharacterDetailViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
    }
    
    func configure(model: CharacterModel) {
        image.kf.setImage(with: URL(string: model.image))
        locationValueLabel.text = model.location.name
    }
    
    private func setupView() {
        contentView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        addSubview(image)
        addSubview(locationTitleLabel)
        addSubview(locationValueLabel)
    }

    private func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(180)
        }
        
        locationTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        locationValueLabel.snp.makeConstraints { make in
            make.top.equalTo(locationTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: Views
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()
    
    private let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemOrange
        label.text = "Location"
        
        return label
    }()
    
    private let locationValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
