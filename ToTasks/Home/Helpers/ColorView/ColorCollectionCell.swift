//
//  ColorCollectionCell.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/9/22.
//

import UIKit

class ColorCollectionCell: UICollectionViewCell {
    
    static let identifier = "ColorCollectionCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 9
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 3 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func selectedAnswer() {
        layer.borderColor = UIColor.alarmColor.cgColor
      //  layer.borderWidth = 3
    
    }
    func unSelectedAnswer() {
        layer.borderColor = UIColor.clear.cgColor
    }
}
