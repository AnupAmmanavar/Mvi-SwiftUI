//
//  ShoppingHomePageController.swift
//  MovieSearch
//
//  Created by porter on 21/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation

class ShoppingHomePageController: ObservableObject {
    
    @Published var shoppingComponents: [ShoppingComponent] = []
    
    func prepare() {
        shoppingComponents = []
        
        var categories: [String] = []
        (1...10).forEach { index in
            categories.append("\(index)")
        }
        
        let categoryUIComponent = CategoryUIComponent(id: "caComp", categories: categories)
        let brandUIComponent = BrandUIComponent(id: "baComp", brands: categories)
        
        shoppingComponents = [categoryUIComponent, brandUIComponent]
    }
    
    
}
