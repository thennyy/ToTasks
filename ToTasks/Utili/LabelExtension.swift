//
//  LabelExtension.swift
//  EnterAct-Dating
//
//  Created by Thenny Chhorn on 10/15/21.
//

import UIKit


extension UILabel {
    
    static let GTFont = "GTAmerica-Regular"
    static let GTBold = "GTAmerica-Bold"
    static let GTMedium = "GTAmerica-Medium"
    
    convenience init(numberOfLines: Int = 0, textColor: UIColor = .black,
                     text: String, fontSize: CGFloat, weight: FontWeight, alignment: NSTextAlignment = .center, height: CGFloat = 0) {
        self.init()
        self.numberOfLines = numberOfLines
        self.textColor = textColor
        self.text = text
        self.textAlignment = alignment
        
        switch weight {
        case .regular:
            self.font = UIFont(name: .regularFont, size: fontSize)
        case .medium:
            self.font = UIFont(name: .medium, size: fontSize)
        case .bold:
            self.font = UIFont(name: .bold, size: fontSize)
        }
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    enum FontWeight {
        case regular
        case medium
        case bold
    }
}

