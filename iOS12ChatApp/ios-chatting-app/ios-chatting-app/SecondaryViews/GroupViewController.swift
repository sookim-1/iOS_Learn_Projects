//
//  GroupViewController.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/26.
//

import UIKit
import ProgressHUD
//import ImagePicker

class GroupViewController: UIViewController {
    
    @IBOutlet var iconTapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var cameraButtonOutlet: UIImageView!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var groupNameTextField: UITextField!
    
    var group: NSDictionary!
    var groupIcon: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButtonOutlet.isUserInteractionEnabled = true
        cameraButtonOutlet.addGestureRecognizer(iconTapGesture)
        
        setupUI()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "초대하기", style: .plain, target: self, action: #selector(self.inviteUsers))]
        
    }
    
    // MARK: - IBActions
    
    @IBAction func editButtonPressed(_ sender: Any) {
        showIconOptions()
    }
    
    @IBAction func cameraIconTapped(_ sender: Any) {
        showIconOptions()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        var withValues : [String : Any]!
        
        if groupNameTextField.text != "" {
            withValues = [kNAME : groupNameTextField.text!]
        } else {
            ProgressHUD.showError("대화명을 입력하세요")
            return
        }
        
        let avatarData = cameraButtonOutlet.image?.jpegData(compressionQuality: 0.4)!
        let avatarString = avatarData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        withValues = [kNAME : groupNameTextField.text!, kAVATAR : avatarString!]
        
        Group.updateGroup(groupId: group[kGROUPID] as! String, withValues: withValues)
        
        withValues = [kWITHUSERFULLNAME : groupNameTextField.text!, kAVATAR : avatarString]
        
        updateExistingRicentWithNewValues(chatRoomId: group[kGROUPID] as! String, members: group[kMEMBERS] as! [String], withValues: withValues)
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc func inviteUsers() {
        
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inviteUsersTableView") as! InviteUsersTableViewController
        
        userVC.group = group
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    
    // MARK: - Helpers
    
    func setupUI() {
        self.title = "그룹"
        
        groupNameTextField.text = group[kNAME] as? String
        
        imageFromData(pictureData: group[kAVATAR] as! String) { (avatarImage) in
            
            if avatarImage != nil {
                self.cameraButtonOutlet.image = avatarImage!.circleMasked
            }
        }
   }
    
    func showIconOptions() {
        
        let optionMenu = UIAlertController(title: "그룹 아이콘을 선택하세요", message: nil, preferredStyle: .actionSheet)
        
        let takePhotoActio = UIAlertAction(title: "사진선택", style: .default) { (alert) in
            print("takePhotoAction")
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (alert) in
            
        }
        
        if groupIcon != nil {
            
            let resetAction = UIAlertAction(title: "초기화", style: .default) { (alert) in
                
                self.groupIcon = nil
                self.cameraButtonOutlet.image = UIImage(named: "cameraIcon")
                self.editButtonOutlet.isHidden = true
            }
            optionMenu.addAction(resetAction)
        }
        
        optionMenu.addAction(takePhotoActio)
        optionMenu.addAction(cancelAction)
        
        // iPad 대응
        if ( UI_USER_INTERFACE_IDIOM() == .pad )
        {
            if let currentPopoverpresentioncontroller = optionMenu.popoverPresentationController{
                
                currentPopoverpresentioncontroller.sourceView = editButtonOutlet
                currentPopoverpresentioncontroller.sourceRect = editButtonOutlet.bounds
                
                
                currentPopoverpresentioncontroller.permittedArrowDirections = .up
                self.present(optionMenu, animated: true, completion: nil)
            }
        } else {
            self.present(optionMenu, animated: true, completion: nil)
        }
        
    }
    
}

//extension GroupViewController: ImagePickerDelegate {
//    // MARK: - ImagePickerDelegate
//
//    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//
//        if images.count > 0 {
//            self.groupIcon = images.first!
//            self.cameraButtonOutlet.image = self.groupIcon?.circleMasked
//            self.editButtonOutlet.isHidden = false
//        }
//
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//}
