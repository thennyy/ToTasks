//
//  StackViewExtension.swift
//  EnterAct-Dating
//
//  Created by Thenny Chhorn on 10/15/21.
//

import UIKit

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, spacing: CGFloat) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
    }
    func withAttributes(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0 , distribution: UIStackView.Distribution = .fill, aligment: UIStackView.Alignment = .fill) -> UIStackView {
        translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = aligment
    
        return self
    }
}
