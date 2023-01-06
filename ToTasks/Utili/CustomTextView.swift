//
//  CustomTextView.swift
//  Cupatea
//
//  Created by Thenny Chhorn on 11/5/22.
//

import UIKit

class CustomTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
    
        
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 18)
        layer.cornerRadius = 12
        backgroundColor = .grayColor
        textColor = .black
        font = .regularMedium 
        isScrollEnabled = false
        textContainerInset = UIEdgeInsets(top: 20,
                                             left: 20,
                                             bottom: 20,
                                             right: 20)
     
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
