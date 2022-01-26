//
//  BackgroundCollectionViewController.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/26.
//

import UIKit
import ProgressHUD

private let reuseIdentifier = "BackgroundCollectionViewCell"

class BackgroundCollectionViewController: UICollectionViewController {

    var backgrounds: [UIImage] = []
    let userDefaults = UserDefaults.standard
    
    private let imageNamesArray = ["bg0", "bg1", "bg2", "bg3", "bg4", "bg5", "bg6", "bg7", "bg8", "bg9", "bg10", "bg11"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.largeTitleDisplayMode = .never
        
        let resetButton = UIBarButtonItem(title: "초기화", style: .plain, target: self, action: #selector(self.resetToDefault))
        self.navigationItem.rightBarButtonItem = resetButton
        
        setupImageArray()
    }

    

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgrounds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BackgroundCollectionViewCell
    
        cell.generateCell(image: backgrounds[indexPath.row])
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        userDefaults.set(imageNamesArray[indexPath.row], forKey: kBACKGROUBNDIMAGE)
        userDefaults.synchronize()
        ProgressHUD.showSuccess("설정 완료")
    }
    
    // MARK: - IBActions
    
    @objc func resetToDefault() {
        userDefaults.removeObject(forKey: kBACKGROUBNDIMAGE)
        userDefaults.synchronize()
        ProgressHUD.showSuccess("초기화 완료")
    }


    // MARK: - Helpers
    
    func setupImageArray() {
        
        for imageName in imageNamesArray {
            let image = UIImage(named: imageName)
            
            if image != nil {
                backgrounds.append(image!)
            }
        }
    }

}
