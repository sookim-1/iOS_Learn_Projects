//
//  UserTableViewCell.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!

    var indexPath: IndexPath!
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tapGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func generateCellWith(fUser: FUser, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        self.fullNameLabel.text = fUser.fullname
        
        // Firebase에서는 이미지를 String으로 저장되어 있습니다.
        if fUser.avatar != "" {
            imageFromData(pictureData: fUser.avatar) { avatarImage in
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
    }
    
    @objc func avatarTap() {
        print("avatar tap at \(indexPath)")
    }
}
