//
//  FollowCreatorView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/19/22.
//

import UIKit

protocol FollowCreatorViewDelegate: AnyObject {
    func followCreateView(_ view: FollowCreatorView, twitterString: String)
    func followCreateView(_ view: FollowCreatorView, igTwitterString: String)

}
class FollowCreatorView: UIView {
    
    private let igUrl = "https://www.instagram.com/itsthenny/"
    private let twitterUrl = "https://twitter.com/thennychhorn"
    
    weak var delegate: FollowCreatorViewDelegate?
    
    private let titleTextLabel: UILabel = {
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .label
        label.text = "Follow creator"
        return label
    }()
    private let instagrameImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "creditcard.fill")
        iv.setDemensions(height: 33, width: 33)
        iv.tintColor = .label
        //iv.tintColor = .yellowColor
        return iv
    }()
    private lazy var instagramButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        let image = UIImage(named: "instagram icon")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setDemensions(height: 40, width: 40)
        button.addTarget(self, action: #selector(handleIGButton), for: .touchUpInside)

        return button
    }()
    private lazy var twitterButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        let image = UIImage(named: "twitter icon")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setDemensions(height: 33, width: 33)
        button.addTarget(self, action: #selector(handleTwitterButton), for: .touchUpInside)
        return button
    }()
    private let twitterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "creditcard.fill")
        iv.setDemensions(height: 33, width: 33)
        iv.tintColor = .label
        //iv.tintColor = .yellowColor
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleTextLabel)
        titleTextLabel.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 30)
        
        addSubview(instagramButton)
        instagramButton.centerY(inView: titleTextLabel, leftAnchor: titleTextLabel.rightAnchor, paddingLeft: 20)
        
        addSubview(twitterButton)
        twitterButton.centerY(inView: instagramButton, leftAnchor: instagramButton.rightAnchor, paddingLeft: 20)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTwitterButton(_ sender: UIButton) {
        print("twitter button")
        delegate?.followCreateView(self, twitterString: twitterUrl)
    }
    @objc func handleIGButton(_ sender: UIButton) {
        print("IG button")
        delegate?.followCreateView(self, igTwitterString: igUrl)
    }
}
