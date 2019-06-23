//
//  ListMoviesViewModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

class ListMoviesViewModel {
    private let listMoviesModel: ListMoviesModel
    
    public init(listMoviesModel: ListMoviesModel = ListMoviesModel()) {
        self.listMoviesModel = listMoviesModel
    }
}
