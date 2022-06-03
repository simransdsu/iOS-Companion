//
//  PetFinderAuthenticationInteractor.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import Foundation

protocol PetFinderAuthenticationRepositoryProtocol {
    
    func authenticate() async throws -> PetFinderAuthenticationAPIResponse
    func getCompanions() async throws -> [Companion]
}

struct PetFinderAuthenticationRepository: PetFinderAuthenticationRepositoryProtocol {
    
    private var httpClient: PetFinderHttpProtocol
    
    init(httpClient: PetFinderHttpProtocol = PetFinderHttpClient()) {
        self.httpClient = httpClient
    }
    
    func authenticate() async throws -> PetFinderAuthenticationAPIResponse {
        
        return try await httpClient.authenticate()
    }
    
    func getCompanions() async throws -> [Companion] {
        
        let companionsResponse: CompanionsAPIResponse = try await httpClient.GET(trial: 1)
        return companionsResponse.companions
    }
}
