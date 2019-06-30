//
//  ListMoviesViewModel.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation
import UIKit

enum Type: String {
    case popular = "popularity"
    case topRated = "voteAverage"
    case upcoming = "releaseDate"
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
    
    public init(model: ListMoviesModel = ListMoviesModel(), state: ViewState<ButtonAction> = .loading, service: ListMoviesService = ListMoviesService(), category: Type = .popular) {
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
    var filteredItems: [ShowMediaModel] = []
    
    var filtering: MediaType = .none {
        didSet {
            self.filterItems()
            self.delegate?.didUpdateData()
        }
    }
    
    var actualPage: Int {
        get {
            return self.model.actualPage
        }
        set {
            self.model.actualPage = newValue
        }
    }
    
    func getPopular(movingToNextPage: Bool = false, forceInternet: Bool = false) {
        if movingToNextPage {
            self.actualPage += 1
        }
        
        self.state = .loading
        
        service.getPopular(forceInternet: forceInternet,
                           page: self.model.actualPage,
                           itemsPerPage: self.itemsPerPage,
                           success: { (results, maxPages) in
            self.showingItems += results
            
            if self.filtering != .none {
                self.filterItems()
            }
            
            self.model.maxPages = maxPages
            self.delegate?.didUpdateData()
            self.state = .success
        }) { (error) in
            DispatchQueue.main.async {
                switch error{
                case .noInternetConnection:
                    self.state = .internetError({
                        self.getPopular(movingToNextPage: movingToNextPage)
                    })
                default:
                    self.state = .requestError({
                        self.getPopular(movingToNextPage: movingToNextPage)
                    })
                }
            }
        }
    }
    
    func getTopRated(movingToNextPage: Bool = false, forceInternet: Bool = false) {
        if movingToNextPage {
            self.model.actualPage += 1
        }
        
        self.state = .loading
        
        service.getTopRated(forceInternet: forceInternet,
                            page: self.model.actualPage,
                            itemsPerPage: self.itemsPerPage,
                            success: { (results, maxPages) in
            self.showingItems += results
            
            if self.filtering != .none {
                self.filterItems()
            }
            
            self.model.maxPages = maxPages
            self.delegate?.didUpdateData()
            self.state = .success
        }) { (error) in
            DispatchQueue.main.async {
                switch error{
                case .noInternetConnection:
                    self.state = .internetError({
                        self.getTopRated(movingToNextPage: movingToNextPage)
                    })
                default:
                    self.state = .requestError({
                        self.getTopRated(movingToNextPage: movingToNextPage)
                    })
                }
            }
        }
    }
    
    func getUpcoming(movingToNextPage: Bool = false, forceInternet: Bool = false) {
        if movingToNextPage {
            self.model.actualPage += 1
        }
        
        self.state = .loading
        
        service.getUpcoming(forceInternet: forceInternet,
                            page: self.model.actualPage,
                            itemsPerPage: self.itemsPerPage,
                            success: { (results, maxPages) in
            self.showingItems += results
            
            if self.filtering != .none {
                self.filterItems()
            }
            
            self.model.maxPages = maxPages
            self.delegate?.didUpdateData()
            self.state = .success
        }) { (error) in
            DispatchQueue.main.async {
                switch error{
                case .noInternetConnection:
                    self.state = .internetError({
                        self.getPopular(movingToNextPage: movingToNextPage)
                    })
                default:
                    self.state = .requestError({
                        self.getPopular(movingToNextPage: movingToNextPage)
                    })
                }
            }
        }
    }
    
    func filterItems() {
        self.filteredItems = self.showingItems.filter({ $0.type == filtering })
    }
    
    func updateView() {
        self.delegate?.didUpdateLayout(state: self.state)
    }
    
    func didCategoryChanged() {
        self.model.actualPage = 1
        self.model.maxPages = 2
        self.showingItems = []
        
        switch(self.category) {
        case .popular:
            self.getPopular()
            break
        case .topRated:
            self.getTopRated()
            break
        case .upcoming:
            self.getUpcoming()
            break
        }
    }
    
    func loadNextPage() {
        switch self.category {
        case .popular:
            self.getPopular(movingToNextPage: true)
            break
        case .topRated:
            self.getTopRated(movingToNextPage: true)
            break
        case .upcoming:
            self.getUpcoming(movingToNextPage: true)
            break
        }
    }
    
    func refresh() {
        switch self.category {
        case .popular:
            self.getPopular(movingToNextPage: false, forceInternet: true)
            break
        case .topRated:
            self.getTopRated(movingToNextPage: false, forceInternet: true)
            break
        case .upcoming:
            self.getUpcoming(movingToNextPage: false, forceInternet: true)
            break
        }
    }
}
