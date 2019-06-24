//
//  ListMoviesViewModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

protocol ListMoviesViewModelDelegate: class {
    func didUpdateLayout(state: ViewState<ButtonAction>)
    func didUpdateData()
}

class ListMoviesViewModel {
    private let model: ListMoviesModel
    weak var delegate: ListMoviesViewModelDelegate?
    var service: ListMoviesService
    
    var state: ViewState<ButtonAction> {
        didSet {
            updateView()
        }
    }
    
    public init(model: ListMoviesModel, state: ViewState<ButtonAction>, service: ListMoviesService = ListMoviesService()) {
        self.model = model
        self.rawMovies = model.movies
        self.category = model.category
        self.state = state
        self.service = service
    }
    
    var rawMovies: [MovieModel] {
        willSet(newMovies) {
            model.movies = newMovies
        }
    }
    
    var category: TypeMovie {
        willSet(newCategory) {
            model.category = newCategory
        }
    }
    
    func getPopularMovies() {
        self.state = .loading
        service.getPopularMovies(success: { (moviesResponse) in
            DispatchQueue.main.async {
                self.rawMovies = moviesResponse.results
                self.state = .success
                self.delegate?.didUpdateData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                switch error{
                case .noInternetConnection:
                    self.state = .internetError({
                        self.getPopularMovies()
                    })
                default:
                    self.state = .requestError({
                        self.getPopularMovies()
                    })
                }
            }
        }
    }
    
    func updateView() {
        self.delegate?.didUpdateLayout(state: self.state)
    }
}
