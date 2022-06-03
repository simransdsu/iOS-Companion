//
//  City.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import Foundation

struct City: Codable, Identifiable, Equatable {
    var id: String {
        return "\(city), \(country)"
    }
    let city: String
    let country: String
}
