//
//  SearchedMovieUIComponent.swift
//  MovieSearch
//
//  Created by porter on 26/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchedMoviesUIComponent: UIComponent {
    var uniqueId: String = "MovieListComponent"
    
    
    let moviesResult: MoviesResult
    
    init(moviesResult: MoviesResult) {
        self.moviesResult = moviesResult
    }
    
    func render(uiDelegate: UIDelegate) -> AnyView {
        return AnyView(SearchedMoviesView(movieResult: moviesResult))
    }
}
