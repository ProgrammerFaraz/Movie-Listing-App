//
//  MovieSearchResponse.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import Foundation

struct MovieSearchResponse: Codable {
    let search: [Movie]?
    let totalResults: String?
    let response: String
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
}
