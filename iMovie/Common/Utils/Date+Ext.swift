//
//  Date+Ext.swift
//  iMovie
//
//  Created by Matheus Weber on 27/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import Foundation

extension Date {
    static func createFromString(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-dd"
        
        return dateFormatter.date(from: date) ?? Date()
    }
}
