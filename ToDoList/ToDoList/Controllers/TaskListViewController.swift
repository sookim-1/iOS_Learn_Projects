//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by sookim on 10/23/23.
//

import UIKit
import SnapKit
import Then

final class TaskListViewController: UIViewController {

    private let items = ["All", "High", "Medium", "Low"]
    
    lazy private var filterSegmentControl = UISegmentedControl(items: items).then {
        $0.backgroundColor = .systemPink
        $0.selectedSegmentIndex = 0
    }
    
    lazy private var tableView = UITableView().then {
        $0.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseID)
        $0.dataSource = self
        $0.delegate = self
    }
    
    lazy private var addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(touchedAddButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "GoodList"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = addButton
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        self.view.addSubview(filterSegmentControl)
        self.view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        filterSegmentControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
        }
        
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(filterSegmentControl.snp.bottom).offset(10)
        }
    }
    
    @objc private func touchedAddButton() {
        let vc = UINavigationController(rootViewController: AddTaskViewController())
        
        self.present(vc, animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseID, for: indexPath)
        
        return cell
    }
    
    
}
