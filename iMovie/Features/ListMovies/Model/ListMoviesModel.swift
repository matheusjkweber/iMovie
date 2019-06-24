//
//  ListMoviesModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

enum TypeMovie: Int {
    case popular = 0
    case topRated = 1
    case upcoming = 2
}

class ListMoviesModel {
    var movies: [MovieModel]
    var page: Int
    var category: TypeMovie
    
    init(movies: [MovieModel], page: Int, category: TypeMovie) {
        self.movies = movies
        self.page = page
        self.category = category
    }
}
