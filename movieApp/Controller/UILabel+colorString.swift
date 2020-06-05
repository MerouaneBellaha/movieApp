//
//  UILabel+colorString.swift
//  movieApp
//
//  Created by Merouane Bellaha on 02/06/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

extension UILabel {

    /// Modify the color of the selected coloredText in text with chosen color or default
    func colorString(text: String, coloredText: String, color: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: coloredText)
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
        self.attributedText = attributedString
    }
}
