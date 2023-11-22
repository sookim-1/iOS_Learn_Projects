//
//  NewsTableViewCell.swift
//  NewsAppMVVM
//
//  Created by sookim on 10/30/23.
//

import UIKit
import SnapKit
import Then

final class NewsTableViewCell: UITableViewCell {

    static let reuseID = String(describing: NewsTableViewCell.self)
    
    lazy private var textStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel]).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.setContentHuggingPriority(.init(250), for: .vertical)
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = UIColor.darkGray
        $0.numberOfLines = 0
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
        self.addSubview(textStackView)
    }
    
    private func setupConstraints() {
        textStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
