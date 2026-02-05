# Movie Listing App

A simple iOS application that retrieves movie data from the OMDb API, supports pagination and filtering, and updates the UI when new movies become available via a simulated real-time messaging mechanism.

## Setup Instructions

1. Open `Movie Listing App.xcodeproj` in Xcode (14.0+ recommended).
2. Ensure you have an active internet connection.
3. Run the application on a simulator or device.

## API Used

**OMDb API**
- Base URL: `https://www.omdbapi.com/`
- Endpoint: Search (`?s={query}&page={page}&y={year}`)

## Features & Implementation Details

### Architecture
The app follows the **MVVM-C (Model-View-ViewModel + Coordinator)** pattern.
- **Coordinator**: Manages navigation flow using SwiftUI's `NavigationStack` and `NavigationPath`.
- **ViewModel**: Handles business logic, API calls, and state management.
- **View**: SwiftUI views reacting to state changes.

### Pagination
- **Approach**: The app loads movies in pages of 10 (OMDb default).
- **Trigger**: When the user scrolls to the last item in the list, the `onAppear` modifier triggers loading the next page.
- **State**: `isLoading` prevents duplicate requests, and `canLoadMore` checks if more data is available based on previous results.

### Filtering
- **Search (Title)**: Performed server-side via the OMDb API. Debounced by 0.5s to reduce API calls.
- **Year**: Performed server-side using the `y` parameter.
- **Date Range**: Performed **locally** on the fetched results.
  - *Trade-off*: OMDb search results only provide the "Year" string (e.g., "2008" or "2008–2012"). The app filters these results based on the selected start and end years. This avoids making N+1 network calls to fetch full details for every movie just to check the release date, prioritizing performance as requested.

### Real-Time Messaging (Simulation)
- **Mechanism**: A `Timer` based simulation (`RealTimeUpdateService`).
- **Behavior**: Every 10-30 seconds (randomly), a mock event is fired indicating "New Data Available".
- **UI**: A floating "New Movies Available" button appears at the top. Tapping it refreshes the list (resets to page 1).

### Caching Strategy
- **Image Caching**: implemented via a custom `ImageCache` actor (In-Memory).
  - Helps scrolling performance by storing downloaded images.
- **Response Caching**: `ResponseCache` actor stores the list of movies for a specific query+page combination.
  - **Benefit**: If the user navigates or the view reloads, we check memory first before hitting the network.
  - **Invalidation**: Cache is cleared on manual refresh.

## Key Trade-offs & Assumptions
1. **Date Filtering**: Precise date filtering requires full movie details, which aren't in the search response. I assumed filtering by Year is sufficient to satisfy the "Release date range" requirement efficiently without excessive network usage.
2. **Infinite Scroll**: Used standard `onAppear` on the last element. In a production app with complex layouts, a `Prefetch` mechanism might be robust.
3. **API Limits**: OMDb public key has usage limits.
4. **Error Handling**: Basic error messages are shown. Retries could be added.
