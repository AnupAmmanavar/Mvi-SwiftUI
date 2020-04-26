//
//  ShoppingComponents.swift
//  MovieSearch
//
//  Created by porter on 21/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation
import SwiftUI

protocol ShoppingComponent {
    var id: String { get }
    func render(shoppingDelegate: ShoppingDelegate) -> AnyView
}

protocol ShoppingDelegate { }

class CategoryUIComponent : ShoppingComponent {
    
    var id: String
    
    var categories: [String] = []
    
    init(id: String, categories: [String]) {
        self.id = id
        self.categories = categories
    }
    
    func render(shoppingDelegate: ShoppingDelegate) -> AnyView {
        return
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(self.categories, id: \.self) { category in
                        Text("Category \(category)")
                    }
                }
            }.toAny()
    }
}


class BrandUIComponent : ShoppingComponent {
    var id: String
    
    
    var brands: [String] = []
    
    init(id: String, brands: [String]) {
        self.id = id
        self.brands = brands
    }
    
    func render(shoppingDelegate: ShoppingDelegate) -> AnyView {
        return
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(self.brands, id: \.self) { brand in
                        Text("Brand \(brand)")
                    }
                }
            }.toAny()
    }
}
extension View {
    func toAny() -> AnyView {
        return AnyView(self)
    }
}
