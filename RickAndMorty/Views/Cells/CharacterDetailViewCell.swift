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
        speciesValueLabel.text = model.species
        statusView.status = model.status
    }
    
    private func setupView() {
        contentView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        addSubview(image)
        addSubview(locationTitleLabel)
        addSubview(locationValueLabel)
        addSubview(speciesTitleLabel)
        addSubview(speciesValueLabel)
        addSubview(statusTitleLabel)
        addSubview(statusView)
    }

    private func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(160)
        }
        
        locationTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        locationValueLabel.snp.makeConstraints { make in
            make.top.equalTo(locationTitleLabel.snp.bottom).offset(2)
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        speciesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(locationValueLabel.snp.bottom).offset(10)
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        speciesValueLabel.snp.makeConstraints { make in
            make.top.equalTo(speciesTitleLabel.snp.bottom).offset(2)
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        statusTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(speciesValueLabel.snp.bottom).offset(10)
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        statusView.snp.makeConstraints { make in
            make.top.equalTo(statusTitleLabel.snp.bottom).offset(2)
            make.leading.equalTo(image.snp.trailing).offset(12)
        }
    }
    
    // MARK: Views
    private let statusView = CharacterStatusView()
    
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
        label.text = "Location:"
        
        return label
    }()
    
    private let locationValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        
        return label
    }()
    
    private let speciesTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemOrange
        label.text = "Species:"
        
        return label
    }()
    
    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemOrange
        label.text = "Status:"
        
        return label
    }()
    
    private let speciesValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
