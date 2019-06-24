//
//  MoviesResponse.swift
//  iMovie
//
//  Created by Matheus Weber on 24/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

class MoviesResponse: Codable {
    var page: Int
    var total_results: Int
    var total_pages: Int
    var results: [MovieModel]
}
