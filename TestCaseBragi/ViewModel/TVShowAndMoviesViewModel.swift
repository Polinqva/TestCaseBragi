//
//  TVShowAndMoviesViewModel.swift
//  TestCaseBragi
//
//  Created by Polina Smirnova on 28.04.2025.
//

import Foundation

class MoviesViewModel: BaseMediaViewModel {
    init() {
        super.init(mediaType: .movie)
    }
}

class TVShowsViewModel: BaseMediaViewModel {
    init() {
        super.init(mediaType: .tv)
    }
}
