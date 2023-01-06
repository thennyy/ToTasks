//
//  ViewController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/18/22.
//

import UIKit
import StoreKit

class HomeController: UIViewController {
    
// MARK: - Properties
    
    private let addButton = AddButton(type: .system)
    private let viewAllHomeListView = ViewAllListView()
    
    private var selectedIndex: IndexPath?
    
    private var categories = [Category]()
    
    private let reminderTextLabel = UILabel()
    
    private let titleLogoImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.filterImage, for: .normal)
        button.tintColor = .label
        button.setDemensions(height: 40, width: 40)
        button.addTarget(self, action: #selector(handleMenuButton),
                         for: .touchUpInside)
        return button
        
    }()
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchCategory()
        addButton.addTarget(self, action: #selector(handleAddCategoryButton),
                            for: .touchUpInside)
   
        viewAllHomeListView.delegate = self
        SKPaymentQueue.default().restoreCompletedTransactions()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        configureRemindTextLabel()
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .systemGroupedBackground
  
        view.addSubview(titleLogoImage)
        titleLogoImage.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              paddingTop: 0,
                              paddingLeft: 20,
                              width: 200,
                              height: 60)

        view.addSubview(menuButton)
        menuButton.centerY(inView: titleLogoImage,
                           rightAnchor: view.rightAnchor,
                           paddingRight: 20)
        
        view.addSubview(viewAllHomeListView)
        viewAllHomeListView.anchor(top: titleLogoImage.bottomAnchor,
                                   left: view.leftAnchor,
                                   bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   right: view.rightAnchor,
                                   paddingTop: 20)
        
        
        view.addSubview(addButton)
        
        addButton.setDemensions(height: 60, width: 60)
        addButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor,
                         paddingBottom: 20,
                         paddingRight: 20)
        
        
    }

    @objc func handleAddCategoryButton() {
        
        if isPurchased() {
            let vc = AddCategoryVC()
            vc.delegate = self
            print("debug: selected add task")
            present(vc, animated: true)
        }else {
            if categories.count == 6 {
                self.alertLimiteAddCategory()
                return
            }
            let vc = AddCategoryVC()
            vc.delegate = self
            print("debug: selected add task")
            present(vc, animated: true)
        }
       
    }
    func fetchCategory() {
        categories = DataManager.shared.fetchCategory()
        categories = sortingCategory()
        viewAllHomeListView.categories = categories
        
    }
    func updateCategories(_ category: Category) {
        categories.append(category)
        categories = sortingCategory()
        viewAllHomeListView.categories = categories
        viewAllHomeListView.refeshCollectionView()
        
        configureRemindTextLabel()
        
    }
    func sortingCategory() -> [Category] {
        var localCategory = [Category]()
        localCategory = categories.sorted { cate1, cate2 in
            return cate1.time?.compare(cate2.time!) == .orderedDescending
        }
        return localCategory
    
    }
    fileprivate func configureRemindTextLabel() {
        
        reminderTextLabel.textColor = .label
        reminderTextLabel.font = .regularMedium
        reminderTextLabel.text = "Start here"
         
        if categories.count < 1 {
            self.reminderTextLabel.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0) {
                self.view.addSubview(self.reminderTextLabel)
                self.reminderTextLabel.anchor(bottom: self.addButton.topAnchor,
                                              right: self.addButton.rightAnchor,
                                              paddingBottom: 30)
                
            }
        }else {
            reminderTextLabel.isHidden = true
        }
     

    }
    @objc func handleMenuButton() {
        
        let vc = PremiumController()
        let navigationView = UINavigationController(rootViewController: vc)
        present(navigationView, animated: true)
    }

}
// MARK: - IconViewDelegate
extension HomeController: IconViewDelegate {
    
    func iconView(_ view: IconView, imageString: String) {
        
        print("DEBUG: IMAGE", imageString)
    }
    
}
// MARK: - AddCategoryVCDelegate

extension HomeController: AddCategoryVCDelegate {
    
    func addCategoryVC(_ controller: AddCategoryVC, category: Category) {
        
        let viewModel = AllCategoryViewModel(category: category)
        updateCategories(category)
        controller.dismiss(animated: true)
        let vc = TaskController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
        
        configureRemindTextLabel()
        
    }
    
}

// MARK: - ViewAllListViewDelegate

extension HomeController: ViewAllListViewDelegate {
    
    func viewAllListMoreButtonView(_ indexPath: IndexPath) {
        
        let viewModel = AllCategoryViewModel(category: categories[indexPath.row], indexPath: indexPath)
        let vc = EditController(viewModel: viewModel)
        vc.delegate = self 
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
        
    }
    
    func viewAllListView(_ wantsToRefreshView: ViewAllListView, indexPath: IndexPath) {
       
        selectedIndex = indexPath
        let viewModel  = AllCategoryViewModel(category: categories[indexPath.row], indexPath: indexPath)
        
        let vc = TaskController(viewModel: viewModel)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.pushViewController(vc, animated: true)

    }

}
// MARK: - TaskControllerDelegate

extension HomeController: TaskControllerDelegate {
    
    func taskController(modifyIndexPath indexPath: IndexPath) {
        viewAllHomeListView.refeshCollectionView()
        
    }
    
    func taskController(_ controller: TaskController, indexPath: IndexPath) {
        categories.remove(at: indexPath.row)
        viewAllHomeListView.deleteCollectionCell(indexPath: indexPath)
        
    }
    
    func taskController(_ controller: TaskController, category: Category) {
        
        DataManager.shared.deleteCategory(category: category)
     
        _ = Timer(timeInterval: 0.6, repeats: true) { _ in
            self.configureRemindTextLabel()
            
        }
      //  configureRemindTextLabel()
    }
  
}
// MARK: - EditControllerDelegate
extension HomeController: EditControllerDelegate {
   
    func editController(_ controllerWantsToDelete: EditController, indexPath: IndexPath) {
        
        categories.remove(at: indexPath.row)
        controllerWantsToDelete.dismiss(animated: true)
        viewAllHomeListView.deleteCollectionCell(indexPath: indexPath)
        viewAllHomeListView.refeshCollectionView()
      
        UIView.animate(withDuration: 0.6, delay: 0) {
            self.configureRemindTextLabel()
        }
     
    }
    
    func editController(_ controller: EditController, category: Category) {
        viewAllHomeListView.refeshCollectionView()
    }
    
}
