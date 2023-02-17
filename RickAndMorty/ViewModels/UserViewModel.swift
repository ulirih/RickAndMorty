//
//  UserViewModel.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 17.02.2023.
//

import Foundation
import Combine

protocol UserViewModelProtocol: AnyObject {
    var user: PassthroughSubject<UserEntity, Never> { get }
    var favorites: PassthroughSubject<Favorites, Never> { get }
    
    func fetchData() -> Void
    func logout() -> Void
}

class UserViewModel: UserViewModelProtocol {
    private var authService: AuthServiceProtocol
    private weak var coordinator: AppCoordinatorProtocol?
    
    var user: PassthroughSubject<UserEntity, Never> = PassthroughSubject()
    var favorites: PassthroughSubject<Favorites, Never> = PassthroughSubject()
    
    init(authService: AuthServiceProtocol, coordinator: AppCoordinatorProtocol) {
        self.authService = authService
        self.coordinator = coordinator
    }
    
    func fetchData() {
        user.send(authService.user!)
    }
    
    func logout() {
        authService.logout()
        coordinator?.resetToLogIn()
    }
}
