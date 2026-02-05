//
//  MovieListView.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @State private var isShowingFilter = false
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack(alignment: .top) {
            List {
                if viewModel.filteredMovies.isEmpty && !viewModel.isLoading {
                    Text("No movies found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(viewModel.filteredMovies) { movie in
                        MovieCell(movie: movie)
                            .onAppear {
                                if movie == viewModel.filteredMovies.last {
                                    viewModel.loadNextPage()
                                }
                            }
                            .onTapGesture {
                                // coordinator.showDetails(for: movie) // If details were implemented
                            }
                    }
                    
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.refreshData()
            }
            
            // Floating Button
            if viewModel.hasNewDataAvailable {
                FloatingRefreshButton {
                    withAnimation {
                        viewModel.refreshData()
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .navigationTitle("Movies")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isShowingFilter = true }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .sheet(isPresented: $isShowingFilter) {
            FilterView(viewModel: viewModel)
        }
        .onAppear {
            if viewModel.movies.isEmpty {
                viewModel.loadMovies()
            }
        }
    }
}
