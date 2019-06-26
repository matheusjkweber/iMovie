//
//  MovieModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

class MovieModel: Codable {
    let id: Int
    let title: String
    let poster_path: String
    let vote_count: Int
    let video: Bool
    let vote_average: Float
    let popularity: Float
    let original_language: String
    let original_title: String
    let genre_ids: [Int]
    let backdrop_path: String
    let adult: Bool
    let overview: String
    let release_date: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.poster_path = try container.decodeIfPresent(String.self, forKey: .poster_path) ?? ""
        self.vote_count = try container.decodeIfPresent(Int.self, forKey: .vote_count) ?? 0
        
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video) ?? false
        self.vote_average = try container.decodeIfPresent(Float.self, forKey: .vote_average) ?? 0
        self.popularity = try container.decodeIfPresent(Float.self, forKey: .popularity) ?? 0
        self.original_language = try container.decodeIfPresent(String.self, forKey: .original_language) ?? ""
        
        self.original_title = try container.decodeIfPresent(String.self, forKey: .original_title) ?? ""
        self.genre_ids = try container.decodeIfPresent(Array.self, forKey: .genre_ids) ?? []
        self.backdrop_path = try container.decodeIfPresent(String.self, forKey: .backdrop_path) ?? ""
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult) ?? false
        
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        self.release_date = try container.decodeIfPresent(String.self, forKey: .release_date) ?? ""
    }
}
