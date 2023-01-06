//
//  PrivatePolicyButton.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/30/22.
//

import UIKit

class  PrivatePolicyButton: UIButton {
    
    private let rightImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = .forwardImage
        iv.setDemensions(height: 24, width: 24)
        iv.tintColor = .yellowColor
        return iv
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "creditcard.fill")
        iv.setDemensions(height: 30, width: 30)
        iv.tintColor = .black
        //iv.tintColor = .yellowColor
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("Private Policy", for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .regularMedium
        
        
        addSubview(rightImage)
        rightImage.centerY(inView: self,
                           rightAnchor: rightAnchor,
                           paddingRight: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
