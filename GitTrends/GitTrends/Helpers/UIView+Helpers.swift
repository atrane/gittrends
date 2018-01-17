//
//  UIView+Helpers.swift
//  GitTrends
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.
//

import UIKit

extension UIView {
    
    /// add rounded corner as well as boarder
    func addRoundCorner(radius: CGFloat = 5.0, color: UIColor = UIColor.gray, borderWidth: CGFloat = 1) {
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    // Make round to view
    func makeRound(borderWidth: CGFloat = 1, borderColor: UIColor = .gray) {
        let radius = self.bounds.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
