//
//  ListMoviesViewController.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation
import UIKit
 
class ListMoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ListMoviesViewModelDelegate, StateProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: ListMoviesViewModel?
    private let refreshControl = UIRefreshControl()
    private let cellIdentifier = "movieCollectionViewCell"
    
    var state: ViewState<ButtonAction>
    private var errorView: ErrorView?
    
    init(viewModel: ListMoviesViewModel = ListMoviesViewModel(model: ListMoviesModel(movies: [], page: 1, category: .popular), state: .loading), state: ViewState<ButtonAction> = .loading) {
        self.viewModel = viewModel
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = nil
        self.state = .loading
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
        self.viewModel?.delegate = self
        self.viewModel?.getPopularMovies()
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
    }
}

//MARK: CollectionView
extension ListMoviesViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.rawMovies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ListMoviesCollectionViewCell, let movieModel = viewModel?.rawMovies[indexPath.row] else {
            fatalError("Must be provide a ListMoviesCollectionViewCell")
        }
        
        cell.setup(
            movieModel: movieModel
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieModel = viewModel?.rawMovies[indexPath.row] {
            self.navigationController?.pushViewController(MovieDetailsViewController(viewModel: MovieDetailsViewModel(model: movieModel)), animated: true)
        }
    }
}

//MARK: RefreshControl
extension ListMoviesViewController {
    @objc func refresh(_ sender: Any) {
        
    }
    
    func stopRefresher(){
        refreshControl.endRefreshing()
    }
}

//MARK: ViewModel delegate
extension ListMoviesViewController {
    func didUpdateLayout(state: ViewState<ButtonAction>) {
        self.state = state
        setupUIStatus()
    }
    
    func didUpdateData() {
        self.collectionView.reloadData()
    }
}

//MARK: State Protocol
extension ListMoviesViewController {
    func getView() -> UIView {
        return self.view
    }
    
    func getRequestErrorView() -> ErrorView? {
        errorView?.setup(errorMessage: "Some error has ocurred, please try again.")
        return errorView
    }
    
    func getInternetErrorView() -> ErrorView? {
        errorView?.setup(errorMessage: "No internet connection, please connect to internet and try again")
        return errorView
    }
    
    func setupForSuccess() {
        
    }
    
    func setupLayoutForSuccess() {
        
    }
}
