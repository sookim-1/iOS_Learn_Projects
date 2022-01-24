//
//  UsersTableViewController.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/24.
//

import UIKit
import Firebase
import ProgressHUD

class UsersTableViewController: UITableViewController, UISearchResultsUpdating {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var filterSegmentControl: UISegmentedControl!

    var allUsers: [FUser] = []
    var filterdUsers: [FUser] = []
    
    // 알파벳순으로 정렬하기위한 변수
    var allUsersGroupped = NSDictionary() as! [String : [FUser]]
    var sectionTitleList: [String] = []

    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsers(filter: kCITY)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell

        cell.generateCellWith(fUser: allUsers[indexPath.row], indexPath: indexPath)
        
        return cell
    }

    func loadUsers(filter: String) {
        ProgressHUD.show()
        
        var query: Query!
        
        switch filter {
        case kCITY:
            query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
        case kCOUNTRY:
            query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()!.country).order(by: kFIRSTNAME, descending: false)
        default:
            query = reference(.User).order(by: kFIRSTNAME, descending: false)
        }
        
        // 세그먼트컨트롤 값에따라 보여지는 사용자만 배열로 가집니다.
        query.getDocuments { snapshot, error in
            
            self.allUsers = []
            self.sectionTitleList = []
            self.allUsersGroupped = [:]
            
            if error != nil {
                print(error!.localizedDescription)
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                return
            }
            
            guard let snapshot = snapshot else {
                ProgressHUD.dismiss()
                return
            }
            
            if !snapshot.isEmpty {
                for userDictionary in snapshot.documents {
                    let userDictionary = userDictionary.data() as NSDictionary
                    let fUser = FUser(_dictionary: userDictionary)
                    
                    // 현재 사용자를 제외한 사용자만 테이블뷰에 표시
                    if fUser.objectId != FUser.currentId() {
                        self.allUsers.append(fUser)
                    }
                }
                
                //
            }
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    // MARK: - IBActions
    @IBAction func filterSegmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadUsers(filter: kCITY)
        case 1:
            loadUsers(filter: kCOUNTRY)
        case 2:
            loadUsers(filter: "")
        default:
            return
        }
    }
    
    
    // MARK: - Search Controller Func
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filterdUsers = allUsers.filter({ user -> Bool in
            return user.firstname.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}
