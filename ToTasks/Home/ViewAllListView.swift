//
//  ViewAllListView.swift
//  RednGreen
//
//  Created by Thenny Chhorn on 11/10/22.
//

import UIKit

protocol ViewAllListViewDelegate: AnyObject {
    func viewAllListView(_ wantsToRefreshView: ViewAllListView, indexPath: IndexPath)
    func viewAllListMoreButtonView(_ indexPath: IndexPath)
}
class ViewAllListView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ViewAllListViewDelegate?
    
    var categories = [Category]()
    
    private var deleteIndexpath: IndexPath?
    
    
    private var images = [UIImage.homeImage,
                          UIImage.workImage,
                          UIImage.schoolImage,
                          UIImage.miscellaneousImage,
                          UIImage.reminderImage ]
    
    private var titles = ["Home", "Work", "Study", "Miscellane","Reminders"]
    
    private var colors = [UIColor.orangeColor,
                          UIColor.tealColor,
                          UIColor.blueColor,
                          UIColor.lavenderColor,
                          UIColor.greenColor,
                          UIColor.pinkColor]
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(ViewAllHomeListCell.self,
                                forCellWithReuseIdentifier: ViewAllHomeListCell.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 20,
                                                   left: 20,
                                                   bottom: 90,
                                                   right: 20)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func refeshCollectionView()  {
        
        collectionView.reloadData()
        
    }
    func sortingCategory() -> [Category] {
        
        var localCategory = [Category]()
        localCategory = categories.sorted { cate1, cate2 in
            return cate1.time?.compare(cate2.time!) == .orderedAscending
        }
    
        return localCategory
    
    }
    func deleteCollectionCell(indexPath: IndexPath) {
       
        DataManager.shared.deleteCategory(category: categories[indexPath.row])
        categories.remove(at: indexPath.row)
        collectionView.performBatchUpdates {
            self.collectionView.deleteItems(at: [indexPath])
            self.collectionView.reloadData()
        }
    }

}
// MARK: - UICollectionViewDelegate
extension ViewAllListView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewAllHomeListCell.identifier, for: indexPath) as! ViewAllHomeListCell

        cell.viewModel = AllCategoryViewModel(category: categories[indexPath.row], indexPath: indexPath)
        
        cell.delegate = self
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        delegate?.viewAllListView(self, indexPath: indexPath)
        
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout

extension ViewAllListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = self.frame.width/2 - 30
        return CGSize(width: frame, height: frame)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
// MARK: - AddCategoryVCDelegate
extension ViewAllListView: AddCategoryVCDelegate {
    
    func addCategoryVC(_ controller: AddCategoryVC, category: Category) {
        
        categories.append(category)
        categories = sortingCategory()
        refeshCollectionView()
        
    }
    
}
extension ViewAllListView: ViewAllHomeListCellDelegate {
    func viewAllHomeListCellInfoButton(_ view: ViewAllHomeListCell, indexPath: IndexPath) {
        delegate?.viewAllListMoreButtonView(indexPath)
    }
    
}
