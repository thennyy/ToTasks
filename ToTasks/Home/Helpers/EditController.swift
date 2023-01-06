//
//  EditController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/10/22.
//

import UIKit

protocol EditControllerDelegate: AnyObject {
    func editController(_ controller: EditController, category: Category)
    func editController(_ controllerWantsToDelete: EditController, indexPath: IndexPath)
}
class EditController: UIViewController  {

    
    weak var delegate: EditControllerDelegate?

    private var viewModel: AllCategoryViewModel
    
    init(viewModel: AllCategoryViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var deleteButton = EditButton(title: "Delete",
                                               titleColor: .red,
                                               image: .trashImage! )
    
    private lazy var editButton = EditButton(title: "Edit Category",
                                             titleColor: .label,
                                             image: .editImage!)
    
    private lazy var cancelButton = EditButton(title: "Cancel",
                                          titleColor: .label)
    
//    private lazy var pinButton = EditButton(title: "Pin Category",
//                                            titleColor: .label, image: .pinFillImage!)
    
    private lazy var stackVeiw = UIStackView(arrangedSubviews: [editButton,
                                                                deleteButton,
                                                                cancelButton]).withAttributes(axis: .vertical, spacing: 6, distribution: .fillEqually)
    
    private let backGroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isOpaque = true
        
        backGroundView.backgroundColor = viewModel.backGroundColor
        backGroundView.layer.cornerRadius = 9
        backGroundView.setDemensions(height: 200,
                                     width: view.frame.width - 30)
        
        view.addSubview(backGroundView)
        backGroundView.centerX(inView: view,
                               bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor)
                              // paddingBottom: 15)
        
        backGroundView.addSubview(stackVeiw)
        stackVeiw.anchor(top: backGroundView.topAnchor,
                         left: backGroundView.leftAnchor,
                         bottom: backGroundView.bottomAnchor,
                         right: backGroundView.rightAnchor,
                         paddingTop: 6,
                         paddingLeft: 6,
                         paddingBottom: 6,
                         paddingRight: 6)
        
        
        cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)

    }
    
    @objc func handleCancelButton() {
        dismiss(animated: true)
    }
    @objc func handleEditButton() {
        
        let vc = CategorySettingController()
        vc.category = viewModel.category
        vc.delegate = self
        present(vc, animated: true)
        
    }
  
    @objc func handleDeleteButton() {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this category?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            guard let indexPath = self.viewModel.indexPath else {return}
            self.delegate?.editController(self, indexPath: indexPath)
       
           // self.navigationController?.popViewController(animated: true)
            
        }))
        
        present(alert, animated: true)
    }
}
// MARK: - CategorySettingControllerDelegate

extension EditController: CategorySettingControllerDelegate {
    func categorySettingController(_ controllerWantsToUpdate: CategorySettingController, category: Category) {
      
        delegate?.editController(self, category: category)
        self.dismiss(animated: true)
    }
}
