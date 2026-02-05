//
//  NetworkError.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case dataMissing
    case decodingError
    case serverError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid Response"
        case .dataMissing: return "Data Missing"
        case .decodingError: return "Failed to decode response"
        case .serverError(let message): return message
        case .unknown: return "Unknown Error"
        }
    }
}
