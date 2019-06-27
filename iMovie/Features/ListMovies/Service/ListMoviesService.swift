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
    var movieResponse: ItemResponse<MovieModel>? = nil
    var tvShowResponse: ItemResponse<TVShowModel>? = nil
    var failed: Bool = false
    var error: NetworkResponse?
    
    init(manager: NetworkManager = NetworkManager()) {
        self.manager = manager
    }
    
    func getPopular(pageMovie: Int?,
                    pageTVShow: Int?,
                    success: @escaping (_ results: [ShowMediaModel], _ movieResponse: ItemResponse<MovieModel>?, _ tvShowResponse: ItemResponse<TVShowModel>?) -> (),
                    failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        if let pageMovie = pageMovie {
            manager.request(request: TheMovieDataBaseAPI.moviePopular(pageMovie), success: { (itemResponse: ItemResponse<MovieModel>) in
                dispatchGroup.leave()
                self.movieResponse = itemResponse
            }) { (error) in
                self.failed = true
                self.error = error
                dispatchGroup.leave()
            }
        }
        
        if let pageTVShow = pageTVShow {
            dispatchGroup.enter()
            manager.request(request: TheMovieDataBaseAPI.tvPopular(pageTVShow), success: { (itemResponse: ItemResponse<TVShowModel>) in
                dispatchGroup.leave()
                self.tvShowResponse = itemResponse
            }) { (error) in
                self.failed = true
                self.error = error
                dispatchGroup.leave()
            }
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
                success(convertedResult, self.movieResponse, self.tvShowResponse)
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
