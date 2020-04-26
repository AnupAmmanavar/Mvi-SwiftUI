//
//  ShoppingRepository.swift
//  MovieSearch
//
//  Created by porter on 21/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation


protocol ShoopingRepository {
    func fetchHomePageData() -> [ServerComponents<Any>]
}

struct ServerComponents<D> {
    var data: D
}
