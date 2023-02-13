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
            .catch { error in
                return Fail(error: ApiServiceError.connectionError).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}


