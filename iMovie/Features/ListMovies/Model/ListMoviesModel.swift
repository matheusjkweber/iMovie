//
//  ListMoviesModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

struct Page {
    var maxPagePopular: Int
    var maxPageUpcoming: Int
    var maxPageTopRated: Int
    
    var pagePopular: Int
    var pageTopRated: Int
    var pageUpcoming: Int
    
    init() {
        self.pagePopular = 1
        self.pageTopRated = 1
        self.pageUpcoming = 1
        
        self.maxPagePopular = 2
        self.maxPageTopRated = 2
        self.maxPageUpcoming = 2
    }
}

class ListMoviesModel {
    var actualPage: Int = 1
    var maxPages: Int = 2
    
    var pagesTvShow: Page
    var pagesMovie: Page
    
    
    init(pagesTvShow: Page = Page(), pagesMovie: Page = Page()) {
        self.pagesMovie = pagesMovie
        self.pagesTvShow = pagesTvShow
    }
}
