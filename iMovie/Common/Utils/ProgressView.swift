//
//  ProgressView.swift
//  NubankExercise
//
//  Created by Matheus Weber on 20/03/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

open class ProgressView {
    var containerView = UIView()
    var progressView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    static let shared = ProgressView()
    
    open func showProgressView(_ view: UIView) {
        containerView.frame = view.frame
        containerView.center = view.center
        containerView.backgroundColor = UIColor.disabledColor.withAlphaComponent(0.6)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.backgroundColor = UIColor.loadingBlack.withAlphaComponent(0.7)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        progressView.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        view.addSubview(containerView)
        
        activityIndicator.startAnimating()
        
        
        let containerViewTopContraint = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let containerViewBottomContraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let containerViewLeftContraint = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let containerViewRightContraint = NSLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        
        let progressViewCenterXConstraint = NSLayoutConstraint(item: progressView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        let progressViewCenterYConstraint = NSLayoutConstraint(item: progressView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0)
        let progressViewHeightConstraint = NSLayoutConstraint(item: progressView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
        let progressViewWidthContraint = NSLayoutConstraint(item: progressView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
        
        let activityIndicatorCenterXConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: progressView, attribute: .centerX, multiplier: 1, constant: 0)
        let activityIndicatorCenterYConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: progressView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([containerViewTopContraint, containerViewLeftContraint, containerViewRightContraint, containerViewBottomContraint, progressViewCenterXConstraint, progressViewCenterYConstraint, progressViewHeightConstraint, progressViewWidthContraint, activityIndicatorCenterXConstraint, activityIndicatorCenterYConstraint])
    }
    
    open func hideProgressView() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}
