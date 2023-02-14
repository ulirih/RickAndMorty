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
    func goToCharacterDetail(character model: CharacterModel)
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
        let viewModel = CharactersListViewModel(service: ApiService(), coordinator: self)
        let controller = CharactersListViewController()
        controller.viewModel = viewModel
        
        push(controller: controller, animated: false)
    }
    
    func goToCharacterDetail(character model: CharacterModel) {
        let vc = CharacterDetailViewController()
        vc.character = model
        vc.coordinator = self
        
        push(controller: vc)
    }
    
    private func push(controller: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(controller, animated: animated)
    }
}
