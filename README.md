# TestCaseBragi
This is a simple app which displays a list of movies and TV shows from TMDB, filtered by genre, with infinite scroll and pull-to-refresh functionality.

## Prerequisites
- iOS 14.0+
- Xcode 14.2+
- Cocoapods
Make sure you have a valid internet connection to fetch movie and TV show data from TMDB API

## Setup
Clone the repository: 'git clone https://github.com/Polinqva/TestCaseBragi.git'

Navigate to the project directory: 'cd TestCaseBragi'

Install the pods: 'pod install'

Open the .xcworkspace file in Xcode: 'open TestCaseBragi.xcworkspace'

Now you are ready to built and run it!

## General Architecture
The project is built following the **MVVM (Model-View-ViewModel)** pattern using RxSwift for reactive bindings.
### Model:
Genre, MediaItem, MediaDetail structs represent the data from the TMDB API.

### ViewModel:
The app uses a BaseMediaViewModel generic class to manage shared business logic (genre loading, item fetching, etc.).
MoviesViewModel and TVShowsViewModel inherit from it, passing their specific media type (movie or tv).
This ensures clean code, better reusability, and separation of concerns.

### View:
MoviesViewController, TVShowsViewController handle user interactions and bind UI components to ViewModel data streams.

### Reusable Cells:
GenreCell – for genre selection

MovieItemCell – for movie grid items

TVShowItemCell – for TV show grid items

### Networking:
APIService class abstracts API calls using URLSession and provides results as RxSwift Observable streams.

## Libraries
**RxSwift/RxCocoa** - Reactive programming and data binding

**SnapKit** - Declarative Auto Layout for building UI

**Kingfisher** - Asynchronous image downloading and caching

**CocoaPods** - Dependency manager for iOS libraries

## Features
TabBar navigation with two tabs: Movies and TV Shows

Fetch genres dynamically from TMDB API

Horizontal scrollable list of genres

Vertical grid of Movies/TV Shows (2 items per row)

Pull to refresh to load random new data

Infinite scroll to load additional pages when reaching bottom

Fetch additional details for Movies (Budget/Revenue) and TV Shows (Last Air Date/Last Episode)

Smooth UI transitions and async image loading
## Conclusion

This project demonstrates a clean MVVM architecture with reactive bindings using RxSwift.  
The app is lightweight, scalable, and shows the best practices of modern iOS development.  
It is ready for extension to new types of media, features like search, favorites, or offline caching.

