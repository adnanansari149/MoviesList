# MoviesList
A simple iOS application that fetches and displays a list of movies from a public API. The application include features for searching and filtering movies. There is a Main screen for movies list and a movie details screen. It also allows marking a movie as favourite. MVVM architecture is implemented with Combine framework.

## Setup
1. Clone the repository.
2. Open the project in Xcode.
3. Replace `YOUR_API_KEY` in `NetworkManager` with your OMDb API key.
4. Build and run the project on the simulator or a physical device.

## Features
- Splash screen with app logo.
- List of movies with poster, title, release date, and favorite button.
- Movie details screen with description, genre, and rating.
- Search functionality to filter movies by title.
- Favorite movies feature using UserDefaults.

## Assumptions
- The app fetches movies using the OMDb API.
- Error handling is implemented for network requests.

## Potential Improvements
- Add caching for movie data to improve performance.
- Implement pagination for movie list.
- Enhance UI with animations and additional styling.
- Code Coverage can be improved by including remaining test cases.
