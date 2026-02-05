//
//  FilterView.swift
//  Movie Listing App
//
//  Created by Faraz on 05/02/2026.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: MovieListViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Search Criteria")) {
                    TextField("Search Title (e.g., Batman)", text: $viewModel.searchQuery)
                    TextField("Year (Optional)", text: $viewModel.filterYear)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Date Range Filter")) {
                    Toggle("Enable Date Range", isOn: $viewModel.isDateFilterActive)
                    
                    if viewModel.isDateFilterActive {
                        DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                        DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Filter Movies")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
