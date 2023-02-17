//
//  RegistrationViewModel.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 17.02.2023.
//

import Foundation
import Combine

protocol RegistrationViewModelProtocol: AnyObject {
    var error: PassthroughSubject<String, Never> { get }
    
    func registration(email: String, password: String, name: String) -> Void
}

class RegistrationViewModel: RegistrationViewModelProtocol {
    private var authService: AuthServiceProtocol
    private weak var coordinator: AppCoordinatorProtocol?
    
    var error: PassthroughSubject<String, Never> = PassthroughSubject()
    
    init(authService: AuthServiceProtocol, coordinator: AppCoordinatorProtocol) {
        self.authService = authService
        self.coordinator = coordinator
    }
    
    func registration(email: String, password: String, name: String) {
        error.send("")
        do {
            _ = try authService.register(email: email, password: password, name: name)
            coordinator?.goToCharactersList()
        } catch {
            self.error.send("User already exist")
        }
    }
}
