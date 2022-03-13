//
//  ViewController.swift
//  SwiftlyNetworker
//
//  Created by linsaeng on 03/12/2022.
//  Copyright (c) 2022 linsaeng. All rights reserved.
//

import UIKit
import SwiftlyNetworker

class ViewController: UIViewController {
    
    private let values: [String] = [
        "SwiftlyNetworker - Default"
    ]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(DefaultCollectionCell.self, forCellWithReuseIdentifier: DefaultCollectionCell.registerID)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SwiftlyNetworker"
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout  {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.row {
        case 0:            
            self.navigationController?.pushViewController(NetworkerDefaultViewController.instance(), animated: true)
        default: print()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return values.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionCell.registerID,
                                                            for: indexPath) as? DefaultCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(title: values[indexPath.row])
        
        return cell
    }
}
