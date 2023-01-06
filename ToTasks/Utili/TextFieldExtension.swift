//
//  TextFieldExtension.swift
//  EnterAct-Dating
//
//  Created by Thenny Chhorn on 10/17/21.
//

import UIKit

extension UITextField {
    
    convenience init(placeHolder: String,
                     textColor: UIColor,
                     backgroundColor: UIColor? = .grayColor,
                     cornerRadius: CGFloat? = 9) {
        
        self.init()
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 54))
        self.leftView = leftView
        self.leftViewMode = .always
        self.textColor = textColor
        self.placeholder = placeHolder
        //self.placeholder.textColor = .lightGray
        layer.cornerRadius = cornerRadius!
        let space = UIView()
        space.frame = CGRect(x: 0, y: 0, width: 9, height: frame.height)
        rightView = space
        rightViewMode = .always 
        font = .regularMedium
        clipsToBounds = true
        
        self.backgroundColor = backgroundColor
        
    }
}
