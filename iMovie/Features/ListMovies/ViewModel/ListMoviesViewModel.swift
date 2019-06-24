//
//  ListMoviesViewModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

class ListMoviesViewModel {
    private let model: ListMoviesModel
    
    public init(model: ListMoviesModel) {
        self.model = model
        self.rawMovies = model.movies
        self.category = model.category
    }
    
    var rawMovies: [MovieModel] {
        willSet(newMovies) {
            model.movies = newMovies
        }
    }
    
    var category: TypeMovie {
        willSet(newCategory) {
            model.category = newCategory
        }
    }
}
