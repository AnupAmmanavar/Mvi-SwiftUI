//
//  SearchPageViewModel.swift
//  MovieSearch
//
//  Created by porter on 13/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation
import RxSwift

class SearchPageViewModel : ObservableObject {
    
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
                        self?.uiState = .Fetched(response)
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
    case Fetched(MoviesResult)
    case NoResultsFound
    case ApiError(String)
}
