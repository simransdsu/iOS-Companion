//
//  Companion.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import Foundation

struct Companion: Codable, Identifiable {
    let id: Int
//    let organizationId: String
    let type: String
    let species: String
    let age: String
    
    let photos: [Photo]
    let name: String
    let description: String?
    }

struct Photo: Codable {
    let small: String
    let medium: String
    let large: String
    let full: String
}
