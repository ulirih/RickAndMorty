//
//  CharacterStatusView.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 15.02.2023.
//

import UIKit
import SnapKit

class CharacterStatusView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    var status: CharacterStatus = CharacterStatus.unknown {
        didSet {
            statusTextLabel.text = status.rawValue
            circleView.backgroundColor = getStatusColor(status)
        }
    }
    
    private func setupView() {
        addSubview(circleView)
        addSubview(statusTextLabel)
    }
    
    private func setupConstraints() {
        circleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(statusTextLabel)
        }
        
        statusTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(circleView.snp.trailing).offset(6)
        }
    }
    
    private func getStatusColor(_ status: CharacterStatus) -> UIColor {
        if status == .alive {
            return .systemGreen
        } else if status == .dead {
            return .systemRed
        }
        return .systemGray
    }
    
    // MARK: Views
    private let statusTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        
        return label
    }()
    
    private let circleView: UIView = {
        let circleSize = 10
        
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.width.equalTo(circleSize)
        }
        view.layer.cornerRadius = CGFloat(circleSize / 2)
        view.backgroundColor = .systemGray
        
        return view
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
