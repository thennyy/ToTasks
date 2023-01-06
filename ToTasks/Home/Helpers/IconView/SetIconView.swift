//
//  SetIconView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/22/22.
//

import UIKit

protocol SetIconViewDelegate: AnyObject {
    
    func setIconView(_ viewAlertPurchaseView: SetIconView, index: IndexPath)
    
    func setIconView(_ imageString: String)
    func setIconSelectButton(_ view: SetIconView, button: UIButton)
    func setIconAlertPremium()
    
}
class SetIconView: UIView {
    
    var premium = false
    
    private let backGroundView = UIView()
    private let premiumView = UIView()
    
    private var icons = [IconModel]()
    
    weak var delegate: SetIconViewDelegate?
    
    private var lastIndex: IndexPath?
    private var selectedIcon: String?
    
    private var iconArray = ["star.fill",
                             "house",
                             "square.and.pencil",
                             "folder",
                             "calendar",
                             "rectangle.and.paperclip"]
    
    private lazy var premiumImage = PremiumImageView(frame: .zero)

    
    private lazy var collectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.register(IconCollectionViewCell.self,
                                forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        return cv
        
    }()

    private lazy var premiumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PremiumIconCollectionCell.self, forCellWithReuseIdentifier: PremiumIconCollectionCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear 
        return cv
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .label
        label.text = "Icons"
        return label
    }()
    
    private lazy var mroeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("More...", for: .normal)
        button.tintColor = .black
        return button
    }()
    private let secondtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .smallMedium
        label.textColor = .darkGray
        
        return label
    }()
    private let firstIconImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "star.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12))
       
        iv.setDemensions(height: 39, width: 39)
        iv.tintColor = .lightGray
        iv.layer.cornerRadius = 9
    
        return iv
    }()
    
    private let secondIconImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "star.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12))
        iv.setDemensions(height: 36, width: 36)
        iv.tintColor = .black
  
        iv.layer.cornerRadius = 6
        return iv
    }()
    private let thirdIconImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "moon.stars.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12))
        iv.setDemensions(height: 36, width: 36)
        iv.tintColor = .black
       // iv.backgroundColor = .white
        iv.layer.cornerRadius = 6
        return iv
    }()
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton(type: .system)
       // button.setImage(.forwardImage, for: .normal)
        button.tintColor = .darkGray
        button.setTitle("Select", for: .normal)
        button.titleLabel?.font = .smallMedium
        button.setTitleColor(.label, for: .normal)
        button.clipsToBounds = true
       // button.backgroundColor = .barDeselectedColor
        button.setDemensions(height: 30, width: 90)
        button.layer.cornerRadius = 30/2
        button.layer.borderColor = UIColor.orangeColor.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleSelectIconButton),
                         for: .touchUpInside)
        
        return button
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configureUI()
        configureIcons()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureUI() {
        
        layer.cornerRadius = 15
      //  layer.borderWidth = 1
       // layer.borderColor = UIColor.lightGray.cgColor
        backgroundColor = .systemGroupedBackground
 
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor,
                         left: leftAnchor,
                         paddingTop: 9,
                         paddingLeft: 0, height: 36)

        addSubview(firstIconImage)
        firstIconImage.anchor(top: titleLabel.bottomAnchor,
                              left: titleLabel.leftAnchor,
                              paddingTop: 6)
        
        addSubview(rightArrowButton)
        rightArrowButton.centerY(inView: firstIconImage,
                                 rightAnchor: rightAnchor)
        
        addSubview(collectionView)
        collectionView.anchor(top: firstIconImage.bottomAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              paddingTop: 20,
                              paddingLeft: 0,
                              paddingRight: 20, height: 42)
        
        premiumView.layer.cornerRadius = 12
        premiumView.layer.borderWidth = 1
        premiumView.layer.borderColor = UIColor.orangeColor.cgColor
        
        addSubview(premiumView)
        premiumView.anchor(top: collectionView.bottomAnchor,
                           left: leftAnchor,
                           bottom: bottomAnchor,
                           right: rightAnchor,
                           paddingTop: 30)

        addSubview(premiumImage)
        premiumImage.anchor(top: premiumView.topAnchor,
                            right: premiumView.rightAnchor,
                            paddingTop: -15,
                            paddingRight: 15)
        
        addSubview(premiumCollectionView)
        premiumCollectionView.anchor(top: premiumView.topAnchor,
                                     left: premiumView.leftAnchor,
                                     bottom: premiumView.bottomAnchor,
                                     right: premiumView.rightAnchor,
                                     paddingTop: 9,
                                     paddingLeft: 20,
                                     paddingBottom: 9,
                                     paddingRight: 20)

    }
    
    @objc func handleSelectIconButton(_ sender: UIButton) {
        delegate?.setIconSelectButton(self, button: sender)

    }
    func setSelectedIcon(imageString: String) {

        print("DEBUG: SELECT IMAGE" )
        print(imageString)
        firstIconImage.image = UIImage(systemName: imageString)
        firstIconImage.tintColor = .alarmColor
        
        if let index = self.lastIndex {
            self.collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.clear.cgColor
            
        }
  
        delegate?.setIconView(imageString)
        
    }
    func handleChangeSelectButton() {
        if selectedIcon == nil {
            rightArrowButton.layer.borderWidth = 3
            rightArrowButton.layer.borderColor = UIColor.orangeColor.cgColor
        }
       
    }
    func configureIcons() {
        
        Service.getJSONFile(forName: "Icon") { images in
          
            for i in 0...17 {
                self.icons.append(images[i])
            }
       
        }
        premiumCollectionView.reloadData()
        
    }
    func isPremium() {
        premiumCollectionView.isUserInteractionEnabled = true
        premiumImage.isHidden = true
        premiumView.layer.borderColor = UIColor.lightGray.cgColor
    }
    func notPremium() {
      //  premiumCollectionView.isUserInteractionEnabled = false
        premiumImage.isHidden = false
        premiumView.layer.borderColor = UIColor.orangeColor.cgColor
    }
    func deselectCollectionViews() {
        
        if let index = lastIndex {
            self.collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.clear.cgColor
            self.premiumCollectionView.cellForItem(at: self.lastIndex!)?.layer.borderColor = UIColor.clear.cgColor
            self.collectionView.reloadData()
            self.premiumCollectionView.reloadData()
            
        }
    }
    
}
// MARK: - UICollectionViewDataSource
extension SetIconView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 42, height: 42)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return iconArray.count
        }else {
            return icons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.identifier, for: indexPath) as! IconCollectionViewCell
            let image = "\(iconArray[indexPath.row])"
            cell.firstIconImage.image = UIImage(systemName: image)
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PremiumIconCollectionCell.identifier, for: indexPath) as! PremiumIconCollectionCell
            let image = "\(icons[indexPath.row].name)"
            cell.firstIconImage.image = UIImage(systemName: image)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath
        
        if collectionView == self.collectionView {
            firstIconImage.image = UIImage(systemName: "\(iconArray[index.row])")
            firstIconImage.tintColor  = .alarmColor
            selectedCollectionView(index)
        }else if collectionView == self.premiumCollectionView {
            if premium == false {
                delegate?.setIconAlertPremium()
            }else {
                firstIconImage.image = UIImage(systemName: icons[index.row].name)
                firstIconImage.tintColor  = .alarmColor
                selectedPremiumCollectionView(index)
            }
        }

    }
    func selectedCollectionView(_ index: IndexPath) {
        
        if self.lastIndex == nil {
            
            self.collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.alarmColor.cgColor
            
            icons[index.row].isIconSelected = true
            self.lastIndex = index
            self.selectedIcon = iconArray[index.row]
            
            delegate?.setIconView(iconArray[index.row])
            
            
        }else {
            
            self.collectionView.cellForItem(at: self.lastIndex!)?.layer.borderColor = UIColor.clear.cgColor
            self.premiumCollectionView.cellForItem(at: self.lastIndex!)?.layer.borderColor = UIColor.clear.cgColor
            
            self.collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.alarmColor.cgColor
            self.selectedIcon = iconArray[index.row]
           
            firstIconImage.image = UIImage(systemName: "\(iconArray[index.row])")
            firstIconImage.tintColor = .alarmColor
            
            delegate?.setIconView(iconArray[index.row])
            self.lastIndex = index
        }
        
    }
    func selectedPremiumCollectionView(_ index: IndexPath) {
        
        if self.lastIndex == nil {
            
            self.premiumCollectionView.cellForItem(at: index)?.layer.borderColor = UIColor.alarmColor.cgColor
            
            icons[index.row].isIconSelected = true
            self.lastIndex = index
            self.selectedIcon = icons[index.row].name
            
            delegate?.setIconView(icons[index.row].name)
            
        }else {
            
            self.premiumCollectionView.cellForItem(at: self.lastIndex!)?.layer.borderColor = UIColor.clear.cgColor
            self.collectionView.cellForItem(at: self.lastIndex!)?.layer.borderColor = UIColor.clear.cgColor
            
            self.premiumCollectionView.cellForItem(at: index)?.layer.borderColor = UIColor.alarmColor.cgColor
            self.selectedIcon = icons[index.row].name
            self.lastIndex = index
            firstIconImage.image = UIImage(systemName: icons[index.row].name)
            firstIconImage.tintColor = .alarmColor
            
            delegate?.setIconView(icons[index.row].name)
        }
    }
    
}
