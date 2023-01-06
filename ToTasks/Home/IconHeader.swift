//
//  IconHeader.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/23/22.
//

import UIKit

class IconHeader: UICollectionViewCell {
    
    static let identifier = "IconHeader"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .black
        label.textAlignment = .left
       // label.text = "Set Icon"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .grayColor 
        addSubview(titleLabel)
        titleLabel.centerY(inView: self,
                           leftAnchor: leftAnchor, paddingLeft: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
