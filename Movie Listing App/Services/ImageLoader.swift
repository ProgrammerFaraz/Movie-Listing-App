//
//  ImageLoader.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import SwiftUI

actor ImageCache {
    static let shared = ImageCache()
    private var cache: [URL: UIImage] = [:]
    
    func image(for url: URL) -> UIImage? {
        return cache[url]
    }
    
    func insert(_ image: UIImage, for url: URL) {
        cache[url] = image
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    @MainActor
    func load() async {
        if let cached = await ImageCache.shared.image(for: url) {
            self.image = cached
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                await ImageCache.shared.insert(uiImage, for: url)
                self.image = uiImage
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}
