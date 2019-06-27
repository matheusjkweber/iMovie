//
//  ListMoviesViewModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

enum Type: String {
    case popular = "popularity"
    case topRated = "topRated"
    case upcoming = "upcoming"
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
    
    var showingItems: [ShowMediaModel] = []
    
    func getMustShowNumberOfItems() -> Int {
        switch self.category {
        case .popular:
            return (self.model.pagesMovie.pagePopular + self.model.pagesTvShow.pagePopular) * itemsPerPage
        case .topRated:
            return (self.model.pagesMovie.pageTopRated + self.model.pagesTvShow.pageTopRated) * itemsPerPage
        case .upcoming:
            return (self.model.pagesMovie.pageUpcoming + self.model.pagesTvShow.pageUpcoming) * itemsPerPage
        }
    }
    
    func getPopularMovies(movingToNextPage: Bool = false, forceInternet: Bool = false) {
        if movingToNextPage {
            self.model.actualPage += 1
        }
        
        self.state = .loading
        
        service.getPopular(page: self.model.actualPage, itemsPerPage: self.itemsPerPage, success: { (results, maxPages) in
            self.model.popular += results
            self.showingItems += results
            self.model.maxPages = maxPages
            self.delegate?.didUpdateData()
            self.state = .success
        }) { (error) in
            DispatchQueue.main.async {
                switch error{
                case .noInternetConnection:
                    self.state = .internetError({
                        self.getPopularMovies(movingToNextPage: movingToNextPage)
                    })
                default:
                    self.state = .requestError({
                        self.getPopularMovies(movingToNextPage: movingToNextPage)
                    })
                }
            }
        }
    }
    
    func getTopRatedMovies(forceInternet: Bool = false) {
//        if self.model.topRated.count <= self.model.pageTopRated * itemsPerPage || forceInternet {
//            self.state = .loading
//            service.getTopRatedMovies(page: self.model.pageTopRated,
//                                      success: { (itemsResponse) in
//                DispatchQueue.main.async {
//                    if self.model.topRated.count == 0 || forceInternet {
//                        self.model.topRated = itemsResponse.results
//                        self.showingItems = itemsResponse.results
//                    } else {
//                        self.model.topRated += itemsResponse.results
//                        self.showingItems += itemsResponse.results
//                    }
//                    self.state = .success
//                    self.delegate?.didUpdateData()
//                }
//            }) { (error) in
//                DispatchQueue.main.async {
//                    switch error{
//                    case .noInternetConnection:
//                        self.state = .internetError({
//                            self.getTopRatedMovies(forceInternet: forceInternet)
//                        })
//                    default:
//                        self.state = .requestError({
//                            self.getTopRatedMovies(forceInternet: forceInternet)
//                        })
//                    }
//                }
//            }
//        } else {
//            showingItems = self.model.topRated
//            self.delegate?.didUpdateData()
//        }
    }
    
    func getUpcomingMovies(forceInternet: Bool = false) {
//        if self.model.upcoming.count <= self.model.pageUpcoming * itemsPerPage || forceInternet {
//            self.state = .loading
//            service.getUpcomingMovies(page: self.model.pageUpcoming,
//                                      success: { (itemsResponse) in
//                DispatchQueue.main.async {
//                    if self.model.upcoming.count == 0 || forceInternet{
//                        self.model.upcoming = itemsResponse.results
//                        self.showingItems = itemsResponse.results
//                    } else {
//                        self.model.upcoming += itemsResponse.results
//                        self.showingItems += itemsResponse.results
//                    }
//                    self.showingItems = itemsResponse.results
//                    self.state = .success
//                    self.delegate?.didUpdateData()
//                }
//            }) { (error) in
//                DispatchQueue.main.async {
//                    switch error{
//                    case .noInternetConnection:
//                        self.state = .internetError({
//                            self.getUpcomingMovies(forceInternet: forceInternet)
//                        })
//                    default:
//                        self.state = .requestError({
//                            self.getUpcomingMovies(forceInternet: forceInternet)
//                        })
//                    }
//                }
//            }
//        } else {
//            showingItems = self.model.upcoming
//            self.delegate?.didUpdateData()
//        }
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
            self.getPopularMovies(movingToNextPage: true)
            break
        case .topRated:
            //self.getTopRatedMovies(forceInternet: false)
            break
        case .upcoming:
            //self.getUpcomingMovies()
            break
        }
    }
    
    func refresh() {
        switch self.category {
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
