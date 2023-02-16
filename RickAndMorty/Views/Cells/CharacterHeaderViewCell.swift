//
//  CharacterHeaderViewCell.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 16.02.2023.
//

import UIKit
import SnapKit

class CharacterHeaderViewCell: UITableViewCell {
    
    static let reusableId = "CharacterHeaderViewCell"
    var titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    private func setupView() {
        addSubview(titleLabel)
        
        titleLabel.numberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(18)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
