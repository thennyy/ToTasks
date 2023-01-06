//
//  IconController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/23/22.
//

import UIKit


protocol IconControllerDelegate: AnyObject {
    func iconControllerView(_ view: IconController, imageString: String)
}

class IconController: UICollectionViewController {
   
    // MARK: - Properties
    
    private var icons = [IconModel]()
    private var filterIcons = [IconModel]()
    
    private var lastIndex: IndexPath?
    private var selectedIcon: String?
    
    var delegate: IconControllerDelegate?
    
    private let navigationView = NavigationView(title: "",
                                                leftButtonImage: .xmarkCircleImage,
                                                rightString: "Done")
    
    
    private let textField = UITextField(placeHolder: "search for icon",
                                        textColor: .black, cornerRadius: 9)
    
    private lazy var closeButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.tintColor = .darkGray
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        button.setDemensions(height: 24, width: 24)
        button.layer.cornerRadius = 9
        button.setImage(.xmarkCircleImage, for: .normal)
        button.addTarget(self, action: #selector(handleCloseButton),
                         for: .touchUpInside)
        return button
        
    }()
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureIcons()

        
    }
    fileprivate func configureUI() {
        
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(navigationView)
        navigationView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              height: 72)
        
        navigationView.delegate = self
        navigationView.disableRightButton()
        
        textField.backgroundColor = .grayColor
        textField.delegate = self
        
        view.addSubview(textField)
        textField.anchor(top: navigationView.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 9,
                         paddingLeft: 20,
                         paddingRight: 20,
                         height: 45)
        
       // collectionView.backgroundColor = .white
        collectionView.register(IconCollectionCell.self,
                                forCellWithReuseIdentifier: IconCollectionCell.identifier)
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.contentInset = UIEdgeInsets(top: 90,
                                                   left: 20,
                                                   bottom: 20,
                                                   right: 20)
   
        
    }
    
    // MARK: - Helpers
    
    func configureIcons() {
        
        Service.getJSONFile(forName: "Icon") { images in
            self.icons = images
            self.filterIcons = self.icons
        }
        collectionView.reloadData()
    }

    func refreshCollectionView() {
        collectionView.reloadData()
    }
    @objc func handleCloseButton() {
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension IconController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
        return CGSize(width: 60, height: 60)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
}
// MARK: - UICollectionViewDatasource

extension IconController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionCell.identifier, for: indexPath) as! IconCollectionCell
      
        guard let section = IconSection(rawValue: indexPath.section) else {return cell}
        
        cell.viewModel = IconCollectionViewModel(icon: filterIcons[indexPath.row], section: section)
        
        if filterIcons[indexPath.row].isIconSelected != nil {
            cell.configureSelectIndex(.orangeColor)
        }else {
            cell.configureSelectIndex(.clear)
        }
    
        return cell
        
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return filterIcons.count
       // return filterIcons.count
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionCell.identifier, for: indexPath) as! IconCollectionCell
        
        cell.selectIcon(indexPath: indexPath)
 
        let index = indexPath
        selectedIcon = filterIcons[index.row].name
      
        navigationView.enableRightButton()
        
        if self.lastIndex == nil {

            self.collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.alarmColor.cgColor
            self.collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 3

            filterIcons[index.row].isIconSelected = true
            self.lastIndex = index

        }else {

            self.collectionView.cellForItem(at: self.lastIndex!)?.layer.borderColor = UIColor.clear.cgColor
            self.collectionView.cellForItem(at: self.lastIndex!)?.layer.borderWidth = 1

            self.collectionView.cellForItem(at: index)?.layer.borderColor = UIColor.alarmColor.cgColor
            self.collectionView.cellForItem(at: index)?.layer.borderWidth = 3

            filterIcons[index.row].isIconSelected = true
            self.lastIndex = index

        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 60)
        
    }
}
// MARK: - NavigationViewDelegate
extension IconController: NavigationViewDelegate {
  
    func navigationView(_ view: NavigationView, leftButton: UIButton) {
        self.dismiss(animated: true)
    }
    
    func navigationView(_ view: NavigationView, rightButton: UIButton) {
        
        guard let icon = selectedIcon else {return}
        delegate?.iconControllerView(self, imageString: icon)
        print("SELECTED ICON, ", icon)
        self.dismiss(animated: true)
        
    }
    
    
}
extension IconController: UITextFieldDelegate {
    
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
