//
//  LoginViewModel.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 16.02.2023.
//

import Foundation
import Combine

protocol LoginViewModelProtocol: AnyObject {
    var error: PassthroughSubject<String, Never> { get set }
    
    func login(login: String, pasword: String) -> Void
    func goToRegistration() -> Void
}

class LoginViewModel: LoginViewModelProtocol {
    private var authService: AuthServiceProtocol
    private weak var coordinator: AppCoordinatorProtocol?
    
    var error: PassthroughSubject<String, Never> = PassthroughSubject()
    
    init(authService: AuthServiceProtocol, coordinator: AppCoordinatorProtocol) {
        self.authService = authService
        self.coordinator = coordinator
    }
    
    func login(login: String, pasword: String) {
        error.send("")
        do {
            _ = try authService.login(email: login, password: pasword)
            coordinator?.goToCharactersList()
        } catch {
            self.error.send("Incorrect login or password")
        }
    }
    
    func goToRegistration() {
        coordinator?.goToRegistration()
    }
}
