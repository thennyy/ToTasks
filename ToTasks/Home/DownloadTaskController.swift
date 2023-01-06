//
//  DownloadTaskController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/1/22.
//

import UIKit
import Photos

class DownloadTaskController: UIViewController {
    
    var category: Category! {
        didSet {
          
            titleLabel.text = category.name
            dateLabel.text = Date().dateInString(date: category.time ?? Date())
            print("DEBUG: DATE IS ", Date().dateInString(date: category.time ?? Date()))
                  
        }
    }
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBold
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .dateFont 
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    var image = UIImageView()
    
    let taskView = UIView()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.xmarkImage, for: .normal)
        button.tintColor = .darkGray
        button.setDemensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleCancelButton),
                         for: .touchUpInside)
        
        return button
    }()
    private lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.downloadImage, for: .normal)
        button.setDemensions(height: 45, width: view.frame.width - 200)
        button.setTitle("  Save in photo", for: .normal)
        button.titleLabel?.font = .smallMedium
       // button.backgroundColor = .orangeColor
        button.tintColor = .label
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleDownloadTask),
                         for: .touchUpInside)
        //button.isHidden = true
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

      
    }
    
    func configureUI() {
        
        view.backgroundColor = .systemGroupedBackground
        image.contentMode = .scaleAspectFit
        
        view.addSubview(downloadButton)
        downloadButton.centerX(inView: view,
                               bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor,
                               paddingBottom: 12)
        
        view.addSubview(taskView)
        taskView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        left: view.leftAnchor,
                        bottom: downloadButton.topAnchor,
                        right: view.rightAnchor,
                        paddingTop: 60,
                        paddingLeft: 20,
                        paddingBottom: 20,
                        paddingRight: 20)
        
        taskView.addSubview(titleLabel)
        titleLabel.centerX(inView: taskView,
                           topAnchor: taskView.topAnchor,
                           paddingTop: 20)
        
        taskView.addSubview(image)
        image.anchor(top: titleLabel.bottomAnchor,
                     left: taskView.leftAnchor,
                     bottom: taskView.bottomAnchor,
                     right: taskView.rightAnchor,
                     paddingTop: 9,
                     paddingBottom: 0)
        
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.leftAnchor,
                            paddingTop: 9,
                            paddingLeft: 9)
        
    }
    @objc func handleDownloadTask() {
        
        let render = UIGraphicsImageRenderer(size: taskView.bounds.size)
        let img = render.image { _ in
            taskView.drawHierarchy(in: taskView.bounds, afterScreenUpdates: true)
            
        }
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            self.checkAuthorizationStatus(image: img, status: status)
        }
        
        downloadButton.setTitle("Saved", for: .normal)
        downloadButton.layer.borderColor = UIColor.lightGray.cgColor
        downloadButton.setImage(nil, for: .normal)
        downloadButton.isEnabled = false
        
        Service.showProgress()
        
    }
    
    @objc func handleCancelButton() {
        dismiss(animated: true)
    }
    
    func checkAuthorizationStatus(image: UIImage, status: PHAuthorizationStatus) {
      //  let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            print("Give not determined")
        case .restricted:
            print("Give restricted")
        case .denied:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                      options: [:]) { _ in
                print("DEBUG: GIVING PERMISSION")
            }
            
            print("Give denied")
        case .authorized:
            print("Give autorized")
            Service.downloadImage(image: image)

        case .limited:
            print("Give limited")
        @unknown default:
            print("DEFAULT")
        }
    }
    func alertToGivePhotoLibraryPermission() {
        let alert = UIAlertController(title: "Access Photo Library", message: "Set permission to allow ToTasks save this Image to your library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add Permission", style: .destructive, handler: { _ in
            
            
        }))
        present(alert, animated: true)
    }
}
