//
//  SearchPageView.swift
//  MovieSearch
//
//  Created by porter on 13/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct SearchPageView: View {
    
    @ObservedObject var vm: SearchPageViewModel
    
    @State private var query: String = ""
    
    init(viewModel: SearchPageViewModel) {
        self.vm = viewModel
    }
    
    var body: some View {
        ScrollView {
            
            TextField("search movies", text: $query, onCommit: {
                self.vm.loadMovies(query: self.query)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Group { () -> AnyView in
                
                switch vm.uiState {
                
                case .Init:
                    return AnyView(Text("Please type in to query"))
                
                case .Loading(let message):
                    return AnyView(Text(message))
                
                case .Fetched(let moviesResult):
                    return AnyView(SearchedMoviesView(movieResult: moviesResult))
                    
                case .NoResultsFound:
                    return AnyView(Text("No matching movies found"))
                    
                case .ApiError(let errorMessage):
                    return AnyView(Text(errorMessage))
                }
            }
        }
    }
}

struct SearchPageView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPageView(viewModel: SearchPageViewModel())
    }
}

