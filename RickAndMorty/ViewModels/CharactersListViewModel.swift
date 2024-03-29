//
//  CharactersListViewModel.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 13.02.2023.
//

import Foundation
import Combine

protocol CharactersListViewModelProtocol: AnyObject {
    
    var isLoading: PassthroughSubject<Bool, Never> { get set }
    var characters: PassthroughSubject<[CharacterModel], Never> { get set }
    var error: PassthroughSubject<ApiServiceError, Never> { get set }
    
    func fetchCharacters() -> Void
    func didSelectCharacter(character: CharacterModel) -> Void
    func didTapProfile() -> Void
}

class CharactersListViewModel: CharactersListViewModelProtocol {

    var isLoading: PassthroughSubject<Bool, Never>
    var characters: PassthroughSubject<[CharacterModel], Never>
    var error: PassthroughSubject<ApiServiceError, Never>
    
    private var cancellable: [AnyCancellable] = []
    private let service: ApiServiceProtocol
    private weak var coordinator: AppCoordinatorProtocol?
    
    private var currentPage: Int = 0
    private var isAllowLoadMore = true
    
    init(service: ApiServiceProtocol, coordinator: AppCoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
        
        isLoading = PassthroughSubject<Bool, Never>()
        characters = PassthroughSubject<[CharacterModel], Never>()
        error = PassthroughSubject<ApiServiceError, Never>()
    }
    
    func fetchCharacters() {
        guard isAllowLoadMore else { return }
        
        isLoading.send(true)
        currentPage += 1
        
        service.getCharacters(page: currentPage)
            .sink { [unowned self] complettionType in
                if case .failure(let error) = complettionType {
                    self.isLoading.send(false)
                    self.error.send(error)
                }
            } receiveValue: { [unowned self] data in
                self.isAllowLoadMore = data.info.pages > self.currentPage
                self.isLoading.send(false)
                self.characters.send(data.results)
            }
            .store(in: &cancellable)
    }
    
    func didSelectCharacter(character: CharacterModel) {
        coordinator?.goToCharacterDetail(character: character)
    }
    
    func didTapProfile() {
        coordinator?.goToProfile()
    }
}
