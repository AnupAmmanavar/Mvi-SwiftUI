//
//  UIComponents.swift
//  MovieSearch
//
//  Created by porter on 16/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation
import SwiftUI


protocol UIDelegate {}

protocol UIComponent {
    var uniqueId: String  { get }
    func render(uiDelegate: UIDelegate) -> AnyView
}


func render<UI: UIComponent>(ui: [UI], uiDelegate: UIDelegate) -> AnyView {
     return AnyView(VStack {
         ForEach(ui, id: \.uniqueId) { uiComponent in
             uiComponent.render(uiDelegate: uiDelegate)
         }
     })
}

extension Array where Element : UIComponent {
    func display(uiDelegate: UIDelegate) {
        VStack {
            ForEach(self, id: \.uniqueId) { uiComponent in
                uiComponent.render(uiDelegate: uiDelegate)
            }
        }
    }
}
