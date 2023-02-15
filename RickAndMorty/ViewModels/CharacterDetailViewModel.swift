//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 15.02.2023.
//

import Foundation
import Combine

protocol CharacterDetailViewModelProtocol: AnyObject {
    var isLoading: PassthroughSubject<Bool, Never> { get set }
    var alsoCharacters: PassthroughSubject<[CharacterModel], Never> { get set }
    var error: PassthroughSubject<ApiServiceError, Never> { get set }
    
    func fetchAlsoCharacters() -> Void
    func didSelectCharacter(character: CharacterModel) -> Void
}


class CharacterDetailViewModel: CharacterDetailViewModelProtocol {

    var isLoading: PassthroughSubject<Bool, Never>
    var alsoCharacters: PassthroughSubject<[CharacterModel], Never>
    var error: PassthroughSubject<ApiServiceError, Never>
    
    private var cancellable: [AnyCancellable] = []
    private let service: ApiServiceProtocol
    private weak var coordinator: AppCoordinatorProtocol?
    
    init(service: ApiServiceProtocol, coordinator: AppCoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
        
        isLoading = PassthroughSubject<Bool, Never>()
        alsoCharacters = PassthroughSubject<[CharacterModel], Never>()
        error = PassthroughSubject<ApiServiceError, Never>()
    }
    
    func fetchAlsoCharacters() {
        isLoading.send(true)
        
        service.getCharacters(page: 1)
            .sink { [unowned self] complettionType in
                if case .failure(let error) = complettionType {
                    self.isLoading.send(false)
                    self.error.send(error)
                }
            } receiveValue: { [unowned self] data in
                self.isLoading.send(false)
                self.alsoCharacters.send(data.results)
            }
            .store(in: &cancellable)
    }
    
    func didSelectCharacter(character: CharacterModel) {
        coordinator?.goToCharacterDetail(character: character)
    }
}
