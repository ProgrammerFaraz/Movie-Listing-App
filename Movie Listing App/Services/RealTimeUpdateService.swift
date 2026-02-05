//
//  RealTimeUpdateService.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import Foundation
import Combine

class RealTimeUpdateService: ObservableObject {
    let newMovieAvailable = PassthroughSubject<Void, Never>()
    private var timer: Timer?
    
    func startSimulation() {
        // Simulate a new movie event occurring randomly between 10 to 30 seconds
        let randomInterval = Double.random(in: 10...30)
        timer = Timer.scheduledTimer(withTimeInterval: randomInterval, repeats: true) { [weak self] _ in
            self?.newMovieAvailable.send()
        }
    }
    
    func stopSimulation() {
        timer?.invalidate()
        timer = nil
    }
}
