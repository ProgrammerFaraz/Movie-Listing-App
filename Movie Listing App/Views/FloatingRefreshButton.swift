//
//  FloatingRefreshButton.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import SwiftUI

struct FloatingRefreshButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("New Movies Available")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(25)
            .shadow(radius: 5)
        }
        .padding(.top, 20)
    }
}
