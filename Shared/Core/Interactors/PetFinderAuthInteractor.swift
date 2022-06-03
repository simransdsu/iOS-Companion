//
//  PetFinderAuthInteractor.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import Foundation

protocol PetFinderAuthInteractable {
    func authenticate() async throws
    func getCompanions() async throws -> [Companion]
}

struct PetFinderAuthInteractor: PetFinderAuthInteractable {
    
    private let repository: PetFinderAuthenticationRepositoryProtocol
    
    init(repository: PetFinderAuthenticationRepositoryProtocol = PetFinderAuthenticationRepository()) {
        
        self.repository = repository
    }
    
    
    func authenticate() async throws {
        
        let response = try await repository.authenticate()
        saveAuthTokens(token: response.accessToken, expiresIn: response.expiresIn)
    }
    
    func getCompanions() async throws -> [Companion] {
        return try await repository.getCompanions()
    }
    
    private func saveAuthTokens(token: String, expiresIn: Int) {
        UserDefaults.standard.set(token, forKey: PetFinderKeys.accessToken.rawValue)
    }
}
