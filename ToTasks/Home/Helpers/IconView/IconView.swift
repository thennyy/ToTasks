//
//  IconView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/19/22.
//

import UIKit
protocol IconViewDelegate: AnyObject {
    func iconView(_ view: IconView, imageString: String)
}
class IconView: UIView {
    
    private var icons = [Image]()
    private var filterIcons = [Image]()
    private var lastIndex: IndexPath?
    private var selectedIcon: String?
    private var item = Item()
    
    var delegate: IconViewDelegate?
    private let textField = UITextField(placeHolder: "Look for icon", textColor: .black, cornerRadius: 9)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Set Icon"
        return label
    }()
    
    private let premiumImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "star.square")
        iv.setDemensions(height: 30, width: 30)
        iv.tintColor = .yellowColor
        return iv
    }()
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See more", for: .normal)
        button.titleLabel?.font = UIFont.smallMedium
        button.setDemensions(height: 39, width: 111)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .grayColor
        button.layer.cornerRadius = 9
        
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.isUserInteractionEnabled = true
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        textField.delegate = self
//        addSubview(titleLabel)
//        titleLabel.anchor(top: topAnchor, left: leftAnchor)
//
        textField.backgroundColor = .grayColor
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       premiumImage]).withAttributes(axis: .horizontal, spacing: 20, distribution: .fill)
        
        
        
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor,
                              left: leftAnchor,
                              paddingTop: 20)
        
        collectionView.register(IconCollectionCell.self,
                                forCellWithReuseIdentifier: IconCollectionCell.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 20,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 20)
//
//        addSubview(seeMoreButton)
//        seeMoreButton.anchor(top: collectionView.bottomAnchor,
//                             right: collectionView.rightAnchor,
//                             paddingTop: 9)
        
        configureIcons()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureIcons() {
//        Service.getJSONFile(forName: "Icon") { images in
//            self.icons = images
//            self.filterIcons = self.icons
//        }
//        collectionView.reloadData()
    }

    func refreshCollectionView() {
        collectionView.reloadData() 
    }
}
extension IconView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionCell.identifier, for: indexPath) as! IconCollectionCell
       
        cell.iconImageView.image = UIImage(systemName: "\(filterIcons[indexPath.row].name)")

        if selectedIcon != nil {
            cell.configureSelectIndex(.orangeColor)
        }else {
            cell.configureSelectIndex(.clear)
        }
//        if filterIcons[indexPath.row].isSelected == false {
//            cell.configureSelectIndex(.clear)
//        }else {
//            cell.configureSelectIndex(.orangeColor, height: 3)
//        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterIcons.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

       // filterIcons[indexPath.row] = true
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionCell.identifier, for: indexPath) as! IconCollectionCell
        
        cell.selectIcon(indexPath: indexPath)
        
//
//        cell.configureSelectIndex(UIColor.orangeColor, height: 3)
//
//        cell.configureBackground(.barDeselectedColor)
//
        
        let index = indexPath
        selectedIcon = filterIcons[index.row].name
      
        delegate?.iconView(self, imageString: filterIcons[index.row].name)
        

        if self.lastIndex == nil {

            self.collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.orangeColor.cgColor
            self.collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 3

            self.lastIndex = index

        }else {

            self.collectionView.cellForItem(at: self.lastIndex!)?.layer.borderColor = UIColor.clear.cgColor
            self.collectionView.cellForItem(at: self.lastIndex!)?.layer.borderWidth = 1

            self.collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.orangeColor.cgColor
            self.collectionView.cellForItem(at: index)?.layer.borderWidth = 3

            self.lastIndex = index

        }
        
    }
    
}
extension IconView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
        return CGSize(width: 39, height: 39)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
}
extension IconView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            if text.isEmpty == false {
                filterIcons = icons.filter({ image in
                    return image.name.lowercased().contains(text.lowercased())
                })
                self.collectionView.reloadData()
            }else {
                filterIcons = icons
                self.collectionView.reloadData()
            }
        }
    }
}
//extension IconView: AddCategoryVCDelegate {
//   
//    func filteredCategory(_ controller: AddCategoryVC, text: String) {
//        if text.isEmpty == true {
//            filterIcons = icons
//            collectionView.reloadData()
//        }else {
//            filterIcons = icons.filter({ icon in
//                return icon.name.lowercased().contains(text.lowercased())
//            })
//            self.collectionView.reloadData() 
//        }
//        
//    }
//    
//}
