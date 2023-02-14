//
//  Date + Ext.swift
//  Movie.1
//
//  Created by Мария Аверина on 10.02.2023.
//

import Foundation

extension Date {
    
    func convertToResponseFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        return dateFormatter.string(from: self)
    }
}
