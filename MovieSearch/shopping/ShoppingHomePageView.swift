//
//  ShoppingHomePageView.swift
//  MovieSearch
//
//  Created by porter on 21/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import SwiftUI

struct ShoppingHomePageView: View, ShoppingDelegate {
    
    @ObservedObject var controller: ShoppingHomePageController
    
    init(shoppingPageController: ShoppingHomePageController) {
        self.controller = shoppingPageController
    }
    
    var body: some View {
        VStack {
            ForEach(controller.shoppingComponents, id: \.id) { component in
                component.render(shoppingDelegate: self)
            }
            Spacer()
        }
        .onAppear {
            self.controller.prepare()
        }
    }
}

struct ShoppingHomePageView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingHomePageView(shoppingPageController: ShoppingHomePageController())
    }
}
