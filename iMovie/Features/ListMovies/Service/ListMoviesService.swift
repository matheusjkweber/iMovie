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
    
    init(manager: NetworkManager = NetworkManager()) {
        self.manager = manager
    }
    
    func getPopularMovies(page:Int,
                          success: @escaping (_ notice: MoviesResponse) -> (),
                          failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        manager.request(request: TheMovieDataBaseAPI.moviePopular(page), success: { (moviesResponse: MoviesResponse) in
            success(moviesResponse)
        }) { (error) in
            failure(error)
        }
    }
    
    func getTopRatedMovies(page: Int,
                           success: @escaping (_ notice: MoviesResponse) -> (),
                           failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        manager.request(request: TheMovieDataBaseAPI.movieTopRated(page), success: { (moviesResponse: MoviesResponse) in
            success(moviesResponse)
        }) { (error) in
            failure(error)
        }
    }
    
    func getUpcomingMovies(page: Int,
                           success: @escaping (_ notice: MoviesResponse) -> (),
                           failure: @escaping (_ error: NetworkResponse) -> ()) {
        
        manager.request(request: TheMovieDataBaseAPI.movieUpcoming(page), success: { (moviesResponse: MoviesResponse) in
            success(moviesResponse)
        }) { (error) in
            failure(error)
        }
    }
}
