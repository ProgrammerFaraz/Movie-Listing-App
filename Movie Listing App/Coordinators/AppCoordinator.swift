//
//  AppCoordinator.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import SwiftUI

protocol Coordinator: ObservableObject {
    var path: NavigationPath { get set }
    func start()
}

class AppCoordinator: Coordinator {
    @Published var path = NavigationPath()
    
    func start() {
        // Initial setup if needed
    }
    
    func showDetails(for movie: Movie) {
        path.append(movie)
    }
}
