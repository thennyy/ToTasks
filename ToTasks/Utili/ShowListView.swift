//
//  ShowListView.swift
//  RednGreen
//
//  Created by Thenny Chhorn on 11/10/22.
//

import UIKit

class ShowListView: UIView {
    
    private lazy var recentButton: UIButton = {
        let button = UIButton(type: .system)
       // button.setTitle("Recent", for: .normal)
        button.titleLabel?.font = .regularMedium
        button.tintColor = .white
        button.backgroundColor = .accentGreenColor
        button.addTarget(self, action: #selector(handleRecentButton), for: .touchUpInside)
        return button
    }()
    private lazy var allButton: UIButton = {
        let button = UIButton(type: .system)
       // button.setTitle("All", for: .normal)
        button.titleLabel?.font = .regularMedium
        button.tintColor = .black
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleAllButton), for: .touchUpInside)
        return button
    }()
    
    convenience init(title1: String, title2: String) {
        self.init()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
        recentButton.setTitle(title1, for: .normal)
        allButton.setTitle(title2, for: .normal)
        
        layer.borderWidth = 0.6
        layer.borderColor = UIColor.accentGreenColor.cgColor 
      //  layer.cornerRadius = heightAnchor/2
        clipsToBounds = true
        let stackView = UIStackView(arrangedSubviews: [recentButton, allButton]).withAttributes(axis: .horizontal, spacing: 3, distribution: .fillEqually)
        
        addSubview(stackView)
        stackView.fillSuperview()
        
    }

    
    @objc func handleRecentButton() {
        recentButton.backgroundColor = .accentGreenColor
        recentButton.tintColor = .white
        allButton.backgroundColor = .white
        allButton.tintColor = .black
    
    }
    @objc func handleAllButton() {
        recentButton.backgroundColor = .white
        recentButton.tintColor = .black
        allButton.backgroundColor = .accentGreenColor
        allButton.tintColor = .white
    
    }
}
