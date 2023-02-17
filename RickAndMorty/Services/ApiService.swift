//
//  ApiService.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 13.02.2023.
//

import Foundation
import Combine

enum ApiServiceError: Error {
    case connectionError
    case incorrectUrl
    case parseError
    case internalError
    
    func getDefaultTextError() -> String {
        switch self {
        case .connectionError:
            return "No internet connection"
        case .incorrectUrl, .parseError, .internalError:
            return "Something went wrong"
        }
    
    }
}

protocol ApiServiceProtocol {
    func getCharacters(page: Int8) -> AnyPublisher<CharactersListModel, ApiServiceError>
    func getCharacterDetail(id: Int) -> AnyPublisher<CharacterModel, ApiServiceError>
}

class ApiService: ApiServiceProtocol {
    
    func getCharacterDetail(id: Int) -> AnyPublisher<CharacterModel, ApiServiceError> {
        let urlString = "https://rickandmortyapi.com/api/character/\(id)"
        return baseRequest(for: urlString)
    }
    
    func getCharacters(page: Int8) -> AnyPublisher<CharactersListModel, ApiServiceError> {
        let urlString = "https://rickandmortyapi.com/api/character/?page=\(page)"
        return baseRequest(for: urlString)
    }
    
    private func baseRequest<T: Decodable>(for urlString: String) -> AnyPublisher<T, ApiServiceError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiServiceError.incorrectUrl).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .catch { (error) -> AnyPublisher<T, ApiServiceError> in
                if !NetworkState.shared.isConnected {
                    return Fail(error: ApiServiceError.connectionError).eraseToAnyPublisher()
                }
                return Fail(error: ApiServiceError.parseError).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}


