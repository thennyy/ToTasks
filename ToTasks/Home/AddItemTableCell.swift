//
//  AddItemTableCell.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/18/22.
//

import UIKit
protocol ItemTableCellDelegate: AnyObject {
    func itemTableCell(_ cell: AddItemTableCell,indexPath: IndexPath)
}
class AddItemTableCell: UITableViewCell {
    
    static let identifier = "addItemTableCell"
    
    private var isChecked = false
    
    weak var delegate: ItemTableCellDelegate?
    
    var index: IndexPath!
    
    var item: Item! {
        didSet {
            configure()
        }
    }
    
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
        
    }()
    
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setDemensions(height: 36, width: 36)
        button.addTarget(self, action: #selector(handleCheckBoxButton), for: .touchUpInside)
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        let backGroundView = UIView()
        backGroundView.layer.cornerRadius = 12
        
        backGroundView.backgroundColor = .shareColor
        
        contentView.addSubview(backGroundView)
        backGroundView.anchor(top: contentView.topAnchor,
                              left: contentView.leftAnchor,
                              bottom: contentView.bottomAnchor,
                              right: contentView.rightAnchor,
                              paddingTop: 3,
                              paddingBottom: 3)
        
        
        contentView.addSubview(checkBoxButton)
        checkBoxButton.centerY(inView: contentView,
                               leftAnchor: contentView.leftAnchor,
                               paddingLeft: 12)
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: contentView.topAnchor,
                          left: checkBoxButton.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          right: contentView.rightAnchor,
                          paddingTop: 20,
                          paddingLeft: 20,
                          paddingBottom: 20,
                          paddingRight: 20)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleCheckBoxButton() {
        
        if item.done == false {
            checkBoxButton.setImage(.squareCheckFill, for: .normal)
            checkBoxButton.tintColor = .systemBlue
            isChecked = true
            item.done = true
        }else {
            checkBoxButton.setImage(.squareCheck, for: .normal)
            checkBoxButton.tintColor = .white
            isChecked = false
            item.done = false
        }
       
        delegate?.itemTableCell(self, indexPath: index)
        
    }
    
    func configure() {
    
        titleLabel.text = item.title
        print(item.done)
        if item.done == false {
            checkBoxButton.setImage(.squareCheck, for: .normal)
            checkBoxButton.tintColor = .white
        }else {
            checkBoxButton.setImage(.squareCheckFill, for: .normal)
            checkBoxButton.tintColor = .systemBlue
        }
    }
}
