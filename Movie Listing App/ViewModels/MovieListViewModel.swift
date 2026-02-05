//
//  MovieListViewModel.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import Foundation
import Combine

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasNewDataAvailable = false
    @Published var canLoadMore = true
    
    // Filter States
    @Published var searchQuery: String = "Marvel"
    @Published var filterYear: String = ""
    @Published var startDate: Date = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
    @Published var endDate: Date = Date()
    @Published var isDateFilterActive: Bool = false
    
    private let service: MovieServiceProtocol
    private let realTimeService: RealTimeUpdateService
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    private var currentTask: Task<Void, Never>?
    
    init(service: MovieServiceProtocol = MovieService(), realTimeService: RealTimeUpdateService = RealTimeUpdateService()) {
        self.service = service
        self.realTimeService = realTimeService
        
        setupRealTimeUpdates()
        
        // Debounce search
        $searchQuery
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.resetAndLoad()
            }
            .store(in: &cancellables)
            
        // Reload when year filter changes
        $filterYear
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.resetAndLoad()
            }
            .store(in: &cancellables)
    }
    
    func loadMovies(loadMore: Bool = false) {
        guard !isLoading else { return }
        if loadMore && !canLoadMore { return }
        
        isLoading = true
        errorMessage = nil
        
        if !loadMore {
            currentPage = 1
        }
        
        let pageToLoad = currentPage
        let query = searchQuery.isEmpty ? "Marvel" : searchQuery
        let year = filterYear
        
        // Check Cache
        let cacheKey = "\(query)-\(year)-\(pageToLoad)"
        currentTask?.cancel()
        currentTask = Task {
            if !loadMore {
                if let cachedMovies = await ResponseCache.shared.getMovies(for: cacheKey) {
                    self.movies = cachedMovies
                    self.isLoading = false
                    return
                }
            }
            
            do {
                let newMovies = try await service.searchMovies(query: query, page: pageToLoad, year: year)
                
                if loadMore {
                    self.movies.append(contentsOf: newMovies)
                } else {
                    self.movies = newMovies
                }
                
                // Cache result
                if !newMovies.isEmpty {
                    await ResponseCache.shared.save(movies: newMovies, for: cacheKey)
                }
                
                // Determine if we can load more (OMDb returns 10 items per page usually)
                self.canLoadMore = !newMovies.isEmpty && newMovies.count >= 10
                self.currentPage += 1
                self.isLoading = false
                
            } catch {
                if !Task.isCancelled {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    self.canLoadMore = false // Stop trying if error, or handle differently
                }
            }
        }
    }
    
    private func resetAndLoad() {
        self.movies = []
        self.currentPage = 1
        self.canLoadMore = true
        self.loadMovies()
    }
    
    // Local Filter for Date Range (Year)
    var filteredMovies: [Movie] {
        guard isDateFilterActive else { return movies }
        
        let startYear = Calendar.current.component(.year, from: startDate)
        let endYear = Calendar.current.component(.year, from: endDate)
        
        return movies.filter { movie in
            // Handle year ranges like "2008–2012" by taking the start year
            let yearString = movie.year.components(separatedBy: CharacterSet.decimalDigits.inverted).first ?? ""
            if let yearInt = Int(yearString) {
                return yearInt >= startYear && yearInt <= endYear
            }
            return false
        }
    }
    
    func loadNextPage() {
        loadMovies(loadMore: true)
    }
    
    // Real-Time Logic
    private func setupRealTimeUpdates() {
        realTimeService.newMovieAvailable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.hasNewDataAvailable = true
            }
            .store(in: &cancellables)
        
        realTimeService.startSimulation()
    }
    
    func refreshData() {
        hasNewDataAvailable = false
        // Clear cache to ensure fresh data if needed, or just reload
        Task {
            await ResponseCache.shared.clear()
            resetAndLoad()
        }
    }
}
