//
//  CategorySettingController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/21/22.
//

import UIKit
protocol CategorySettingControllerDelegate: AnyObject {
    func categorySettingController(_ controllerWantsToUpdate: CategorySettingController,
                                   category: Category)
}
class CategorySettingController: UIViewController {

    private let backGroundView = UIView()
    var titleString: String!
    var indexPath: IndexPath!
    
    weak var delegate: CategorySettingControllerDelegate?
    
    var taskModel = TaskModel()
    
    var category: Category! {
        
        didSet {
            
            taskModel.name = category.name
            taskModel.image = category.image
            taskModel.color = category.color
            
            configureCategory()

            colorsView.viewModel = AllCategoryViewModel(category: category)
            
        }
    }
    
    // MARK: - Properties
    private lazy var navigationView = NavigationView(title: "Edit Category",
                                                leftButtonImage: .xmarkCircleImage,
                                                rightString: "Done")
    
    
    private var textField = UITextField(placeHolder: "New category...",
                                        textColor: .black)
    
    private let wordCountView = WordCountView(wordCount: "20")
    
    private let iconView = SetIconView()
    
    private let colorsView = ColorsView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureUI()
        textField.delegate = self
        navigationView.delegate = self
        navigationView.disableRightButton()
        
        colorsView.delegate = self
        iconView.delegate = self
        
        configurePremium()
        
        textField.addTarget(self, action: #selector(configureTextField),
                            for: .editingChanged)
        
        textField.becomeFirstResponder()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    func configureUI() {
        
        view.backgroundColor = .systemGroupedBackground
        
        navigationView.backgroundColor = .clear
        
        textField.backgroundColor = .grayColor
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
    func configureCategory() {
        
        textField.text = taskModel.name
        colorsView.configureColor(taskModel.color ?? "orangeColor")
        iconView.setSelectedIcon(imageString: taskModel.image ?? "star.fill")
    
    }
    @objc func configureTextField(_ textField: UITextField) {
        configureWordCounting(textField)
    }
    func configureWordCounting(_ textField: UITextField) {
        
        Service.countingWordsTextField(textField, textLimit: 20) { wordCount in
            self.wordCountView.wordCountLabel.text = "\(wordCount)"
        }
      
    }

}
// MARK: - UITextFieldDelegate
extension CategorySettingController: UITextFieldDelegate {
   
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.text?.isEmpty == false {
            navigationView.enableRightButton()
            if textField.text!.count > 20 {
                self.configureAlertMessage("You have reached maximum text")
                self.wordCountView.overMaximumWordCount()
                
            }else {
                self.wordCountView.underMaximumWordCount()
            }

            self.taskModel.name = textField.text
            
        }else {
            self.navigationView.disableRightButton()
        }
    }
}
// MARK: - NavigationViewDelegate
extension CategorySettingController: NavigationViewDelegate {
    
    func navigationView(_ view: NavigationView, leftButton: UIButton) {
        self.dismiss(animated: true)
    }
    
    func navigationView(_ view: NavigationView, rightButton: UIButton) {
        
        if taskModel.color != category.color || taskModel.name != category.name || taskModel.image != category.image  {
            
            category.setValue(taskModel.color, forKey: "color")
            category.setValue(taskModel.name, forKey: "name")
            category.setValue(taskModel.image, forKey: "image")
            
            DataManager.shared.saveContext()
            delegate?.categorySettingController(self, category: category)
            self.dismiss(animated: true)
        }

    }
    
}
// MARK: - ColorsViewDelegate
extension CategorySettingController: ColorsViewDelegate {
    func colorsViewButtons(_ view: ColorsView, selectedColor: Color) {
        
        taskModel.color = selectedColor.description
        navigationView.enableRightButton()
        
    }
    
    func colorsViewPremium(_ viewAlertPurchase: ColorsView) {
        alertPurchasePremium() 
    }

}
// MARK: - IconViewDelegate

extension CategorySettingController:  SetIconViewDelegate {
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
        
    }

    func setIconView(_ imageString: String) {
        taskModel.image = imageString
        navigationView.enableRightButton()
    }

}
// MARK: - IconControllerDelegate

extension CategorySettingController: IconControllerDelegate {
    
    func iconControllerView(_ view: IconController, imageString: String) {
        iconView.setSelectedIcon(imageString: imageString)
        taskModel.image = imageString
        
        navigationView.enableRightButton()
        
    }
    
}
