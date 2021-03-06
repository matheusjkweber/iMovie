//
//  NetworkManagerMock.swift
//  iMovie
//
//  Created by Matheus Weber on 31/03/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import Foundation

@testable import iMovie

class NetworkManagerMock<T: Codable>: NetworkManager {
    var shouldReturn: Result<NetworkResponse> = .success
    var expectedAnswer: T? = nil
    
    override func request<T: Codable>(request: TheMovieDataBaseAPI,
                             success: @escaping (_ result: T) -> (),
                             failure: @escaping (_ error: NetworkResponse) -> ()) {
        switch(shouldReturn){
        case .success:
            if let expectedAnswer = expectedAnswer as? T {
                success(expectedAnswer)
            }
        case .failure(let error):
            failure(error)
        }
    }
    
    func test() {
        
    }
}
