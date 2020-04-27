//
//  SearchPageView.swift
//  MovieSearch
//
//  Created by porter on 13/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct SearchPageView: View, MovieUIDelegate {

    func movieClick(text: String) {
        print("text is \(text)")
    }
    
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
                    return Text(message).toAny()

                case .Fetched(let uiComponents):
                    return AnyView(VStack {
                        ForEach(uiComponents, id: \.uniqueId) { uiComponent in
                            uiComponent.render(uiDelegate: self)
                        }
                    })

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

