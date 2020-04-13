//
//  MovieViews.swift
//  MovieSearch
//
//  Created by porter on 13/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct SearchedMoviesView: View {
    
    let movieResult: MoviesResult
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(movieResult.results, id: \.title) { movie in
                    SearchedMovieView(movie: movie)
                }
            }
        }
        .padding()
    }
    
}

struct SearchedMovieView: View {
    
    let movie: Movie
    
    var body: some View {
        
        HStack {
            KFImage(URL(string: "https://image.tmdb.org/t/p/w300/\(movie.poster_path ?? "")"))
                .resizable()
                .frame(width: 100, height: 150)
                .cornerRadius(20)
            VStack {
                HStack {
                    Text(movie.title)
                        .frame(alignment: Alignment.topLeading)
                        .foregroundColor(.black)
                        .font(.subheadline)
                    
                    Spacer()
                }
                
                Text(movie.overview)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                Spacer()
            }
            .padding()
            Spacer()
            
        }
    }
}


