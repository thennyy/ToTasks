//
//  VoiceReminderView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/22/22.
//

import UIKit

class VoiceReminderView: UIView {
    
    private let backGroundView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBold
        label.textColor = .darkGray
        
        return label
    }()
    private let secondtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .smallMedium
        label.textColor = .darkGray
        
        return label
    }()
    private let premiumImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = .crownFillImage
        iv.setDemensions(height: 30, width: 30)
        iv.tintColor = .yellowColor
        return iv
    }()
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton(type: .system)
//        let image = UIImage(systemName: "mic.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
//        button.setImage(image, for: .normal)
//       // button.tintColor = .lightGray
//        button.tintColor = .white
//        button.backgroundColor = .darkGray
//        button.clipsToBounds = true
//        button.setDemensions(height: 45, width: 45)
//        button.layer.cornerRadius = 45/2
//        button.layer.borderWidth = 2
        
        return button
    }()
  
    convenience init(title: String, secondTitle: String) {
        self.init()
        
        backgroundColor = .orangeColor
        layer.cornerRadius = 15
        titleLabel.text = title
        secondtitleLabel.text = secondTitle
        
        backGroundView.backgroundColor = .shareWhiteColor
        backGroundView.layer.cornerRadius = 15
        
        addSubview(backGroundView)
  
        backGroundView.anchor(top: topAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor,
                              paddingTop: 1,
                              paddingLeft: 1,
                              paddingBottom: 1,
                              paddingRight: 1)
        
        
        let stackview = UIStackView(arrangedSubviews: [titleLabel, premiumImage]).withAttributes(axis: .horizontal, spacing: 9, distribution: .fill)
        
        addSubview(stackview)
        stackview.anchor(top: topAnchor,
                         left: leftAnchor,
                         paddingTop: 12,
                         paddingLeft: 20)
        
        addSubview(secondtitleLabel)
        secondtitleLabel.anchor(top: stackview.bottomAnchor,
                                left: leftAnchor,
                                paddingTop: 6,
                                paddingLeft: 20)
        
        addSubview(rightArrowButton)
        rightArrowButton.centerY(inView: self,
                                 rightAnchor: rightAnchor,
                                 paddingRight: 20)
        
    }
}
