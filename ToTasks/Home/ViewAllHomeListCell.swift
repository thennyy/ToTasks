//
//  ViewAllListCell.swift
//  RednGreen
//
//  Created by Thenny Chhorn on 11/10/22.
//

import UIKit
protocol ViewAllHomeListCellDelegate: AnyObject {
    func viewAllHomeListCellInfoButton(_ view: ViewAllHomeListCell, indexPath: IndexPath)
}
class ViewAllHomeListCell: UICollectionViewCell {
    
    static let identifier = "viewAllHomeListCell"
   
    weak var delegate: ViewAllHomeListCellDelegate?
    
    var viewModel: AllCategoryViewModel! {
        didSet {
            configureData()
        }
    }
 
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .darkGray
        label.textAlignment = .left
        label.text = "Nov 10"
        return label
    }()
    private lazy var settingButton: UIButton = {
        let button = UIButton(type: .system)
       // let image = UIImage(named: "dots")
        button.setImage(.moreButton, for: .normal)
        button.tintColor = .darkGray
        button.setDemensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(handleMoreButton), for: .touchUpInside)
        
        return button
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .titleLight
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    private let descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .gray
        label.textAlignment = .left
        
        label.text = "find for the softest ones"
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit 
        iv.clipsToBounds = true
        iv.tintColor = .black
        iv.setDemensions(height: 39, width: 39)
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    private let backGroundView = UIView()
    
    func configureUI() {
        
        backgroundColor = .clear
        
        layer.cornerRadius = 24

        backGroundView.layer.borderWidth = 2
        backGroundView.layer.borderColor = UIColor.white.cgColor
        backGroundView.layer.cornerRadius = 24
        backGroundView.backgroundColor = .shareColor
        
        addSubview(backGroundView)
        backGroundView.setDemensions(height: self.frame.height - 10,
                                     width: self.frame.width - 10)
        
        backGroundView.centerX(inView: self)
        backGroundView.centerY(inView: self)
        
        contentView.addSubview(iconImageView)
        iconImageView.centerX(inView: self,
                              topAnchor: topAnchor,
                              paddingTop: 30)
     
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: iconImageView.bottomAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          paddingTop: 9,
                          paddingLeft: 12,
                          paddingRight: 12)
        
     
        contentView.addSubview(settingButton)
        settingButton.anchor(top: backGroundView.topAnchor,
                             right: backGroundView.rightAnchor,
                             paddingTop: 9,
                             paddingRight: 9)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureData() {

        backgroundColor = viewModel.backGroundColor
        titleLabel.text = viewModel.categoryName
        iconImageView.image = viewModel.iconImage
        
        Service.setDateReminder(viewModel.setTimeToAlert, category: viewModel.category)
        
    }
    

    func iconImage(_ icon: UIImage) {
        iconImageView.image = icon
    }
 
    @objc func handleMoreButton(_ sender: UIButton) {
        
        guard let indexPath = viewModel.indexPath else {return}
        delegate?.viewAllHomeListCellInfoButton(self, indexPath: indexPath)
        
    }

}
