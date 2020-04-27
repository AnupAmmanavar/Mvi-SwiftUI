//
//  MovieOverviewUIComponent.swift
//  MovieSearch
//
//  Created by porter on 26/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation
import SwiftUI

protocol MovieUIDelegate : UIDelegate {
    func movieClick(text: String)
}

struct MovieUIComponent : UIComponent {

    let movie: Movie

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
