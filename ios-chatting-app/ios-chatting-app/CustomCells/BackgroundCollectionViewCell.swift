//
//  BackgroundCollectionViewCell.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/26.
//

import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(image: UIImage) {
        self.imageView.image = image
    }
    
}
