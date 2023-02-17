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
    var isFavorite: PassthroughSubject<Bool, Never> { get set }
    var detailCharacter: PassthroughSubject<CharacterModel, Never> { get set }
    var alsoCharacters: PassthroughSubject<[CharacterModel], Never> { get set }
    var error: PassthroughSubject<ApiServiceError, Never> { get set }
    var characterId: Int? { get set }
    
    func fetchData() -> Void
    func toggleFavorite(character: CharacterModel) -> Void
    func didSelectCharacter(character: CharacterModel) -> Void
}


class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    var isLoading: PassthroughSubject<Bool, Never>
    var isFavorite: PassthroughSubject<Bool, Never>
    var detailCharacter: PassthroughSubject<CharacterModel, Never>
    var alsoCharacters: PassthroughSubject<[CharacterModel], Never>
    var error: PassthroughSubject<ApiServiceError, Never>
    var characterId: Int?

    private let service: ApiServiceProtocol
    private weak var coordinator: AppCoordinatorProtocol?
    private let favoriteService: FavoritesServiceProtocol
    private let auth: AuthServiceProtocol
    private var isSaved: Bool = false
    private var cancellable: [AnyCancellable] = []
    
    init(service: ApiServiceProtocol, favoriteService: FavoritesServiceProtocol, authService: AuthServiceProtocol,
         coordinator: AppCoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
        self.favoriteService = favoriteService
        self.auth = authService
        
        isLoading = PassthroughSubject<Bool, Never>()
        isFavorite = PassthroughSubject<Bool, Never>()
        detailCharacter = PassthroughSubject<CharacterModel, Never>()
        alsoCharacters = PassthroughSubject<[CharacterModel], Never>()
        error = PassthroughSubject<ApiServiceError, Never>()
    }
    
    public func fetchData() {
        fetchCharacterDetail()
        fetchFavorite()
        fetchAlsoCharacters()
    }
    
    public func toggleFavorite(character: CharacterModel) {
        do {
            if isSaved {
                try favoriteService.removeFromFavorite(item: character)
            } else {
                try favoriteService.addToFavorite(item: character, user: auth.user!)
            }
            
            isSaved.toggle()
            self.isFavorite.send(isSaved)
        } catch {
            self.error.send(.internalError)
        }
    }
    
    func didSelectCharacter(character: CharacterModel) {
        coordinator?.goToCharacterDetail(character: character)
    }
    
    private func fetchCharacterDetail() {
        isLoading.send(true)
        service.getCharacterDetail(id: characterId!)
            .sink { [unowned self] complettionType in
                if case .failure(let error) = complettionType {
                    self.isLoading.send(false)
                    self.error.send(error)
                }
            } receiveValue: { [unowned self] character in
                self.isLoading.send(false)
                self.detailCharacter.send(character)
            }
            .store(in: &cancellable)
    }
    
    private func fetchAlsoCharacters() {
        service.getCharacters(page: 1)
            .sink { complettionType in
                if case .failure(let error) = complettionType {
                    print(error.localizedDescription)
                }
            } receiveValue: { [unowned self] data in
                self.alsoCharacters.send(data.results)
            }
            .store(in: &cancellable)
    }
    
    private func fetchFavorite() {
        let favorites = favoriteService.getFavorites(user: auth.user!)
        isSaved = favorites.contains { favorite in favorite.characterId == String(self.characterId!) }
        self.isFavorite.send(isSaved)
    }
    
}
