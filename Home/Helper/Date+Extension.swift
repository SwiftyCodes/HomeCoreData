//
//  Date+Extension.swift
//  Home Report
//
//  Created by Andi Setiyadi on 9/8/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import Foundation

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: self)
    }
}
