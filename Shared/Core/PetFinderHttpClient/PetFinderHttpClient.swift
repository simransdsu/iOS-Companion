//
//  PetFinderHttpClient.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import Foundation


protocol PetFinderHttpProtocol {
    func authenticate() async throws -> PetFinderAuthenticationAPIResponse
    func GET<T: Codable>(trial: Int) async throws -> T
}

public struct PetFinderHttpClient: PetFinderHttpProtocol {
    
    private var client: NetworkingClientProtocol
    
    init(client: NetworkingClientProtocol = NetworkingClient()) {
        self.client = client
        self.client.keyDecodingStrategy = .convertFromSnakeCase
        self.client.dateDecodingStrategy = .iso8601
    }
    
    func authenticate() async throws -> PetFinderAuthenticationAPIResponse {
        
        guard let authenticateUrl = URL(string: PetFinderEndpoints.authenticate.rawValue) else {
            throw APIError.invalidUrl("Bad URL: \(PetFinderEndpoints.authenticate.rawValue)")
        }
        
        let (apiReponse, _) = try await client.makeRequest(type: PetFinderAuthenticationAPIResponse.self,
                                                           withMethod: .POST,
                                                           url: authenticateUrl,
                                                           body: [
                                                            "grant_type": "client_credentials",
                                                            "client_id": "A3EdieJqxYdRUmN8ZztykASUsT3WW2zVaqXdux0GeXVBSwNMQx",
                                                            "client_secret": "Xq4EjbONMzwOJxaXX6f2AwNhjprcdB9HMPvoarqY"
                                                           ],
                                                           queryParameters: [:],
                                                           headers: [:])
        return apiReponse
    }
    
    func GET<T: Codable>(trial: Int = 1) async throws -> T {
        guard let authenticateUrl = URL(string: PetFinderEndpoints.companions.rawValue) else {
            throw APIError.invalidUrl("Bad URL: \(PetFinderEndpoints.companions.rawValue)")
        }
        
        let accessToken = UserDefaults.standard.string(forKey: PetFinderKeys.accessToken.rawValue) ?? ""
        let (apiReponse, statusCode) = try await client.makeRequest(type: T.self,
                                                           withMethod: .GET,
                                                           url: authenticateUrl,
                                                           body: [:],
                                                           queryParameters: [:],
                                                        headers: ["Authorization": "Bearer \(accessToken)"])
        if statusCode == 401 {
            _ = try await authenticate()
            if trial <= 3 {
                let result: T = try await GET(trial: trial + 1)
                return result
            }
        } else if statusCode == 200 {
            return apiReponse
        }
        throw APIError.unknown("Something went wrong. Please try restarting your app.")
    }
}


public enum PetFinderEndpoints: String {
    
    case authenticate = "https://api.petfinder.com/v2/oauth2/token"
    case companions = "https://api.petfinder.com/v2/companions"
    
}
