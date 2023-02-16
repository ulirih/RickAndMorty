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
    
    func getDefaultTextError() -> String {
        switch self {
        case .connectionError:
            return "No internet connection"
        case .incorrectUrl:
            return "Something went wrong"
        case .parseError:
            return "Something went wrong"
        }
    
    }
}

protocol ApiServiceProtocol {
    func getCharacters(page: Int8) -> AnyPublisher<CharactersListModel, ApiServiceError>
}

class ApiService: ApiServiceProtocol {
    
    func getCharacters(page: Int8) -> AnyPublisher<CharactersListModel, ApiServiceError> {
        let urlString = "https://rickandmortyapi.com/api/character/?page=\(page)"
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiServiceError.incorrectUrl).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CharactersListModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .catch { (error) -> AnyPublisher<CharactersListModel, ApiServiceError> in
                if !NetworkState.shared.isConnected {
                    return Fail(error: ApiServiceError.connectionError).eraseToAnyPublisher()
                }
                return Fail(error: ApiServiceError.parseError).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}


