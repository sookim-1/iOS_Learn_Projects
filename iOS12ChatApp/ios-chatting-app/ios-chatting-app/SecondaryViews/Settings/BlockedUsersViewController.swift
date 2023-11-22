//
//  BlockedUsersViewController.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/26.
//

import UIKit
import ProgressHUD

class BlockedUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var blockedUsersArray : [FUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        loadUsers()
    }
    
    // MARK: - TableViewData Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return blockedUsersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        cell.delegate = self
        cell.generateCellWith(fUser: blockedUsersArray[indexPath.row], indexPath: indexPath)
        
        return cell
    }
    
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "차단해제"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        var tempBlockedUsers = FUser.currentUser()!.blockedUsers
        
        let userIdToUnblock = blockedUsersArray[indexPath.row].objectId
        
        tempBlockedUsers.remove(at: tempBlockedUsers.index(of: userIdToUnblock)!)
        
        blockedUsersArray.remove(at: indexPath.row)
        
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID : tempBlockedUsers]) { (error) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - LoadBlocked Users
    
    func loadUsers() {
        
        if FUser.currentUser()!.blockedUsers.count > 0 {
            
            ProgressHUD.show()
            
            getUsersFromFirestore(withIds: FUser.currentUser()!.blockedUsers) { (allBlockedUsers) in
                
                ProgressHUD.dismiss()
                
                self.blockedUsersArray = allBlockedUsers
                self.tableView.reloadData()
            }
        }
    }

    
    // MARK: - UserTableviewCellDelegate
    func didTapAvatarImage(indexPath: IndexPath) {
        
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as! ProfileViewTableViewController
        
        profileVC.user = blockedUsersArray[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
