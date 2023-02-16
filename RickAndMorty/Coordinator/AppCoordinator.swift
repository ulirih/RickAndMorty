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
    func goToLogin()
    func goToRegistration()
    func goToCharactersList()
    func goToCharacterDetail(character model: CharacterModel)
}

class AppCoordinator: AppCoordinatorProtocol {
    
    private let authService = AuthService.shared
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        authService.checkUser()
        print(authService.isAuthorized)
        if authService.isAuthorized {
            goToCharactersList()
        } else {
            goToLogin()
        }
    }
    
    func goToLogin() {
        let loginVC = LoginViewController()
        loginVC.viewModel = LoginViewModel(authService: authService, coordinator: self)
        
        push(controller: loginVC, animated: false)
    }
    
    func goToRegistration() {
        push(controller: RegistrationViewController())
    }
    
    func goToCharactersList() {
        let viewModel = CharactersListViewModel(service: ApiService(), coordinator: self)
        let controller = CharactersListViewController()
        controller.viewModel = viewModel
        
        push(controller: controller, animated: false)
    }
    
    func goToCharacterDetail(character model: CharacterModel) {
        let vc = CharacterDetailViewController()
        vc.character = model
        vc.viewModel = CharacterDetailViewModel(service: ApiService(), coordinator: self)
        
        // if prevoius screen is the same, remove it
        if navigationController.viewControllers.last is CharacterDetailViewController {
            push(controller: vc)
            
            var navigationStack = navigationController.viewControllers
            navigationStack.remove(at: navigationStack.count - 2)
            navigationController.viewControllers = navigationStack
            
            return
        }
        
        push(controller: vc)
    }
    
    private func push(controller: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(controller, animated: animated)
    }
}
