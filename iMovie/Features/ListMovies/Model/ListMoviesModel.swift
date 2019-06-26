//
//  ListMoviesModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

class ListMoviesModel {
    var popular: [ItemModel]
    var topRated: [ItemModel]
    var upcoming: [ItemModel]
    
    var pagePopular: Int
    var pageTopRated: Int
    var pageUpcoming: Int
    
    init(popular: [ItemModel] = [], topRated: [ItemModel] = [], upcoming: [ItemModel] = [], pagePopular: Int = 1, pageTopRated: Int = 1, pageUpcoming: Int = 1) {
        self.popular = popular
        self.topRated = topRated
        self.upcoming = upcoming
        
        self.pagePopular = pagePopular
        self.pageTopRated = pageTopRated
        self.pageUpcoming = pageUpcoming
    }
}
