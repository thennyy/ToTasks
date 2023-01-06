//
//  AddButton.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/18/22.
//

import UIKit

class AddButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
     //   UIButton(type: typeButton)
        setImage(.addImage, for: .normal)
        tintColor = .systemOrange
        setDemensions(height: 60, width: 60)
        layer.cornerRadius = 30
        layer.shadowOpacity = 0.3
        layer.borderWidth = 3
        layer.borderColor = UIColor.systemOrange.cgColor
        layer.shadowRadius = 12
        backgroundColor = .white
        layer.shadowColor = UIColor.systemOrange.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
}
