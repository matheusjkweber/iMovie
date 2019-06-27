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
    var itemsPerPage = 20
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
    
    func getPopularMovies(forceInternet: Bool = false, movingToNextPage: Bool = false) {
        if movingToNextPage {
            self.model.pagesMovie.pagePopular += 1
            self.model.pagesTvShow.pagePopular += 1
        }
        
        if forceInternet {
            self.model.pagesMovie.pagePopular = 0
            self.model.pagesTvShow.pagePopular = 0
        }
        
        if self.model.verifyLimit(for: .popular, and: itemsPerPage) || forceInternet {
            self.state = .loading
            service.getPopular(pageMovie: self.model.getNextPageIfPossible(for: .popular, and: .movies),
                               pageTVShow: self.model.getNextPageIfPossible(for: .popular, and: .tvShows),
                               success: { (results , movieResponse, tvShowResponse)  in
                self.model.popular += results
            
                if let tvShowResponse = tvShowResponse {
                    self.model.pagesTvShow.pagePopular = tvShowResponse.page
                    self.model.pagesTvShow.maxPagePopular = tvShowResponse.total_pages
                }
            
                if let movieResponse = movieResponse {
                    self.model.pagesMovie.pagePopular = movieResponse.page
                    self.model.pagesMovie.maxPagePopular = movieResponse.total_pages
                }
            
                self.showingItems += results

                self.state = .success
                self.delegate?.didUpdateData()
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
            //showingItems = self.model.
            self.delegate?.didUpdateData()
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
            self.getPopularMovies(forceInternet: false, movingToNextPage: true)
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
            self.getPopularMovies(forceInternet: true)
            break
        case .topRated:
            self.getTopRatedMovies(forceInternet: true)
            break
        case .upcoming:
            self.getUpcomingMovies(forceInternet: true)
            break
        }
    }
}
