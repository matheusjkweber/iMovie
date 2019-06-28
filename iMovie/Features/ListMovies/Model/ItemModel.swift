//
//  ItemModel.swift
//  iMovie
//
//  Created by Matheus Weber on 26/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation
import UIKit

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
    let id: Int
    let voteAverage: Float
    let releaseDate: Date
    let posterPath: String
    
    init(with tvShowModel: TVShowModel) {
        self.id = tvShowModel.id
        self.title = tvShowModel.name
        self.popularity = tvShowModel.popularity
        self.type = MediaType.tvShows
        self.voteAverage = tvShowModel.vote_average
        self.releaseDate = Date.createFromString(date: tvShowModel.release_date)
        self.posterPath = tvShowModel.poster_path
    }
    
    init(with movieModel: MovieModel) {
        self.id = movieModel.id
        self.title = movieModel.title
        self.popularity = movieModel.popularity
        self.type = MediaType.movies
        self.voteAverage = movieModel.vote_average
        self.releaseDate = Date.createFromString(date: movieModel.release_date)
        self.posterPath = movieModel.poster_path
    }
    
    init(from mediaEntity: Media) {
        self.title = mediaEntity.value(forKey: "title") as? String ?? ""
        self.popularity = mediaEntity.value(forKey: "popularity") as? Float ?? 0
        
        let type = mediaEntity.value(forKey: "type") as? String ?? "movies"
        self.type = MediaType(rawValue: type) ?? .movies
        
        self.id = mediaEntity.value(forKey: "id") as? Int ?? 0
        
        self.voteAverage = mediaEntity.value(forKey: "voteAverage") as? Float ?? 0
        self.releaseDate = mediaEntity.value(forKey: "releaseDate") as? Date ?? Date()
        self.posterPath = mediaEntity.value(forKey: "posterPath") as? String ?? ""
    }
    
    func getPosterImage(success: @escaping (_ image: UIImage) -> ()) {
        
    }
}
