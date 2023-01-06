//
//  IconCollectionCell.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/19/22.
//

import UIKit

class IconCollectionCell: UICollectionViewCell {
    
    static let identifier = "iconCollectionCell"
    
    private var selectedIndexPath: IndexPath?
  
    var viewModel: IconCollectionViewModel! {
        didSet {
            
            iconImageView.image =  UIImage(systemName:"\(viewModel.imageString)")
            
        }
    }

    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .label
        iv.setDemensions(height: 39, width: 39)
        return iv
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
      //  configureSelectIndex(UIColor.orangeColor, height: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
        if viewModel.isSelction == nil {
            configureSelectIndex(.clear)
        }else {
            configureSelectIndex(.orangeColor)
        }
        
    }
    func configureUI() {
        
       // contentView.layer.borderWidth = 1
        layer.cornerRadius = 18
        contentView.addSubview(iconImageView)
        
        iconImageView.centerX(inView: self)
        iconImageView.centerY(inView: self)

        
    }
    func selectIcon( indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
    func configureSelectIndex(_ color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 3
    }
    func configureBackground(_ color: UIColor = .white) {
        backgroundColor = color
    }

}

