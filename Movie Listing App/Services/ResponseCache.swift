//
//  ResponseCache.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import Foundation

actor ResponseCache {
    static let shared = ResponseCache()
    private var cache: [String: [Movie]] = [:]
    
    func getMovies(for key: String) -> [Movie]? {
        return cache[key]
    }
    
    func save(movies: [Movie], for key: String) {
        cache[key] = movies
    }
    
    func clear() {
        cache.removeAll()
    }
}
