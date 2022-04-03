//
//  GFButton.swift
//  ios-Github-Followers-Clone
//
//  Created by sookim on 2021/10/22.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title
         : String) {
        self.init(frame: .zero)
        set(backgroundColor: backgroundColor, title: title)
    }
    
    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
//        layer.cornerRadius = 10
//        setTitleColor(.white, for: .normal)
//        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    func set(backgroundColor: UIColor, title: String, systemImageName: String? = nil) {
        configuration?.baseBackgroundColor = backgroundColor
        configuration?.baseForegroundColor = backgroundColor
        configuration?.title = title
        
        if let systemImageName = systemImageName {
            configuration?.image = UIImage(systemName: systemImageName)
            configuration?.imagePadding = 6
            configuration?.imagePlacement = .leading
        }
//        self.backgroundColor = backgroundColor
//        setTitle(title, for: .normal)
    }
    
}
