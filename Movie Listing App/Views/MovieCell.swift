//
//  MovieCell.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader: ImageLoader
    
    init(url: String) {
        _loader = StateObject(wrappedValue: ImageLoader(url: URL(string: url)!))
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.gray.opacity(0.3)
                    .overlay(ProgressView())
            }
        }
        .task {
            await loader.load()
        }
    }
}

struct MovieCell: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            if let _ = URL(string: movie.poster), movie.poster != "N/A" {
                AsyncImageView(url: movie.poster)
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
                    .overlay(Text("No Image").font(.caption))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(movie.year)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
