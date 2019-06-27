//
//  ListMoviesViewController.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation
import UIKit

enum MediaType: String {
    case movies = "Movies"
    case tvShows = "TV Shows"
    case none = "None"
}

class ListMoviesViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ListMoviesViewModelDelegate, FilterViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: ListMoviesViewModel?
    private let refreshControl = UIRefreshControl()
    private let cellIdentifier = "movieCollectionViewCell"
        
    @IBOutlet weak var filterView: FilterView!
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var filterViewBottomConstraint: NSLayoutConstraint!
    init(viewModel: ListMoviesViewModel = ListMoviesViewModel(model: ListMoviesModel(), state: .loading), state: ViewState<ButtonAction> = .loading) {
        self.viewModel = viewModel
        super.init(state: state)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateMovies()
        setup()
    }
    
    func setup() {
        self.title = "iMovies"
        self.errorView = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)?.first as? ErrorView
        self.filterView.setup()
        self.filterView.delegate = self
        
        self.viewModel?.delegate = self
        self.viewModel?.getPopular()
        
        self.configureNavigationWithButtons()
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ListMoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.reloadData()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 8
        collectionView.collectionViewLayout = layout
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    func populateMovies() {
//        let arrayMovies = [MovieModel(imagePath: "", name: "Test"), MovieModel(imagePath: "", name: "Test 1"), MovieModel(imagePath: "", name: "Test 2"), MovieModel(imagePath: "", name: "Test 3")]
//        self.viewModel?.rawMovies = arrayMovies
    }
    
    @IBAction func segmentedDidChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.viewModel?.category = .popular
        case 1:
            self.viewModel?.category = .topRated
        case 2:
            self.viewModel?.category = .upcoming
        default:
            break
        }
        self.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
}

//MARK: CollectionView
extension ListMoviesViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.filtering == .none ? viewModel.showingItems.count : viewModel.filteredItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ListMoviesCollectionViewCell else {
            fatalError("Must be provide a ListMoviesCollectionViewCell")
        }
        
        guard let viewModel = self.viewModel else {
            fatalError("ViewModel cannot be nil")
        }
        
        let itemModel = viewModel.filtering == .none ? viewModel.showingItems[indexPath.row] : viewModel.filteredItems[indexPath.row]
        
        cell.setup(
            title: itemModel.title,
            type: itemModel.type == MediaType.movies ? "Movie" : "TV",
            voteAverage: itemModel.voteAverage
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let movieModel = viewModel?.showingItems[indexPath.row] {
//            //self.navigationController?.pushViewController(MovieDetailsViewController(viewModel: MovieDetailsViewModel(model: movieModel)), animated: true)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let viewModel = viewModel {
            if viewModel.filtering == .none {
                if viewModel.showingItems.count - 1 == indexPath.row {
                    viewModel.loadNextPage()
                }
            } else if viewModel.filteredItems.count - 1 == indexPath.row {
                viewModel.loadNextPage()
            }
        }
    }
}

//MARK: RefreshControl
extension ListMoviesViewController {
    @objc func refresh(_ sender: Any) {
        self.viewModel?.refresh()
    }
    
    func stopRefresher(){
        refreshControl.endRefreshing()
    }
}

//MARK: ViewModel delegate
extension ListMoviesViewController {
    func didUpdateLayout(state: ViewState<ButtonAction>) {
        self.state = state
        self.stopRefresher()
        setupUIStatus()
    }
    
    func didUpdateData() {
        //self.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
    }
}

//MARK: Filter actions
extension ListMoviesViewController {
    override func didClickedFilterButton() {
        if self.filterViewBottomConstraint.constant == -120 {
            self.filterViewBottomConstraint.constant = 0
        } else {
            self.filterViewBottomConstraint.constant = -120
        }

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func didSelectFilter(filterValue: MediaType) {
        didClickedFilterButton()
        
        self.viewModel?.filtering = filterValue
    }
}
