//
//  RMTextField.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 19.02.2023.
//

import UIKit
import SnapKit

class RMTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
    var label = UILabel()

    init(labelText: String) {
        super.init(frame: .zero)
        
        setupSettings()
        
        label.textColor = .secondaryLabel
        label.text = labelText
        label.font = .boldSystemFont(ofSize: 12)
        
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(12)
        }

        snp.makeConstraints { make in
            make.height.equalTo(64)
        }
    }
    
    private func setupSettings() {
        backgroundColor = .secondarySystemBackground
        placeholder = ""
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBackground.cgColor
        clipsToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
