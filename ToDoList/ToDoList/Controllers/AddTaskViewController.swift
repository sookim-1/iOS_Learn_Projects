//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by sookim on 10/23/23.
//

import UIKit
import SnapKit
import Then

final class AddTaskViewController: UIViewController {

    private let items = ["High", "Medium", "Low"]
    
    lazy private var filterSegmentControl = UISegmentedControl(items: items).then {
        $0.backgroundColor = .systemPink
        $0.selectedSegmentIndex = 0
    }
    
    lazy private var taskTextField = UITextField().then {
        $0.backgroundColor = .systemCyan
        $0.borderStyle = .roundedRect
        $0.placeholder = ""
    }

    lazy private var saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(touchedSaveButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Add Task"
        self.navigationItem.rightBarButtonItem = saveButton
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        self.view.addSubview(filterSegmentControl)
        self.view.addSubview(taskTextField)
    }
    
    private func setupConstraints() {
        filterSegmentControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
        }
        
        taskTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    @objc private func touchedSaveButton() {
        guard let priority = Priority(rawValue: self.filterSegmentControl.selectedSegmentIndex),
              let title = self.taskTextField.text else {
            return
        }
        
        let task = Task(title: title, priority: priority)
    }
    
}
