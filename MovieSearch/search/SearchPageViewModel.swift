//
//  SearchPageViewModel.swift
//  MovieSearch
//
//  Created by porter on 13/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation
import RxSwift
import SwiftUI

class SearchPageViewModel : ObservableObject, MovieUIDelegate {
    
    func movieClick(text: String) {
        print("text is \(text)")
    }
    
    
    @Published var uiState: SearchPageState = .Init
    
    let disposableBag = DisposeBag()
    
    let repository: MovieRepository = MovieRepository()
    
    func loadMovies(query: String) {
        
        self.uiState = .Loading("Loading for \(query)")
        
        repository
            .searchMovies(query: query)
            .subscribe(
                onNext: { [weak self] response in
                    debugPrint(response)
                    
                    if response.results.count == 0 {
                        self?.uiState = .NoResultsFound
                    } else {
                        var uiComponents : [UIComponent] = []
                        let searchedMovieUIComponent = SearchedMoviesUIComponent(moviesResult: response)
                        uiComponents.append(searchedMovieUIComponent)
                        self?.uiState = .Fetched(uiComponents)
                    }
                    
                },
                onError: { error in
                    self.uiState = .ApiError("Results couldnot be fetched")
                    debugPrint(error)
            }
        )
            .disposed(by: disposableBag)
    }
}

enum SearchPageState {
    case Init
    case Loading(String)
    case Fetched([UIComponent])
    case NoResultsFound
    case ApiError(String)
}
