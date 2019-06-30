//
//  ListMoviesViewControllerSpec.swift
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

final class ListMoviesViewControllerSpec: QuickSpec {
    class ListMoviesServiceMock: ListMoviesService {
        override func getMedia(requestMovie: TheMovieDataBaseAPI,
                               requestTVShow: TheMovieDataBaseAPI,
                               forceInternet: Bool = false,
                               page: Int,
                               itemsPerPage: Int,
                               category: Type,
                               success: @escaping (_ results: [ShowMediaModel], _ maxPage: Int) -> (),
                               failure: @escaping (_ error: NetworkResponse) -> ()) {
           
            manager.request(request: requestMovie, success: { (itemResponse: ItemResponse<MovieModel>) in
                self.movieResponse = itemResponse
                var result = itemResponse.results.map({ ShowMediaModel(with: $0) })
                
                self.manager.request(request: requestMovie, success: { (itemResponse: ItemResponse<MovieModel>) in
                    self.movieResponse = itemResponse
                    result.append(contentsOf: itemResponse.results.map({ ShowMediaModel(with: $0) }))
                    
                    self.coreDataManager.addMultipleMedia(showMediaArray: result)
                    success(result, 9)
                }) { (error) in
                    self.failed = true
                    self.error = error
                    failure(error)
                }
            }) { (error) in
                self.failed = true
                self.error = error
                failure(error)
            }
        }
    }

    override func spec() {
        var sut: ListMoviesViewController!
        var api: NetworkManagerMock<ItemResponse<MovieModel>>!
        
        describe("given ListMoviesViewController") {
            beforeEach {
                api = NetworkManagerMock<ItemResponse<MovieModel>>()
            }
            
            context("when initializing ListMoviesViewController with mocked API for success") {
                beforeEach {
                    let mockable = Mockable()
                    
                    api.shouldReturn = .success
                    api.expectedAnswer = mockable.mock(type: ItemResponse.self, jsonFile: "ListMoviesMock")
                    
                    let service = ListMoviesServiceMock(manager: api)
                    service.coreDataManager.deleteAllData(entity: "Media")
                    sut = ListMoviesViewController(viewModel: ListMoviesViewModel(service: service))
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
//                    let view = self.mockListMovies(status: ViewStatus.success)
                    sut.didUpdateLayout(state: .success)
                    expect(sut.view) == snapshot("test_list_for_success")
                }
                
                it("should change category") {
                    sut.segmentedControl.selectedSegmentIndex = 1
                    sut.segmentedDidChange(self)
                    sut.refresh(self)
                    expect(sut.viewModel?.category.rawValue).to(equal("voteAverage"))
                    
                    sut.segmentedControl.selectedSegmentIndex = 2
                    sut.segmentedDidChange(self)
                    sut.refresh(self)
                    expect(sut.viewModel?.category.rawValue).to(equal("releaseDate"))
                    
                    sut.segmentedControl.selectedSegmentIndex = 0
                    sut.segmentedDidChange(self)
                    sut.refresh(self)
                    expect(sut.viewModel?.category.rawValue).to(equal("popularity"))
                }
                
                it("should show/hide filter view") {
                    sut.didClickedFilterButton()
                    expect(sut.filterViewBottomConstraint.constant).to(be(0.0))
                    
                    sut.didClickedFilterButton()
                    expect(sut.filterViewBottomConstraint.constant).to(be(-120.0))
                }
                
                it("should apply filter") {
                    sut.didSelectFilter(filterValue: MediaType.tvShows)
                    expect(sut.viewModel?.filtering.rawValue).to(equal("TV Shows"))
                }
                
                it("should go to next page") {
                    sut.viewModel?.loadNextPage()
                    expect(sut.viewModel?.actualPage).to(be(2))
                }
                
                it("should test if is adding media on core data") {
                    let coreDataManager = CoreDataManager()
                    expect(coreDataManager.retrieveNumberOfMedia()).to(be(5))
                    
                    let media = coreDataManager.retrieveMedias(limit: 10, offset: 0, orderedBy: Type.popular)[0]
                    
                    expect(media.title).to(equal("Toy Story 4"))
                }
            }
            
            context("when initializing ListMoviesViewController with mocked API for error") {
                beforeEach {
                    api.shouldReturn = .failure(NetworkResponse.noInternetConnection)

                    let service = ListMoviesServiceMock(manager: api)
                    sut = ListMoviesViewController(viewModel: ListMoviesViewModel(service: service))
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

                it("should have status for internet error") {
                    sut.didUpdateLayout(state: .internetError({}))
                    expect(sut.view) == snapshot("test_list_for_internet_error")
                }

            }
        }
    }
}
