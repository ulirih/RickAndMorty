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
    var favorites: PassthroughSubject<[FavoriteEntity], Never> { get }
    
    func fetchData() -> Void
    func logout() -> Void
}

class UserViewModel: UserViewModelProtocol {
    private var authService: AuthServiceProtocol
    private var favoriteService: FavoritesServiceProtocol
    private weak var coordinator: AppCoordinatorProtocol?
    
    var user: PassthroughSubject<UserEntity, Never> = PassthroughSubject()
    var favorites: PassthroughSubject<[FavoriteEntity], Never> = PassthroughSubject()
    
    init(authService: AuthServiceProtocol, favoriteService: FavoritesServiceProtocol, coordinator: AppCoordinatorProtocol) {
        self.authService = authService
        self.favoriteService = favoriteService
        self.coordinator = coordinator
    }
    
    func fetchData() {
        let user = authService.user!
        self.user.send(user)
        let favorites = favoriteService.getFavorites(user: user)
        self.favorites.send(favorites)
    }
    
    func logout() {
        authService.logout()
        coordinator?.resetToLogIn()
    }
}
