//
//  Movie_Listing_AppApp.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import SwiftUI

@main
struct Movie_Listing_AppApp: App {
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                MovieListView()
                    .environmentObject(coordinator)
                    .navigationDestination(for: Movie.self) { movie in
                        // Placeholder for detail view
                        VStack {
                            AsyncImageView(url: movie.poster)
                                .frame(height: 300)
                            Text(movie.title)
                                .font(.largeTitle)
                            Text("Year: \(movie.year)")
                            Spacer()
                        }
                    }
            }
        }
    }
}
