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
    var popular: [ShowMediaModel]
    var topRated: [ShowMediaModel]
    var upcoming: [ShowMediaModel]
    
    var actualPage: Int = 1
    var maxPages: Int = 2
    
    var pagesTvShow: Page
    var pagesMovie: Page
    
    
    init(popular: [ShowMediaModel] = [], topRated: [ShowMediaModel] = [], upcoming: [ShowMediaModel] = [], pagesTvShow: Page = Page(), pagesMovie: Page = Page()) {
        self.popular = popular
        self.topRated = topRated
        self.upcoming = upcoming
        
        self.pagesMovie = pagesMovie
        self.pagesTvShow = pagesTvShow
    }
    
    func verifyLimit(for type: Type, and itemsPerPage: Int) -> Bool {
        if (type == .popular) {
            return popular.count <= ((pagesMovie.pagePopular + pagesTvShow.pagePopular) * itemsPerPage)
        }
        
        if (type == .topRated) {
            return topRated.count <= ((pagesMovie.pageTopRated + pagesTvShow.pageTopRated) * itemsPerPage)
        }
        
        if (type == .upcoming) {
            return upcoming.count <= ((pagesMovie.pageUpcoming + pagesTvShow.pageUpcoming) * itemsPerPage)
        }
        
        return false
    }
    
    func getNextPageIfPossible(for type: Type, and mediaType: MediaType) -> Int? {
        if (type == .popular && mediaType == .movies) {
            return (pagesMovie.maxPagePopular - pagesMovie.pagePopular > 0) ? pagesMovie.pagePopular : nil
        }
        
        if (type == .topRated && mediaType == .movies) {
            return (pagesMovie.maxPageTopRated - pagesMovie.pageTopRated > 0) ? pagesMovie.pageTopRated : nil
        }
        
        if (type == .upcoming && mediaType == .movies) {
            return (pagesMovie.maxPageUpcoming - pagesMovie.pageUpcoming > 0) ? pagesMovie.pageUpcoming : nil
        }
        
        if (type == .popular && mediaType == .tvShows) {
            return (pagesTvShow.maxPagePopular - pagesTvShow.pagePopular > 0) ? pagesTvShow.pagePopular : nil
        }
        
        if (type == .topRated && mediaType == .tvShows) {
            return (pagesTvShow.maxPageTopRated - pagesTvShow.pageTopRated > 0) ? pagesTvShow.pageTopRated : nil
        }
        
        if (type == .upcoming && mediaType == .tvShows) {
            return (pagesTvShow.maxPageUpcoming - pagesTvShow.pageUpcoming > 0) ? pagesTvShow.pageUpcoming : nil
        }
        
        return nil
    }
}
