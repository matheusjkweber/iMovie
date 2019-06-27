//
//  TVShowModel.swift
//  iMovie
//
//  Created by Matheus Weber on 26/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

class TVShowModel: ItemModel {
    let id: Int
    let original_name: String
    let genre_ids: [Int]
    let name: String
    let popularity: Float
    let origin_country: [String]
    let vote_count: Int
    let first_air_date: String
    let backdrop_path: String
    let original_language: String
    let vote_average: Float
    let overview: String
    let poster_path: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case original_name
        case genre_ids
        case name
        case popularity
        case origin_country
        case vote_count
        case first_air_date
        case backdrop_path
        case original_language
        case vote_average
        case overview
        case poster_path
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.original_name = try container.decodeIfPresent(String.self, forKey: .original_name) ?? ""
        self.genre_ids = try container.decodeIfPresent(Array.self, forKey: .genre_ids) ?? []
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        
        self.popularity = try container.decodeIfPresent(Float.self, forKey: .popularity) ?? 0
        self.origin_country = try container.decodeIfPresent(Array.self, forKey: .origin_country) ?? []
        self.vote_count = try container.decodeIfPresent(Int.self, forKey: .vote_count) ?? 0
        self.first_air_date = try container.decodeIfPresent(String.self, forKey: .first_air_date) ?? ""
        
        self.backdrop_path = try container.decodeIfPresent(String.self, forKey: .backdrop_path) ?? ""
        self.original_language = try container.decodeIfPresent(String.self, forKey: .original_language) ?? ""
        self.vote_average = try container.decodeIfPresent(Float.self, forKey: .vote_average) ?? 0
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        
        self.poster_path = try container.decodeIfPresent(String.self, forKey: .poster_path) ?? ""
        
        super.init()
    }
}
