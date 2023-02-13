//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 13.02.2023.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
    func goToCharactersListVC()
}

class AppCoordinator: AppCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToCharactersListVC()
    }
    
    func goToCharactersListVC() {
        navigationController.pushViewController(CharactersListViewController(), animated: false)
    }
}
