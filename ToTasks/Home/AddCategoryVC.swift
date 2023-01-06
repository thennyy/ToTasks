//
//  AddCategoryVC.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/19/22.
//

import UIKit
import NotificationCenter

protocol AddCategoryVCDelegate: AnyObject {
    func addCategoryVC(_ controller: AddCategoryVC, category: Category)
}
class AddCategoryVC: UIViewController {
    
    // MARK: - Properties
    private var taskModel = TaskModel()
    
    private var icons = [Image]()
    private var filterIcons = [Image]()
    private var lastIndex: IndexPath?
    private var selectedIcon: String!
    
    var category: Category! {
        didSet {
            configureCategory()
            colorsView.viewModel = AllCategoryViewModel(category: category)
        }
    }
    
    
    weak var delegate: AddCategoryVCDelegate?
    
    
    
    private let searchTextField = UITextField(placeHolder: "Look for icon",
                                              textColor: .label)
    
    private var textField = UITextField(placeHolder: "New category...",
                                        textColor: .black)
    
    private let navigationView = NavigationView(title: "Add Category",
                                                leftButtonImage: .xmarkImage,
                                                rightString: "Done")
    
    private let wordCountView = WordCountView(wordCount: "20")
    
    private let colorsView = ColorsView()
    
    private let iconView = SetIconView()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Set Icon"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        textField.addTarget(self, action: #selector(configureTextField),
                            for: .editingChanged)
        
        filterIcons = icons
        colorsView.delegate = self
        iconView.delegate = self
        navigationView.disableRightButton()
        configurePremium()
    
        textField.becomeFirstResponder() 
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    func configureUI() {
        
        navigationView.delegate = self
        textField.backgroundColor = .grayColor
        textField.delegate = self
        view.backgroundColor = .systemGroupedBackground
        //view.isOpaque = true
        view.addSubview(navigationView)
        navigationView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              height: 72)
        
        view.addSubview(textField)
        textField.anchor(top: navigationView.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 20,
                         paddingRight: 20,
                         height: 42)
        
        view.addSubview(wordCountView)
        wordCountView.anchor(top: textField.bottomAnchor,
                             right: textField.rightAnchor,
                             paddingRight: 6,
                             height: 30)
        
        view.addSubview(colorsView)
        colorsView.anchor(top: textField.bottomAnchor,
                          left: textField.leftAnchor,
                          right: textField.rightAnchor,
                          paddingTop: 45, height: 172)
        
        view.addSubview(iconView)
        iconView.anchor(top: colorsView.bottomAnchor,
                        left: view.leftAnchor,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor,
                        right: view.rightAnchor,
                        paddingTop: 20,
                        paddingLeft: 20,
                        paddingRight: 20)
        
        
    }
    
    @objc func configureTextField(_ textField: UITextField) {
        configureWordCounting(textField)
    }
    func configureWordCounting(_ textField: UITextField) {
        
        Service.countingWordsTextField(textField, textLimit: 20) { wordCount in
            self.wordCountView.wordCountLabel.text = "\(wordCount)"
        }
        
    }
    
    func configureCategory() {
        
        guard let text = category.name else {return}
        textField.text = text
        
        guard let icon = category.image else {return}
        iconView.setSelectedIcon(imageString: icon)
        
    }
    func configurePremium() {
        if isPurchased() {
            colorsView.isPremium()
            iconView.isPremium()
            iconView.premium = true
            colorsView.premium = true
        }else {
            colorsView.notPremium()
            iconView.notPremium()
            iconView.premium = false
            colorsView.premium = false 
        }
    }

}
// MARK: - NavigationViewDelegate
extension AddCategoryVC: NavigationViewDelegate {
   
    func navigationView(_ view: NavigationView, leftButton: UIButton) {
        self.dismiss(animated: true)
    }
    
    func navigationView(_ view: NavigationView, rightButton: UIButton) {
 
        if category != nil {
            print("UPDATE CATEGORY")
            
        }else {
                       
            let category = DataManager.shared.addCategory(taskModel)
            delegate?.addCategoryVC(self, category: category)

        }
    }
    
}
// MARK: - UITextFieldDelegate
extension AddCategoryVC: UITextFieldDelegate {
   
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.text?.isEmpty == false {
            navigationView.enableRightButton()
            if textField.text!.count > 20 {
                self.configureAlertMessage("You have reached maximum text")
                self.wordCountView.overMaximumWordCount()
                
            }else {
                self.wordCountView.underMaximumWordCount()
            }
            taskModel.name = textField.text
           // delegate?.filteredCategory(self, text: textField.text!)
            
        }else {
            self.navigationView.disableRightButton()
        }
    }
}


// MARK: - ColorsViewDelegate

extension AddCategoryVC: ColorsViewDelegate {
   
    func colorsViewButtons(_ view: ColorsView, selectedColor: Color) {
        
        taskModel.color = selectedColor.description
       // navigationView.enableRightButton()
        
    }
    
    func colorsViewPremium(_ viewAlertPurchase: ColorsView) {
        alertPurchasePremium()

    }

}
// MARK: - SetIconViewDelegate

extension AddCategoryVC: SetIconViewDelegate {
    func setIconAlertPremium() {
        alertPurchasePremium()
    }
    
    func setIconSelectButton(_ view: SetIconView, button: UIButton) {
        if isPurchased() {
                let layout = UICollectionViewFlowLayout()
                let vc = IconController(collectionViewLayout: layout)
                vc.delegate = self
                present(vc, animated: true)
                textField.resignFirstResponder()
            }else {
                alertPurchasePremium()
            }
        
    }
  
    func setIconView(_ viewAlertPurchaseView: SetIconView, index: IndexPath) {
     
        if !isPurchased() {
            alertPurchasePremium()
        }else {
            viewAlertPurchaseView.selectedPremiumCollectionView(index)
        }
        
    }
    
    func setIconView(_ imageString: String) {
        print(imageString)
        taskModel.image = imageString
    }
    
    func setIconView(_ viewWantsToViewAllIcon: SetIconView) {
        
        if isPurchased() {
            let layout = UICollectionViewFlowLayout()
            let vc = IconController(collectionViewLayout: layout)
            vc.delegate = self
            present(vc, animated: true)
            textField.resignFirstResponder()
        }else {
            alertPurchasePremium()
        }
    }
    
}
// MARK: - IconControllerDelegate
extension AddCategoryVC: IconControllerDelegate {
    
    func iconControllerView(_ view: IconController, imageString: String) {
        iconView.setSelectedIcon(imageString: imageString)
        taskModel.image = imageString
        iconView.deselectCollectionViews()
        
    }
    
}
