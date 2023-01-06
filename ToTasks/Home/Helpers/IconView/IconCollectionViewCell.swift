//
//  IconCollectionView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/7/22.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "iconCollectionCell"
    
    let firstIconImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
       // iv.image = UIImage(systemName: "moon.stars.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12))
       
        iv.setDemensions(height: 30, width: 30)
        iv.tintColor = .label
        iv.layer.cornerRadius = 6
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
      //  backgroundColor = .grayColor
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 9
        
        addSubview(firstIconImage)
        firstIconImage.centerY(inView: self)
        firstIconImage.centerX(inView: self)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func selectedAnswer() {
        
    }
}
