//
//  GoodNewsTableViewCell.swift
//  NewsApp
//
//  Created by sookim on 10/24/23.
//

import UIKit
import SnapKit
import Then

final class GoodNewsTableViewCell: UITableViewCell {

    static let reuseID = String(describing: GoodNewsTableViewCell.self)
    
    lazy private var labelStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel]).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    lazy private var titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 17)
    }
    
    lazy private var descriptionLabel = UILabel().then {
        $0.setContentHuggingPriority(.init(252), for: .vertical)
        $0.numberOfLines = 0
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 14)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubview(labelStackView)
    }
    
    private func setupConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI(article: Article) {
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.description
    }
}
