//
//  UIComponents.swift
//  MovieSearch
//
//  Created by porter on 16/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation
import SwiftUI

protocol UIComponent {
    var uniqueId: String  { get }
    func render(uiDelegate: UIDelegate) -> AnyView
}

struct MovieUIComponent : UIComponent {
    
    var uniqueId: String = "MovieComponent"
    
    func render(uiDelegate: UIDelegate) -> AnyView {
        let delegate = UIDelegate.self as! MovieUIDelegate
        return AnyView(
            Text("MovieUIComponent")
                .onTapGesture {
                    delegate.movieClick(text: "MovieName")
            }
        )
    }
}

struct InitUIComponent: UIComponent {
    var uniqueId: String = "InitComponent"
    
    func render(uiDelegate: UIDelegate) -> AnyView {
        return AnyView(Text("Please type the search query"))
    }
}

struct LoadingUIComponent: UIComponent {
    
    var uniqueId: String = "LoadingComponent"
    
    
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    func render(uiDelegate: UIDelegate) -> AnyView {
        return AnyView(Text(message))
    }
}

struct NoResultsUIComponent: UIComponent {
    var uniqueId: String = "NoResultComponent"
    
    
    func render(uiDelegate: UIDelegate) -> AnyView {
        return AnyView(Text("No matching movies found"))
    }
    
}

struct ApiErrorUIComponent: UIComponent {
    var uniqueId: String = "ErrorCompoent"
    
    
    let errorMessage: String
    
    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    func render(uiDelegate: UIDelegate) -> AnyView {
        return AnyView(Text(errorMessage))
    }
}


struct MovieListUIComponent: UIComponent {
    var uniqueId: String = "MovieListComponent"
    
    
    let moviesResult: MoviesResult
    
    init(moviesResult: MoviesResult) {
        self.moviesResult = moviesResult
    }
    
    func render(uiDelegate: UIDelegate) -> AnyView {
        return AnyView(SearchedMoviesView(movieResult: moviesResult))
    }
}

protocol MovieUIDelegate : UIDelegate {
    func movieClick(text: String)
}


protocol UIDelegate {}



extension Array where Element : UIComponent {
    func display(uiDelegate: UIDelegate) {
        VStack {
            ForEach(self, id: \.uniqueId) { uiComponent in
                uiComponent.render(uiDelegate: uiDelegate)
            }
        }
    }
}
