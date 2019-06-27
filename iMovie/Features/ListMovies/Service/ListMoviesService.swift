//
//  ListMoviesService.swift
//  iMovie
//
//  Created by Matheus Weber on 24/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

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
    
    func getPopular(page: Int,
                    itemsPerPage: Int,
                    success: @escaping (_ results: [ShowMediaModel], _ maxPage: Int) -> (),
                    failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        
        
        if coreDataManager.retrieveNumberOfMedia() >= (itemsPerPage * page) {
            let medias = coreDataManager.retrieveMedias(limit: itemsPerPage, offset: page * itemsPerPage, orderedBy: .popular)
            success(medias, coreDataManager.retrieveNumberOfMedia() / itemsPerPage)
        } else {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            
            manager.request(request: TheMovieDataBaseAPI.moviePopular(page), success: { (itemResponse: ItemResponse<MovieModel>) in
                self.movieResponse = itemResponse
                dispatchGroup.leave()
            }) { (error) in
                self.failed = true
                self.error = error
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            manager.request(request: TheMovieDataBaseAPI.tvPopular(page), success: { (itemResponse: ItemResponse<TVShowModel>) in
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
                    convertedResult = convertedResult.sorted(by: { $0.popularity > $1.popularity })
                    self.coreDataManager.addMultipleMedia(showMediaArray: convertedResult)
                    success(Array(convertedResult.prefix(itemsPerPage)), (convertedResult.count / itemsPerPage))
                }
            }
        }
    }
    
    func getPopularMovies(page:Int,
                          success: @escaping (_ notice: ItemResponse<MovieModel>) -> (),
                          failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        manager.request(request: TheMovieDataBaseAPI.moviePopular(page), success: { (itemResponse: ItemResponse) in
            success(itemResponse)
        }) { (error) in
            failure(error)
        }
    }
    
    func getTopRatedMovies(page: Int,
                           success: @escaping (_ notice: ItemResponse<MovieModel>) -> (),
                           failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        manager.request(request: TheMovieDataBaseAPI.movieTopRated(page), success: { (itemResponse: ItemResponse) in
            success(itemResponse)
        }) { (error) in
            failure(error)
        }
    }
    
    func getUpcomingMovies(page: Int,
                           success: @escaping (_ notice: ItemResponse<MovieModel>) -> (),
                           failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        manager.request(request: TheMovieDataBaseAPI.movieUpcoming(page), success: { (itemResponse: ItemResponse) in
            success(itemResponse)
        }) { (error) in
            failure(error)
        }
    }
    
    func getPopularTVShows(page:Int,
                          success: @escaping (_ notice: ItemResponse<MovieModel>) -> (),
                          failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        manager.request(request: TheMovieDataBaseAPI.tvPopular(page), success: { (itemResponse: ItemResponse) in
            success(itemResponse)
        }) { (error) in
            failure(error)
        }
    }
    
    func getTopRatedTVShows(page: Int,
                           success: @escaping (_ notice: ItemResponse<MovieModel>) -> (),
                           failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        manager.request(request: TheMovieDataBaseAPI.tvTopRated(page), success: { (itemResponse: ItemResponse) in
            success(itemResponse)
        }) { (error) in
            failure(error)
        }
    }
    
    func getUpcomingTVShows(page: Int,
                           success: @escaping (_ notice: ItemResponse<MovieModel>) -> (),
                           failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        manager.request(request: TheMovieDataBaseAPI.tvAiringToday(page), success: { (itemResponse: ItemResponse) in
            success(itemResponse)
        }) { (error) in
            failure(error)
        }
    }
}
