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
        self.state = state
        self.service = service
    }
    
    var category: TypeMovie {
        set {
            model.category = newValue
            didCategoryChanged()
        }
        get {
            return model.category
        }
    }
    
    var popular: [MovieModel] {
        set {
            model.popular = newValue
        }
        get {
            return model.popular
        }
    }
    
    var topRated: [MovieModel] {
        set {
            model.topRated = newValue
        }
        get {
            return model.topRated
        }
    }
    
    var upcoming: [MovieModel] {
        set {
            model.upcoming = newValue
        }
        get {
            return model.upcoming
        }
    }
    
    var showingMovies: [MovieModel] = []
    
    func getPopularMovies() {
        if popular.isEmpty {
            self.state = .loading
            service.getPopularMovies(success: { (moviesResponse) in
                DispatchQueue.main.async {
                    self.popular = moviesResponse.results
                    self.showingMovies = moviesResponse.results
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
        } else {
            showingMovies = popular
            self.delegate?.didUpdateData()
        }
    }
    
    func getTopRatedMovies() {
        if topRated.isEmpty {
            self.state = .loading
            service.getTopRatedMovies(success: { (moviesResponse) in
                DispatchQueue.main.async {
                    self.topRated = moviesResponse.results
                    self.showingMovies = moviesResponse.results
                    self.state = .success
                    self.delegate?.didUpdateData()
                }
            }) { (error) in
                DispatchQueue.main.async {
                    switch error{
                    case .noInternetConnection:
                        self.state = .internetError({
                            self.getTopRatedMovies()
                        })
                    default:
                        self.state = .requestError({
                            self.getTopRatedMovies()
                        })
                    }
                }
            }
        } else {
            showingMovies = topRated
            self.delegate?.didUpdateData()
        }
    }
    
    func getUpcomingMovies() {
        if upcoming.isEmpty {
            self.state = .loading
            service.getUpcomingMovies(success: { (moviesResponse) in
                DispatchQueue.main.async {
                    self.upcoming = moviesResponse.results
                    self.showingMovies = moviesResponse.results
                    self.state = .success
                    self.delegate?.didUpdateData()
                }
            }) { (error) in
                DispatchQueue.main.async {
                    switch error{
                    case .noInternetConnection:
                        self.state = .internetError({
                            self.getUpcomingMovies()
                        })
                    default:
                        self.state = .requestError({
                            self.getUpcomingMovies()
                        })
                    }
                }
            }
        } else {
            showingMovies = upcoming
            self.delegate?.didUpdateData()
        }
    }
    
    func updateView() {
        self.delegate?.didUpdateLayout(state: self.state)
    }
    
    func didCategoryChanged() {
        switch(self.category) {
        case .popular:
            self.getPopularMovies()
            break
        case .topRated:
            self.getTopRatedMovies()
            break
        case .upcoming:
            self.getUpcomingMovies()
            break
        }
    }
}
