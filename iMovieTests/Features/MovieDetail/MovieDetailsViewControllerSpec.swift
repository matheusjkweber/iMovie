//
//  MovieDetailsViewControllerSpec.swift
//  iMovieTests
//
//  Created by Matheus Weber on 29/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Nimble_Snapshots

@testable import iMovie

final class MovieDetailsViewControllerSpec: QuickSpec {
    override func spec() {
        var sut: MovieDetailsViewController!
        
        describe("given MovieDetailsViewController") {
            beforeEach {
                
            }
            
            context("when initializing MovieDetailsViewController") {
                beforeEach {
                    let mockable = Mockable()
                    let response = mockable.mock(type: ItemResponse<TVShowModel>.self, jsonFile: "ListTvShowsMock")
                    let showMediaModel = ShowMediaModel(with: response.results[0])
                    
                    let viewModel = MovieDetailsViewModel(model: showMediaModel)
                    sut = MovieDetailsViewController(viewModel: viewModel)
                    sut.loadView()
                    
                    _ = sut.view
                    sut.viewDidLoad()
                }
                
                afterEach {
                    sut = nil
                }
                
                it("should not be nil") {
                    expect(sut).toNot(beNil())
                }
                
                it("should have the expected layout when success") {
                    expect(sut.view) == snapshot("test_detail_for_success")
                }
            }
        }
    }
}
