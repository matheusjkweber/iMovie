//
//  AppDelegate+Ext.swift
//  iMovie
//
//  Created by Matheus Weber on 23/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    func startInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            let nav = NavigationController(rootViewController: ListMoviesViewController())
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
}
