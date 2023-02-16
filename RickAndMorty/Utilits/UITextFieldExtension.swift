//
//  UITextFieldExtension.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 16.02.2023.
//

import Foundation
import UIKit
import Combine

extension UITextField {

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }
}
