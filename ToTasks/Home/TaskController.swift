//
//  AddCategoryController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/18/22.
//

import UIKit
import UserNotifications

protocol TaskControllerDelegate: AnyObject {
    func taskController(_ controller: TaskController, indexPath: IndexPath)
    func taskController(modifyIndexPath indexPath: IndexPath)
}
class TaskController: UIViewController {

    // MARK: - Properties
    
    var items = [Item]()

    var viewModel: AllCategoryViewModel
  
    init(viewModel: AllCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isUpdated = false
    private var saveIndex: Int?
    
    private let taskView = UIView()
    
    weak var delegate: TaskControllerDelegate?
    private let colorsView = ColorsView()
    
    private lazy var navigationView = AddTaskNavigationView(title: viewModel.categoryName,
                                                leftButtonImage: .backImage,
                                                rightButtonImage: .addImage, rightButtonColor: .white)
    
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .dateFont
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.trashImage, for: .normal)
        button.setDemensions(height: 45, width: 45)
        button.backgroundColor = .barDeselectedColor
        button.tintColor = .black
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(handleDeleteButton),
                         for: .touchUpInside)
        //button.isHidden = true
        return button
    }()
    private lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.downloadImage, for: .normal)
        button.setDemensions(height: 45, width: 45)
        button.backgroundColor = .barDeselectedColor
        button.tintColor = .black
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(handleDownloadTask),
                         for: .touchUpInside)
        //button.isHidden = true
        return button
    }()
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.textEditImage, for: .normal)
        button.setDemensions(height: 45, width: 45)
        button.backgroundColor = .barDeselectedColor
        button.tintColor = .black
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(handleEditCategoryButton),
                         for: .touchUpInside)
        //button.isHidden = true
        return button
    }()
   
    private let premiumImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = .crownFillImage
        iv.setDemensions(height: 30, width: 30)
       // iv.tintColor = .yellowColor
        return iv
    }()
    
    private lazy var tableView: UITableView = {
        
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .clear
        table.keyboardDismissMode = .onDrag
        table.showsVerticalScrollIndicator = false
        table.register(AddItemTableCell.self,
                       forCellReuseIdentifier: AddItemTableCell.identifier)
        return table
    }()
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configureUI()
      
        fetchItemsFromDatabase()
        configureBackGroundColor()
        
        premiumImage.tintColor = viewModel.royaltyColor
        navigationView.viewModel = viewModel
        
        configurePurchase()
        
        print(viewModel.backGroundColor)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Helpers
    func configureBackGroundColor() {
        
        view.backgroundColor  = viewModel.backGroundColor
        taskView.backgroundColor = viewModel.backGroundColor
        navigationView.backgroundColor = viewModel.backGroundColor
        
    }
    func configureUI() {
        
        navigationView.delegate = self
       
        view.backgroundColor = .white

        view.addSubview(navigationView)
        navigationView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor, height: 111)

        tableView.separatorStyle = .none
        
        let time = Date().dateInString(date: viewModel.time )
        dateLabel.text = time
   
        view.addSubview(taskView)
        
        taskView.anchor(top: navigationView.bottomAnchor,
                        left: view.leftAnchor,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor,
                        right: view.rightAnchor,
                        paddingTop: 1,
                        paddingLeft: 20,
                        paddingBottom: 45,
                        paddingRight: 20)
        
        taskView.addSubview(dateLabel)
        dateLabel.centerX(inView: taskView,
                          topAnchor: taskView.topAnchor)
        
        taskView.addSubview(tableView)
        tableView.anchor(top: dateLabel.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: taskView.bottomAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 20,
                         paddingRight: 20)
        
        view.addSubview(deleteButton)
        deleteButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingRight: 20)
        
        view.addSubview(downloadButton)
        downloadButton.anchor(left: view.leftAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              paddingLeft: 20)
        
        view.addSubview(premiumImage)
        premiumImage.anchor(bottom: downloadButton.topAnchor,
                            right: downloadButton.rightAnchor,
                            paddingBottom: -20,
                            paddingRight: -12)
        
        view.addSubview(editButton)
        editButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          right: deleteButton.leftAnchor,
                          paddingRight: 20)
        

    }
 
    func sortingArray() -> [Item] {
        items = items.sorted { item1, item2 in
            return item1.time?.compare(item2.time!) == .orderedDescending
        }
        return items
    }
    func fetchItemsFromDatabase() {
        items = DataManager.shared.fetchItems(category: viewModel.category)
        items = sortingArray()
        tableView.reloadData()
        
    }
    func editItem(text: String, category: Category) {
        let item = DataManager.shared.updateItem(text: text, category: category)
        items.append(item)
        tableView.reloadData()
        
    }
    func updateItem(index: Int, item: Item) {
        
        DataManager.shared.deleteItem(item: item)
        items.remove(at: index)
        self.tableView.reloadData()
        
    }
    func alertDeleteCategory() {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this category?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            
            self.delegate?.taskController(self, indexPath: self.viewModel.indexPath!)
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        present(alert, animated: true)
        
    }
  
    // MARK: - Selectors
    @objc func handleDeleteButton() {
        
        alertDeleteCategory()
        
    }
    @objc func handleDownloadTask() {
        
        let render = UIGraphicsImageRenderer(size: taskView.bounds.size)
        let image = render.image { _ in
            taskView.drawHierarchy(in: taskView.bounds, afterScreenUpdates: true)
            
        }
        
        if isPurchased() {
            let vc = DownloadTaskController()
            vc.image.image = image
            vc.category = viewModel.category
            vc.taskView.backgroundColor = view.backgroundColor
            present(vc, animated: true)
        }else {
            alertPurchasePremium()
        }
        
    }
    fileprivate func configurePurchase() {
        if isPurchased() {
            premiumImage.isHidden = true
        }else {
            premiumImage.isHidden = false
        }
    }
    @objc func handleEditCategoryButton() {
        
        let vc = CategorySettingController()
        vc.category = viewModel.category
        vc.delegate = self 
        
        present(vc, animated: true)
        
    }

    
}

// MARK: - AddTaskNavigationViewDelegate

extension TaskController: AddTaskNavigationViewDelegate {
   
    func addTaskNavigationView(_ setReminderButton: UIButton) {
        let vc = SetReminderController()
        vc.cateogry = viewModel.category
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
   
    func addTaskNavigationView(_ view: AddTaskNavigationView, rightButton: UIButton) {

        let vc = AddNewTaskController()
        vc.viewModel = viewModel
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext 
        present(vc, animated: true)
        
    }
    
    func addTaskNavigationView(_ view: AddTaskNavigationView, leftButton: UIButton) {
        
        navigationController?.popViewController(animated: true)

    }
    
}

// MARK: - UITableViewDelegate

extension TaskController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTableCell.identifier,for: indexPath) as! AddItemTableCell
        cell.selectionStyle = .none
        cell.item = items[indexPath.row]
        cell.index = indexPath 
        cell.delegate = self
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        let estimateSizeCell = AddItemTableCell(frame: CGRect(x: 0, y: 0,
                                                       width: tableView.frame.width,
                                                       height: 61))
        
        let targetSize = CGSize(width: view.frame.width, height: 700)
        _ = estimateSizeCell.systemLayoutSizeFitting(targetSize)
        estimateSizeCell.contentView.layoutIfNeeded()
        
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isUpdated = true
        saveIndex = indexPath.row
        
        
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        saveIndex = indexPath.row
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
           
            self.updateItem(index: indexPath.row, item: self.items[indexPath.row])
            completion(true)
            
        }
   
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
}
// MARK: - AddNewTaskControllerDelegate

extension TaskController: AddNewTaskControllerDelegate {
    
    func addNewTaskControllerDelegate(_ controller: AddNewTaskController, text: String) {
        
        let item = DataManager.shared.addItem(text, category: viewModel.category)
        items.append(item)
        items = sortingArray()
        tableView.reloadData()
        controller.dismiss(animated: true)
    }
    
    func addNewTaskControllerDelegate(_ controller: AddNewTaskController, item: Item) {
        
        items.append(item)
        items = sortingArray()
        tableView.reloadData()
        controller.dismiss(animated: true)
        
    }
    
}
// MARK: - ItemTableCellDelegate
extension TaskController: ItemTableCellDelegate {
   
    func itemTableCell(_ cell: AddItemTableCell, indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        item.setValue(item.done, forKey: "done")
        DataManager.shared.saveContext()
    }

}
// MARK: - SetReminderControllerDelegate

extension TaskController: SetReminderControllerDelegate {
    
    func setReminderController(_ controller: SetReminderController, selectedTime: Date) {
        
        delegate?.taskController(modifyIndexPath: viewModel.indexPath!)
        DataManager.shared.saveAlert(category: viewModel.category, selectedTime: selectedTime)
 
    }
    
}
// MARK: - CategorySettingControllerDelegate
extension TaskController: CategorySettingControllerDelegate {
  
    func categorySettingController(_ controllerWantsToUpdate: CategorySettingController, category: Category) {
        
        delegate?.taskController(modifyIndexPath: viewModel.indexPath!)
        viewModel.category = category
        configureBackGroundColor()
        self.tableView.reloadData()
        
    }

}
