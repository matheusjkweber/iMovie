//
//  ItemModel.swift
//  iMovie
//
//  Created by Matheus Weber on 26/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

enum ItemType {
    case tvShow
    case movie
}

class ItemModel: Codable {
    
}

class ShowMediaModel {
    let title: String
    let popularity: Float
    let type: MediaType
    
    init(with tvShowModel: TVShowModel) {
        self.title = tvShowModel.name
        self.popularity = tvShowModel.popularity
        self.type = MediaType.movies
    }
    
    init(with movieModel: MovieModel) {
        self.title = movieModel.title
        self.popularity = movieModel.popularity
        self.type = MediaType.tvShows
    }
}
