//
//  Mockable.swift
//  iMovieTests
//
//  Created by Matheus Weber on 29/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import UIKit
@testable import iMovie

class Mockable {
    func mock<T: Codable>(type: T.Type, jsonFile: String) -> T {
        if let path = Bundle.main.path(forResource: jsonFile, ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let result = try decoder.decode(type.self, from: data)
                return result
            } catch {
                print(error)
            }
        }
        fatalError("Mock file not found")
    }
}
