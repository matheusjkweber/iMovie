//
//  NubankEndpoint.swift
//  NetworkLayer
//
//  Created by Matheus Weber on 30/03/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//  This Network Layer was created from Malcolm Kumwenda`s Medium Tutorial
//

import Foundation

public enum TheMovieDataBaseAPI {
    case moviePopular(Int)
    case tvPopular(Int)
    
    case movieTopRated(Int)
    case tvTopRated(Int)
    
    case movieUpcoming(Int)
    case tvAiringToday(Int)
}

extension TheMovieDataBaseAPI: EndPointType {
    
    var environmentBaseURL : String {
        return "https://api.themoviedb.org/3"
    }
    
    static var imageURL : String {
        return "https://image.tmdb.org/t/p/original"
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .moviePopular:
            return "/movie/popular"
        case .movieTopRated:
            return "/movie/top_rated"
        case .movieUpcoming:
            return "/movie/upcoming"
        case .tvPopular:
            return "/tv/popular"
        case .tvTopRated:
            return "/tv/top_rated"
        case .tvAiringToday:
            return "/tv/airing_today"
        }
    }
    
    var queryParams: URLQueryItem? {
        switch self {
        case .moviePopular(let page), .movieTopRated(let page), .movieUpcoming(let page),
             .tvPopular(let page), .tvTopRated(let page), .tvAiringToday(let page):
            return URLQueryItem(name: "page", value: "\(page)")
        default:
            return nil
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        
        default:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var queryToken: URLQueryItem {
        return URLQueryItem(name: "api_key", value: "de1c491cf617f156331c9999e37c3376")
    }
}


