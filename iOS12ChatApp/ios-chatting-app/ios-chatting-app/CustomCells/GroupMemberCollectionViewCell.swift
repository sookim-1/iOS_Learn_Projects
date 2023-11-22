//
//  GroupMemberCollectionViewCell.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/26.
//

import UIKit

class GroupMemberCollectionViewCell: UICollectionViewCell {
    
    var indexPath: IndexPath!
    var delegate: GroupMemberCollectionViewCellDelegate?
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func generateCell(user: FUser, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        nameLabel.text = user.firstname
        
        if user.avatar != "" {
            
            imageFromData(pictureData: user.avatar) { (avatarImage) in
                
                if avatarImage != nil {
                    
                    self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }
        
        
        
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate!.didClickDeleteButton(indexPath: indexPath)
    }
    
    
}
