//
//  StateProtocol.swift
//  iMovie
//
//  Created by Matheus Weber on 24/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import UIKit

enum ViewState<ButtonAction> {
    case internetError(ButtonAction)
    case success
    case requestError(ButtonAction)
    case loading
}

extension ViewState {
    var raw: Int {
        switch self {
            case .internetError:
                return 0
            case .success:
                return 1
            case .requestError:
                return 2
            case .loading:
                return 3
        }
    }
}

typealias ButtonAction = () -> ()

protocol StateProtocol {
    var state: ViewState<ButtonAction> {get set}
    
    func getView() -> UIView
    func getRequestErrorView() -> ErrorView?
    func getInternetErrorView() -> ErrorView?
}

extension StateProtocol {
    func setupUIStatus() {
        getRequestErrorView()?.removeFromSuperview()
        
        switch(state) {
        case .success:
            getRequestErrorView()?.removeFromSuperview()
            ProgressView.shared.hideProgressView()
            break
        case .loading:
            ProgressView.shared.showProgressView(self.getView())
            break
        case .requestError(let action),
             .internetError(let action):
            
            let view = getRequestErrorView()
            view?.buttonAction = action
            view?.frame = CGRect(x: 0, y: 0, width: getView().frame.width, height: getView().frame.height)
            
            if let view = view {
                getView().addSubview(view)
                configureErrorViewConstraints(view: view)
            }
            
            ProgressView.shared.hideProgressView()
            break
        }
    }
    
    fileprivate func configureErrorViewConstraints(view: ErrorView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let containerViewTopContraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: getView(), attribute: .top, multiplier: 1, constant: 0)
        let containerViewBottomContraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: getView(), attribute: .bottom, multiplier: 1, constant: 0)
        let containerViewLeftContraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: getView(), attribute: .left, multiplier: 1, constant: 0)
        let containerViewRightContraint = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: getView(), attribute: .right, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([containerViewTopContraint, containerViewLeftContraint, containerViewRightContraint, containerViewBottomContraint])
    }
}
