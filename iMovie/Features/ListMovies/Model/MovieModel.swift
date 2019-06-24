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
    
}
