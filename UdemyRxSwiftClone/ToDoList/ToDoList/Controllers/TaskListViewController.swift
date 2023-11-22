//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by sookim on 10/23/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class TaskListViewController: UIViewController {

    private let items = ["All", "High", "Medium", "Low"]
    
    lazy private var filterSegmentControl = UISegmentedControl(items: items).then {
        $0.addTarget(self, action: #selector(priorityValueChanged), for: .valueChanged)
        $0.backgroundColor = .systemPink
        $0.selectedSegmentIndex = 0
    }
    
    lazy private var tableView = UITableView().then {
        $0.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseID)
        $0.dataSource = self
        $0.delegate = self
    }
    
    lazy private var addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(touchedAddButton))
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]() {
        didSet {
            self.updateTableView()
        }
    }
    
    private let disposeBag = DisposeBag()
    
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
        let vc = AddTaskViewController()
        
        vc.taskSubjectObservable
            .subscribe { [unowned self] task in
            print("저장된 값 : \(task)")
            let priority = Priority(rawValue: self.filterSegmentControl.selectedSegmentIndex - 1)
                
            var existingTasks = self.tasks.value
            existingTasks.append(task)
            
            self.tasks.accept(existingTasks)
            self.filterTasks(by: priority)
        }.disposed(by: disposeBag)
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true)
    }
    
    private func filterTasks(by priority: Priority?) {
        // nil이 전체옵션과 동일
        if priority == nil {
            print("filter Task : \(self.tasks.value)")
            self.filteredTasks = self.tasks.value
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe { [weak self] tasks in
                guard let self
                else { return }
                
                print("filter Task : \(tasks)")
                self.filteredTasks = tasks
            }.disposed(by: disposeBag)
        }
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func priorityValueChanged() {
        let priority = Priority(rawValue: self.filterSegmentControl.selectedSegmentIndex - 1)
        
        filterTasks(by: priority)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseID, for: indexPath) as! TaskTableViewCell
        
        cell.configureUI(text: self.filteredTasks[indexPath.row].title)
        
        return cell
    }
    
}
