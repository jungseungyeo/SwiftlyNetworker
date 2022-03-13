//
//  DefaultCollectionCell.swift
//  SwiftlyNetworker_Example
//
//  Created by saeng lin on 2022/03/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class DefaultCollectionCell: UICollectionViewCell {
    
    static let registerID: String = "\(DefaultCollectionCell.self)"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
}
