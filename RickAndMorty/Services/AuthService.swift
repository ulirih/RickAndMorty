//
//  AuthService.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 16.02.2023.
//

import Foundation

enum AuthError: Error {
    case notFoundUser
    case incorrectPassword
}

protocol AuthServiceProtocol: AnyObject {
    var isAuthorized: Bool { get }
    var user: UserEntity? { get }
    
    func checkUser() -> Void
    func login(email: String, password: String) throws -> Bool
    func register(email: String, password: String, name: String) throws -> Bool
    func logout() -> Void
}

class AuthService: AuthServiceProtocol {
    private let tokenKey = "userToken"
    private let defaults = UserDefaults.standard
    private var dbManager = CoreDataManager.shared
    
    static let shared = AuthService()
    
    var isAuthorized: Bool {
        return user != nil
    }
    
    var user: UserEntity? = nil
    
    private init() {}
    
    func checkUser() {
        guard let token = loadToken() else { return }
        
        let predicate = NSPredicate(format: "id == %@", token)
        let result = try? dbManager.getData(entityName: "UserEntity", predicate: predicate, sort: nil) as? [UserEntity]
        
        guard let user = result?.first else { return }
        self.user = user
    }
    
    func login(email: String, password: String) throws -> Bool {
        let predicate = NSPredicate(format: "email == %@", email)
        let result = try dbManager.getData(entityName: "UserEntity", predicate: predicate, sort: nil) as? [UserEntity]
        
        guard let user = result?.first else { throw AuthError.notFoundUser }
        guard user.password == password else { throw AuthError.incorrectPassword }
            
        self.user = user
        setToken(token: user.id?.uuidString)
        
        return true
    }
    
    func register(email: String, password: String, name: String) throws -> Bool {
        return false
    }
    
    func logout() {
        setToken(token: nil)
        user = nil
    }
    
    private func loadToken() -> String? {
        return defaults.string(forKey: tokenKey)
    }
    
    private func setToken(token: String?) {
        defaults.set(token, forKey: tokenKey)
    }
    
}
