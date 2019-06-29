//
//  ListMoviesService.swift
//  iMovie
//
//  Created by Matheus Weber on 24/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ListMoviesService {
    let manager: NetworkManager
    let coreDataManager: CoreDataManager
    var movieResponse: ItemResponse<MovieModel>? = nil
    var tvShowResponse: ItemResponse<TVShowModel>? = nil
    var failed: Bool = false
    var error: NetworkResponse?
    
    init(manager: NetworkManager = NetworkManager(), coreDataManager: CoreDataManager = CoreDataManager()) {
        self.manager = manager
        self.coreDataManager = coreDataManager
    }
    
    func getPopular(forceInternet: Bool = false,
                    page: Int,
                    itemsPerPage: Int,
                    success: @escaping (_ results: [ShowMediaModel], _ maxPage: Int) -> (),
                    failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        getMedia(requestMovie: TheMovieDataBaseAPI.moviePopular(page), requestTVShow: TheMovieDataBaseAPI.tvPopular(page), forceInternet: forceInternet, page: page, itemsPerPage: itemsPerPage, category: .popular, success: success, failure: failure)
    }
    
    func getTopRated(forceInternet: Bool = false,
                    page: Int,
                    itemsPerPage: Int,
                    success: @escaping (_ results: [ShowMediaModel], _ maxPage: Int) -> (),
                    failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        getMedia(requestMovie: TheMovieDataBaseAPI.movieTopRated(page), requestTVShow: TheMovieDataBaseAPI.tvTopRated(page), forceInternet: forceInternet, page: page, itemsPerPage: itemsPerPage, category: .topRated, success: success, failure: failure)
    }
    
    func getUpcoming(forceInternet: Bool = false,
                    page: Int,
                    itemsPerPage: Int,
                    success: @escaping (_ results: [ShowMediaModel], _ maxPage: Int) -> (),
                    failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        getMedia(requestMovie: TheMovieDataBaseAPI.movieUpcoming(page), requestTVShow: TheMovieDataBaseAPI.tvAiringToday(page), forceInternet: forceInternet, page: page, itemsPerPage: itemsPerPage, category: .upcoming, success: success, failure: failure)
    }
    
    func getMedia(requestMovie: TheMovieDataBaseAPI,
                  requestTVShow: TheMovieDataBaseAPI,
                  forceInternet: Bool = false,
                  page: Int,
                  itemsPerPage: Int,
                  category: Type,
                  success: @escaping (_ results: [ShowMediaModel], _ maxPage: Int) -> (),
                  failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        if coreDataManager.retrieveNumberOfMedia() >= (itemsPerPage * page) && !forceInternet {
            let offset = page == 1 ? 0 : page * itemsPerPage
            let medias = coreDataManager.retrieveMedias(limit: itemsPerPage, offset: offset, orderedBy: category)
            success(medias, coreDataManager.retrieveNumberOfMedia() / itemsPerPage)
        } else {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            
            manager.request(request: requestMovie, success: { (itemResponse: ItemResponse<MovieModel>) in
                self.movieResponse = itemResponse
                dispatchGroup.leave()
            }) { (error) in
                self.failed = true
                self.error = error
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            manager.request(request: requestTVShow, success: { (itemResponse: ItemResponse<TVShowModel>) in
                self.tvShowResponse = itemResponse
                dispatchGroup.leave()
            }) { (error) in
                self.failed = true
                self.error = error
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                if(self.failed) {
                    if let error = self.error {
                        failure(error)
                    }
                } else {
                    if forceInternet {
                        self.coreDataManager.emptyMedia()
                    }
                    
                    var results = [ItemModel]()
                    
                    if let tvResponse = self.tvShowResponse {
                        results += tvResponse.results
                    }
                    
                    if let movieResponse = self.movieResponse {
                        results += movieResponse.results
                    }
                    
                    var convertedResult: [ShowMediaModel] = results.map { obj in
                        if let movielModel = obj as? MovieModel {
                            return ShowMediaModel(with: movielModel)
                        } else if let tvShowModel = obj as? TVShowModel {
                            return ShowMediaModel(with: tvShowModel)
                        }
                        fatalError("Must give a MovieModel or TVShowModel")
                    }
                    
                    switch(category) {
                    case .popular:
                        convertedResult = convertedResult.sorted(by: { $0.popularity > $1.popularity })
                        break
                    case .topRated:
                        convertedResult = convertedResult.sorted(by: { $0.voteAverage > $1.popularity })
                        break
                    case .upcoming:
                        convertedResult = convertedResult.sorted(by: { $0.releaseDate > $1.releaseDate })
                        break
                    }
                    
                    self.coreDataManager.addMultipleMedia(showMediaArray: convertedResult)
                    success(Array(convertedResult.prefix(itemsPerPage)), (convertedResult.count / itemsPerPage))
                }
            }
        }
    }
}
