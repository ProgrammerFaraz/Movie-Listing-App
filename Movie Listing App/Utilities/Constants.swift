//
//  Constants.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import Foundation

struct Constants {
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    static let baseURL = "http://www.omdbapi.com/"
}
