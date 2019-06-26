//
//  ListMoviesViewModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

enum Type: Int {
    case popular = 0
    case topRated = 1
    case upcoming = 2
}

protocol ListMoviesViewModelDelegate: class {
    func didUpdateLayout(state: ViewState<ButtonAction>)
    func didUpdateData()
}

class ListMoviesViewModel {
    private let model: ListMoviesModel
    weak var delegate: ListMoviesViewModelDelegate?
    var service: ListMoviesService
    var itemsPerPage = 10
    var state: ViewState<ButtonAction> {
        didSet {
            updateView()
        }
    }
    
    public init(model: ListMoviesModel, state: ViewState<ButtonAction>, service: ListMoviesService = ListMoviesService(), category: Type = .popular) {
        self.model = model
        self.state = state
        self.service = service
        self.category = category
    }
    
    var category: Type {
        didSet {
            didCategoryChanged()
        }
    }
    
    var showingItems: [ItemModel] = []
    
    func getPopularMovies(forceInternet: Bool = false) {
        if self.model.popular.count <= self.model.pagePopular * itemsPerPage || forceInternet{
            self.state = .loading
            service.getPopularMovies(page: self.model.pagePopular,
                                     success: { (itemsResponse) in
                DispatchQueue.main.async {
                    if self.model.popular.count == 0 || forceInternet {
                        self.model.popular = itemsResponse.results
                        self.showingItems = itemsResponse.results
                    } else {
                        self.model.popular += itemsResponse.results
                        self.showingItems += itemsResponse.results
                    }
                    
                    self.state = .success
                    self.delegate?.didUpdateData()
                }
            }) { (error) in
                DispatchQueue.main.async {
                    switch error{
                    case .noInternetConnection:
                        self.state = .internetError({
                            self.getPopularMovies(forceInternet: forceInternet)
                        })
                    default:
                        self.state = .requestError({
                            self.getPopularMovies(forceInternet: forceInternet)
                        })
                    }
                }
            }
        } else {
            showingItems = self.model.popular
            self.delegate?.didUpdateData()
        }
    }
    
    func getTopRatedMovies(forceInternet: Bool = false) {
        if self.model.topRated.count <= self.model.pageTopRated * itemsPerPage || forceInternet {
            self.state = .loading
            service.getTopRatedMovies(page: self.model.pageTopRated,
                                      success: { (itemsResponse) in
                DispatchQueue.main.async {
                    if self.model.topRated.count == 0 || forceInternet {
                        self.model.topRated = itemsResponse.results
                        self.showingItems = itemsResponse.results
                    } else {
                        self.model.topRated += itemsResponse.results
                        self.showingItems += itemsResponse.results
                    }
                    self.state = .success
                    self.delegate?.didUpdateData()
                }
            }) { (error) in
                DispatchQueue.main.async {
                    switch error{
                    case .noInternetConnection:
                        self.state = .internetError({
                            self.getTopRatedMovies(forceInternet: forceInternet)
                        })
                    default:
                        self.state = .requestError({
                            self.getTopRatedMovies(forceInternet: forceInternet)
                        })
                    }
                }
            }
        } else {
            showingItems = self.model.topRated
            self.delegate?.didUpdateData()
        }
    }
    
    func getUpcomingMovies(forceInternet: Bool = false) {
        if self.model.upcoming.count <= self.model.pageUpcoming * itemsPerPage || forceInternet {
            self.state = .loading
            service.getUpcomingMovies(page: self.model.pageUpcoming,
                                      success: { (itemsResponse) in
                DispatchQueue.main.async {
                    if self.model.upcoming.count == 0 || forceInternet{
                        self.model.upcoming = itemsResponse.results
                        self.showingItems = itemsResponse.results
                    } else {
                        self.model.upcoming += itemsResponse.results
                        self.showingItems += itemsResponse.results
                    }
                    self.showingItems = itemsResponse.results
                    self.state = .success
                    self.delegate?.didUpdateData()
                }
            }) { (error) in
                DispatchQueue.main.async {
                    switch error{
                    case .noInternetConnection:
                        self.state = .internetError({
                            self.getUpcomingMovies(forceInternet: forceInternet)
                        })
                    default:
                        self.state = .requestError({
                            self.getUpcomingMovies(forceInternet: forceInternet)
                        })
                    }
                }
            }
        } else {
            showingItems = self.model.upcoming
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
    
    func loadNextPage() {
        switch self.category {
        case .popular:
            self.model.pagePopular += 1
            self.getPopularMovies()
            break
        case .topRated:
            self.model.pageTopRated += 1
            self.getTopRatedMovies()
            break
        case .upcoming:
            self.model.pageUpcoming += 1
            self.getUpcomingMovies()
            break
        }
    }
    
    func refresh() {
        switch self.category {
        case .popular:
            self.model.pagePopular = 1
            self.getPopularMovies(forceInternet: true)
            break
        case .topRated:
            self.model.pageTopRated = 1
            self.getTopRatedMovies(forceInternet: true)
            break
        case .upcoming:
            self.model.pageUpcoming = 1
            self.getUpcomingMovies(forceInternet: true)
            break
        }
    }
}
