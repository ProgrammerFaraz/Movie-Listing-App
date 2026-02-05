//
//  Movie.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import Foundation

struct Movie: Identifiable, Codable, Equatable, Hashable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    var id: String { imdbID }
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
