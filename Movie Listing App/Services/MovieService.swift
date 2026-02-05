//
//  MovieService.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import Foundation

protocol MovieServiceProtocol {
    func searchMovies(query: String, page: Int, year: String?) async throws -> [Movie]
}

class MovieService: MovieServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchMovies(query: String, page: Int, year: String? = nil) async throws -> [Movie] {
        var components = URLComponents(string: Constants.baseURL)
        var queryItems = [
            URLQueryItem(name: "apikey", value: Constants.apiKey),
            URLQueryItem(name: "s", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "type", value: "movie") // Restrict to movies
        ]
        
        if let year = year, !year.isEmpty {
            queryItems.append(URLQueryItem(name: "y", value: year))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        let decodedResponse = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
        
        if decodedResponse.response == "False" {
            throw NetworkError.serverError(decodedResponse.error ?? "Unknown API Error")
        }
        
        return decodedResponse.search ?? []
    }
}
