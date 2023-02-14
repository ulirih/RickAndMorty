//
//  CharacterViewCell.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 13.02.2023.
//

import UIKit
import Kingfisher

class CharacterViewCell: UITableViewCell {
    static let reusableId = "CharacterViewCell"
    
    private var container: UIView = UIView()
    private let cornerRadius: CGFloat = 10

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setuppView()
        setupConstraints()
    }
    
    func configure(model: CharacterModel) {
        nameLabel.text = model.name
        image.kf.setImage(with: URL(string: model.image))
        locationLabel.text = "Location: \(model.location.name)"
        speciesLabel.text = "Species: \(model.species)"
    }
    
    private func setuppView() {
        contentView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        container.backgroundColor = .white
        container.layer.cornerRadius = cornerRadius
        container.layer.shadowColor = UIColor.gray.cgColor
        container.layer.shadowOpacity = 0.6
        container.layer.shadowOffset = CGSize(width: 1, height: 4)
        container.layer.shadowRadius = 7

        container.addSubview(image)
        container.addSubview(nameLabel)
        container.addSubview(locationLabel)
        container.addSubview(speciesLabel)
        addSubview(container)
    }
    
    private func setupConstraints() {
        container.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(14)
        }
        
        image.snp.makeConstraints { make in
            make.top.bottom.equalTo(container)
            make.leading.equalTo(container)
            make.width.equalTo(image.snp.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(container.snp.top).offset(8)
            make.leading.equalTo(image.snp.trailing).offset(14)
            make.trailing.equalTo(container).offset(-16)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(image.snp.trailing).offset(14)
            make.trailing.equalTo(container).offset(-16)
        }
        
        speciesLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(8)
            make.leading.equalTo(image.snp.trailing).offset(14)
            make.trailing.equalTo(container).offset(-16)
        }
    }
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        // TODO: fix img corner on cell
        image.layer.cornerRadius = 10
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemOrange
        
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        
        return label
    }()
    
    private let speciesLabel: UILabel = {
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
