//
//  BaseViewController.swift
//  iMovie
//
//  Created by Matheus Weber on 24/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, StateProtocol {
    var errorView: ErrorView?
    var state: ViewState<ButtonAction>
    
    init(state: ViewState<ButtonAction>) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

//MARK: StateProtocol methods
extension BaseViewController {
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

//MARK Navigation Controller
extension BaseViewController {
    func configureNavigationWithButtons() {
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        filterButton.setImage(UIImage(named: "ic_filter"), for: .normal)
        filterButton.addTarget(self, action: #selector(didClickedFilterButton), for: .touchUpInside)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        
        self.navigationItem.rightBarButtonItems = [filterBarButton]
    }
    
    @objc func didClickedFilterButton() {
        
    }
    
    @objc func didClickedSearchButton() {
        
    }
    
    func configureFilterViewLayout(filterView: FilterView) {
        let filterViewHeightConstraint = NSLayoutConstraint(item: filterView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 210)
        let filterViewLeftConstraint = NSLayoutConstraint(item: filterView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let filterViewRightConstraint = NSLayoutConstraint(item: filterView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let filterViewBottomConstraint = NSLayoutConstraint(item: filterView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([filterViewHeightConstraint, filterViewLeftConstraint, filterViewRightConstraint, filterViewBottomConstraint])
    }
}

