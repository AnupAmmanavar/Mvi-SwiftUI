//
//  Models.swift
//  MovieSearch
//
//  Created by porter on 13/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation

struct MoviesResult: Codable {
    var results: [Movie]
    let title: String?
}


struct Movie: Codable, Hashable {
    var id: CLong
    var title: String
    var overview: String
    var poster_path: String? = nil
}


enum MyError: Error {
    case runtimeError(String)
}
