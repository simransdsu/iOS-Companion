//
//  PetFinderAuthenticationAPIResponse.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import Foundation

struct PetFinderAuthenticationAPIResponse: Codable {
    
    var tokenType: String
    var expiresIn: Int
    var accessToken: String
}
