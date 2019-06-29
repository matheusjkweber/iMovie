//
//  MovieDetailsViewModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailsViewModel {
    private let model: ShowMediaModel
    
    var title: String {
        get {
            return model.title
        }
    }
    
    var releaseDate: String {
        get {
            return model.releaseDate.stringFromDate()
        }
    }
    
    var voteAverage: String {
        get {
            return String(format: "%.2f", model.voteAverage)
        }
    }
    
    var originalLanguage: String {
        get {
            return model.originalLanguage
        }
    }
    
    var overview: String {
        get {
            return model.overview
        }
    }
    
    var image: UIImage? {
        get {
            return model.image
        }
    }
    
    public init(model: ShowMediaModel) {
        self.model = model
    }
}
