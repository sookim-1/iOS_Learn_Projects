//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by sookim on 10/23/23.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {

    static let reuseID = String(describing: TaskTableViewCell.self)
    
    lazy private var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubviews() {
        self.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func configureUI(text: String) {
        self.titleLabel.text = text
    }
}
