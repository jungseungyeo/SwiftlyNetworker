//
//  SojuCollectionViewCell.swift
//  SwiftlyNetworker_Example
//
//  Created by saeng lin on 2022/03/14.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class SojuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    static let registerID: String = "\(SojuCollectionViewCell.self)"
    
    override func prepareForReuse() {
        imageView.loadCancel()
    }
    
    func configure(_ model: Model.Soju) {
        imageView.loadImage(from: model.image)
        titleLabel.text = model.title
        subTitleLabel.text = model.subTitle
    }
}
