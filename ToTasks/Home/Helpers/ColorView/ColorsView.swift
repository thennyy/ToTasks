//
//  ColorsView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/19/22.
//

import UIKit


protocol ColorsViewDelegate: AnyObject {
    func colorsViewButtons(_ view: ColorsView, selectedColor: Color)
    func colorsViewPremium(_ viewAlertPurchase: ColorsView)
}
class ColorsView: UIView {
    
    weak var delegate: ColorsViewDelegate?
    
    var viewModel: AllCategoryViewModel! {
        didSet {
            
            configureColor(viewModel.selectedBackGroundColor)
        }
    }
    var premium = false
    
    private var selectedColor = "orangeColor"
    private var lastIndex: IndexPath?
    private var chosenColor: UIColor = UIColor()
    
    private let premiumView = UIView()
    
    private var colorArray = [UIColor.pinkColor,
                              UIColor.blueColor,
                              UIColor.greenColor,
                              UIColor.lavenderColor,
                              UIColor.tealColor,
                              UIColor.oliveColor]
    
    private lazy var premiumImage = PremiumImageView(frame: .zero)

    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero,
                                  collectionViewLayout: layout)
        
        cv.delegate = self
        cv.dataSource = self
        cv.register(ColorCollectionCell.self,
                    forCellWithReuseIdentifier: ColorCollectionCell.identifier)
        cv.backgroundColor = .clear
        
        return cv
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .label
        label.textAlignment = .left
        label.text = "Tint colors"
        return label
    }()
    private let yellowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .yellowColor
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 9
        button.clipsToBounds = true
        button.setWidth(width: 42)
        return button
    }()
    private let orangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .orangeColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 9
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.alarmColor.cgColor
        button.setWidth(width: 42)
        
        return button
    }()
   

    private lazy var stackView =  UIStackView(arrangedSubviews: [orangeButton,
                                                                 yellowButton]).withAttributes(axis: .horizontal,spacing: 9, distribution: .fill)
 
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureUI()
        configureSelectors()
        
        
    }
    func configureUI() {
        
       // let stackView =

    
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor)
        
        addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor,
                         left: leftAnchor,
                         paddingTop: 9, height: 42)
        
        premiumView.layer.borderColor = UIColor.orangeColor.cgColor
        premiumView.layer.borderWidth = 1
        premiumView.layer.cornerRadius = 12
        
        addSubview(premiumView)
        premiumView.anchor(top: stackView.bottomAnchor,
                           left: leftAnchor,
                           right: rightAnchor,
                           paddingTop: 20,
                           height: 90)
        
        addSubview(premiumImage)
        premiumImage.anchor(top: premiumView.topAnchor,
                            right: premiumView.rightAnchor,
                            paddingTop: -15,
                            paddingRight: 15)
        
        premiumView.addSubview(collectionView)
        collectionView.setHeight(height: 42)
        collectionView.centerY(inView: premiumView,
                               leftAnchor: premiumView.leftAnchor, rightAnchor: premiumView.rightAnchor,
                                 paddingLeft: 20)
        
        
    }
    func configureDeselectDefaultButtons() {
        orangeButton.layer.borderColor = UIColor.clear.cgColor
        yellowButton.layer.borderColor = UIColor.clear.cgColor
    }
    func configureSelectors() {
        orangeButton.addTarget(self, action: #selector(handleSelectedColor), for: .touchUpInside)
        yellowButton.addTarget(self, action: #selector(handleSelectedColor), for: .touchUpInside)
 
    }
    func isPremium() {
        
        premiumImage.isHidden = true
        premiumView.layer.borderColor = UIColor.lightGray.cgColor
        collectionView.isUserInteractionEnabled = true
        
    }
    func notPremium() {
      //  collectionView.isUserInteractionEnabled = false
        premiumView.layer.borderColor = UIColor.orangeColor.cgColor
        premiumImage.isHidden = false
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func handleSelectedColor(_ sender: UIButton) {

        switch sender {
            
        case yellowButton:
            
            if let lastIndex = lastIndex {
                
                collectionView.cellForItem(at: lastIndex)?.layer.borderColor = UIColor.clear.cgColor
                collectionView.reloadData()
            }
            delegate?.colorsViewButtons(self, selectedColor: .yellow)
            
            selectedColor = "yellowColor"
            
            yellowButton.layer.borderColor = UIColor.alarmColor.cgColor
            orangeButton.layer.borderColor = UIColor.clear.cgColor
            
        case orangeButton:
            
            if let lastIndex = lastIndex {
                
                collectionView.cellForItem(at: lastIndex)?.layer.borderColor = UIColor.clear.cgColor
                collectionView.reloadData()
            }
            delegate?.colorsViewButtons(self, selectedColor: .orange)
            yellowButton.layer.borderColor = UIColor.clear.cgColor
            orangeButton.layer.borderColor = UIColor.alarmColor.cgColor
            selectedColor = "orangeColor"
            
        default:
            delegate?.colorsViewButtons(self, selectedColor: .orange)
            selectedColor = "orangeColor"
            
            break
        }
        
    }
    func configureColors(_ color: UIColor) -> Color {
        switch color {
        case .orangeColor:
            return Color.orange
        case .yellowColor:
            return Color.yellow
        case .pinkColor:
            return Color.pink
        case .blueColor:
            return Color.blue
        case .greenColor:
            return Color.green
        case .lavenderColor:
            return Color.lavender
        case .tealColor:
            return Color.teal
        case .oliveColor:
            return Color.olive
        default:
            return Color.orange
        }
    }
    func configureColor(_ colorString: String) {
        
        orangeButton.layer.borderColor = UIColor.clear.cgColor
        print("DEBUG: CONFIGUREING COLOR")
        switch colorString {
            
        case "orangeColor":
            orangeButton.layer.borderColor = UIColor.alarmColor.cgColor
            print("orange")
        case "yellowColor":
            yellowButton.layer.borderColor = UIColor.alarmColor.cgColor
            print("yellow")
        case "pinkColor":
            let index = IndexPath(row: 0, section: 0)
            collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.alarmColor.cgColor
            collectionView.reloadData()
            print("pink")
        case "blueColor":
            let index = IndexPath(row: 1, section: 0)
            collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.alarmColor.cgColor
            print("blue")
        case "greenColor":
            let index = IndexPath(row: 2, section: 0)
            collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.alarmColor.cgColor
            print("green")
        case "lavenderColor":
            let index = IndexPath(row: 3, section: 0)
            collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.alarmColor.cgColor
            print("lavender")
        case "tealColor":
            
            let index = IndexPath(row: 4, section: 0)
            collectionView.cellForItem(at: index)?.contentView.layer.borderColor = UIColor.alarmColor.cgColor
            collectionView.cellForItem(at: index)?.contentView.layer.borderWidth = 3
            collectionView.reloadData()
            print("teal")
        case "oliveColor":
            let index = IndexPath(row: 5, section: 0)
            collectionView.cellForItem(at: index)?.contentView.layer.borderColor = UIColor.alarmColor.cgColor
            collectionView.cellForItem(at: index)?.contentView.layer.borderWidth = 3
            collectionView.reloadData()
            print("olive")
        default:
            orangeButton.layer.borderColor = UIColor.alarmColor.cgColor
        }

    }
}
extension ColorsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionCell.identifier, for: indexPath) as! ColorCollectionCell
        
        cell.backgroundColor = colorArray[indexPath.row]
        
        guard let viewModel = viewModel else {return cell}
        
        if viewModel.backGroundColor == colorArray[indexPath.row] {
            cell.selectedAnswer()
            self.lastIndex = indexPath
        }else {
            cell.unSelectedAnswer()
        }
       
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 42, height: 42)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        chosenColor = colorArray[indexPath.row]
        
        
        let index = indexPath
        
        if premium == false {
            delegate?.colorsViewPremium(self)
            
        }else {
            
            configureDeselectDefaultButtons()
            
            let selectedColor = configureColors(colorArray[index.row])
   print(selectedColor)
            if self.lastIndex == nil {
              //  let selectedColor = configureColors(colorArray[index.row])
                self.collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.alarmColor.cgColor
                delegate?.colorsViewButtons(self, selectedColor: selectedColor)
                self.lastIndex = index
                
            }else {
                self.collectionView.cellForItem(at: self.lastIndex!)?.layer.borderColor = UIColor.clear.cgColor

                self.collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.alarmColor.cgColor
                self.chosenColor = colorArray[index.row]
                
                delegate?.colorsViewButtons(self, selectedColor: selectedColor)
                self.lastIndex = index
            }
        }
   
         
          
    }
}
