//
//  SettingsTableViewController.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/24.
//

import UIKit
import ProgressHUD

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    @IBOutlet weak var showAvatarStatusSwitch: UISwitch!
    @IBOutlet weak var versionLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    var avatarSwitchStatus = false
    var firstLoad: Bool?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FUser.currentUser() != nil {
            setupUI()
            loadUserDefaults()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 5
        }
        
        return 2
    }

    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        
        return 30
    }
    
    // MARK: - IBActions
    @IBAction func logOutButtonPressed(_ sender: Any) {
        FUser.logOutCurrentUser { success in
            if success {
                self.showLoginView()
            }
        }
    }
    
    @IBAction func showAvatarSwitchValueChanged(_ sender: UISwitch) {
        avatarSwitchStatus = sender.isOn
        
        saveUserDefaults()
    }
    
    @IBAction func cleanCacheButtonPressed(_ sender: Any) {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentsURL().path)
            
            for file in files {
                try FileManager.default.removeItem(atPath: "\(getDocumentsURL().path)/\(file)")
            }

            ProgressHUD.showSuccess("캐시 정리완료")
        } catch {
            ProgressHUD.showError("캐시를 정리할 수 없습니다.")
        }
    }
    
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        let text = "ios-chatting-app으로 초대합니다. \(kAPPURL)"
        
        let objectsToShare:[Any] = [text]
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        // iPad 대응
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.setValue("ios-chatting-app으로 초대합니다.", forKey: "subject")

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
        let optionMenu = UIAlertController(title: "계정 삭제하기", message: "정말 삭제하시겠습니까?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (alert) in
            
            self.deleteUser()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (alert) in
            
        }
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        //for iPad not to crash - iPad대응
        if ( UI_USER_INTERFACE_IDIOM() == .pad )
        {
            if let currentPopoverpresentioncontroller = optionMenu.popoverPresentationController{
                
                currentPopoverpresentioncontroller.sourceView = deleteButtonOutlet
                currentPopoverpresentioncontroller.sourceRect = deleteButtonOutlet.bounds
                
                currentPopoverpresentioncontroller.permittedArrowDirections = .up
                self.present(optionMenu, animated: true, completion: nil)
            }
        }else{
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    
    
    func showLoginView() {
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
        
        self.present(mainView, animated: true, completion: nil)
    }
    
    // MARK: - SetupUI
    func setupUI() {
        
        let currentUser = FUser.currentUser()!
        
        fullNameLabel.text = currentUser.fullname
        
        if currentUser.avatar != "" {
            
            imageFromData(pictureData: currentUser.avatar) { (avatarImage) in
                
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }
    
        // 번들 짧은 문자열 가져오는 키 - CFBundleShortVersionString
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = version
        }
    }
    
    // MARK: - Delete user
    
    func deleteUser() {
        
        //delet locally
        userDefaults.removeObject(forKey: kPUSHID)
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        //delete from firebase - DB와 FirebaseAuth에서 모두 삭제
        reference(.User).document(FUser.currentId()).delete()
        
        FUser.deleteUser { (error) in
            
            if error != nil {
                
                DispatchQueue.main.async {
                    ProgressHUD.showError("삭제할 수 없습니다.")
                }
                return
            }
            
            self.showLoginView()
        }
        
    }
    
    // MARK: - UserDefaults
    
    func saveUserDefaults() {
        
        userDefaults.set(avatarSwitchStatus, forKey: kSHOWAVATAR)
        userDefaults.synchronize()
    }
    
    func loadUserDefaults() {
        
        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstLoad! {
            userDefaults.set(true, forKey: kFIRSTRUN)
            userDefaults.set(avatarSwitchStatus, forKey: kSHOWAVATAR)
            userDefaults.synchronize()
        }
        
        avatarSwitchStatus = userDefaults.bool(forKey: kSHOWAVATAR)
        showAvatarStatusSwitch.isOn = avatarSwitchStatus
    }

}
