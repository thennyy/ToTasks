//
//  WordCountView.swift
//  RednGreen
//
//  Created by Thenny Chhorn on 11/15/22.
//

import UIKit

class WordCountView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .smallMedium
        label.text = "Max"
        return label
    }()
    let wordCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
       // label.text = "50"
        return label
    }()
    
    convenience init(wordCount: String) {
        self.init()

        wordCountLabel.text = wordCount
        let stackView = UIStackView(arrangedSubviews: [titleLabel, wordCountLabel]).withAttributes(axis: .horizontal,
                                                                                                   spacing: 9,distribution: .fillEqually,
                                                                                                   aligment: .center)
       
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor,
                         right: rightAnchor)
        
    }

    func overMaximumWordCount() {
        wordCountLabel.textColor = .red
    }
    func underMaximumWordCount() {
        wordCountLabel.textColor = .gray
    }
}
