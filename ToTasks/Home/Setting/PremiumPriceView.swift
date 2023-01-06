//
//  PremiumPriceView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/30/22.
//

import UIKit
protocol PremiumPriceViewDelegate: AnyObject {
    func premiumPriceView(_ viewWantsToBuy: PremiumPriceView)
}
class PremiumPriceView: UIView {
   
    weak var delegate: PremiumPriceViewDelegate?
    
    private lazy var premiumImage = PremiumImageView(frame: .zero)
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .regularMedium
        label.text = "Unlock features"
        label.textAlignment = .left
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .regularMedium
        label.text = "$3.99"
        label.textAlignment = .left
        return label
    }()
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .smallMedium
        label.minimumScaleFactor = 3
        label.numberOfLines = 0
        label.text = "⦿ Unliminted category cards\n⦿ Exclusive icons\n⦿ Download category list"
        label.textAlignment = .left
        return label
    }()
    private lazy var buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.setTitle("$ 3.99", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .smallMedium
        button.backgroundColor = .orangeColor
        button.layer.cornerRadius = 33/2
        button.setDemensions(height: 33, width: 90)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleBuyButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // backgroundColor = .grayColor
        layer.cornerRadius = 12
        layer.borderWidth = 3
        layer.borderColor = UIColor.grayColor.cgColor

        let stackView = UIStackView(arrangedSubviews: [premiumImage,
                                                       titleLabel]).withAttributes(axis: .horizontal,
                                                                                    spacing: 6,
                                                                                    distribution: .fill)
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor,
                         left: leftAnchor,
                         paddingTop: 20,
                         paddingLeft: 20)
        
 
        addSubview(buyButton)
        buyButton.centerY(inView: stackView,
                               leftAnchor: stackView.rightAnchor,
                               rightAnchor: rightAnchor,
                               paddingRight: 20)
        
        addSubview(detailLabel)
        detailLabel.anchor(top: stackView.bottomAnchor,
                           left: stackView.leftAnchor, right: rightAnchor,
                           paddingTop: 9, paddingRight: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func handleBuyButton() {
        buyButton.backgroundColor = .grayColor
        buyButton.isEnabled = true
        delegate?.premiumPriceView(self)
        
    }
    func hideBuyButton() {
        buyButton.isHidden = true
    }
    func enableBuyButton() {
        buyButton.isEnabled = true
    
    }
    func disableBuyButton() {
        buyButton.isEnabled = false
    }
    func isPremiumAccount() {
        buyButton.isHidden = true
        titleLabel.text = "Premium"
    }
    func notPremiumAccount() {
        buyButton.isHidden = false
        titleLabel.text = "Unlock features"
    }
}
