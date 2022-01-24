//
//  UsersTableViewController.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/24.
//

import UIKit
import Firebase
import ProgressHUD

class UsersTableViewController: UITableViewController, UISearchResultsUpdating, UserTableViewCellDelegate {

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

        self.title = "사용자 목록"
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView() // 비어있는 셀 안보이도록 표시
        
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        loadUsers(filter: kCITY)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        } else {
            return allUsersGroupped.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterdUsers.count
        } else {
            
            // find section Title(섹션 알파벳순으로)
            let sectionTitle = self.sectionTitleList[section]
            
            // user for given title (섹션별 알맞는 사용자목록)
            let users = self.allUsersGroupped[sectionTitle]
            
            return users!.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        var user: FUser
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filterdUsers[indexPath.row]
        } else {
            let sectionTitle = self.sectionTitleList[indexPath.section]
            
            let users = self.allUsersGroupped[sectionTitle]
            
            user = users![indexPath.row]
        }
        
        cell.generateCellWith(fUser: user, indexPath: indexPath)
        cell.delegate = self
                
        return cell
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return ""
        } else {
            return sectionTitleList[section]
        }
    }
    
    // 테이블뷰 옆에 섹션타이틀을 스크롤 부분에 표시
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return nil
        } else {
            return self.sectionTitleList
        }
    }
    
    // 섹션인덱스 클릭하면 해당 섹션으로 이동
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var user: FUser
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filterdUsers[indexPath.row]
        } else {
            let sectionTitle = self.sectionTitleList[indexPath.section]
            
            let users = self.allUsersGroupped[sectionTitle]
            
            user = users![indexPath.row]
        }
        
        startPrivateChat(user1: FUser.currentUser()!, user2: user)
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
                
                self.splitDataIntoSection()
                self.tableView.reloadData()
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
 
    // MARK: - Helper functions
    fileprivate func splitDataIntoSection() {
        var sectionTitle: String = ""
        
        for i in 0..<self.allUsers.count {
            let currentUser = self.allUsers[i]
            
            let firstChar = currentUser.firstname.first!
            
            let firstCharString = "\(firstChar)"
            
            if firstCharString != sectionTitle {
                sectionTitle = firstCharString
                
                self.allUsersGroupped[sectionTitle] = []
                self.sectionTitleList.append(sectionTitle)
                
            }
            self.allUsersGroupped[firstCharString]?.append(currentUser)
        }
    }
    
    // MARK: - UserTableViewCellDelegate
    func didTapAvatarImage(indexPath: IndexPath) {
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as! ProfileViewTableViewController
        
        var user: FUser
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filterdUsers[indexPath.row]
        } else {
            let sectionTitle = self.sectionTitleList[indexPath.section]
            
            let users = self.allUsersGroupped[sectionTitle]
            
            user = users![indexPath.row]
        }
        
        profileVC.user = user
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
