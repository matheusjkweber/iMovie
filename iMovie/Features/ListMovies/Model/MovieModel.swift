//
//  MovieModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

class MovieModel {
    let imagePath: String
    let name: String
    
    init(imagePath: String, name: String) {
        self.imagePath = imagePath
        self.name = name
    }
}
