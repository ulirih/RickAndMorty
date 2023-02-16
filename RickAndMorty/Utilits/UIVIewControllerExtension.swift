//
//  UIVIewControllerExtension.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 16.02.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
