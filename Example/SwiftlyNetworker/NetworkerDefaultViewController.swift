//
//  NetworkerDefaultViewController.swift
//  SwiftlyNetworker_Example
//
//  Created by saeng lin on 2022/03/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import SwiftlyNetworker
import Combine

extension NetworkerDefaultViewController {
    static func instance(_ networkerLogic: NetworkerLogic) -> NetworkerDefaultViewController {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NetworkerDefaultViewController") as! NetworkerDefaultViewController
        
        viewController.networker = networkerLogic
        
        return viewController
    }
}

class NetworkerDefaultViewController: UIViewController {
    
    private var networker: NetworkerLogic!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(UINib(nibName: "SojuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SojuCollectionViewCell.registerID)
        
        return collectionView
    }()
    
    private var model: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        networker.request(SojuAPI.list) { [weak self] (result: Result<Model, Error>) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.model = model
                    self?.collectionView.reloadData()
                }
                
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
}

extension NetworkerDefaultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: collectionView.frame.size.width, height: 130)
    }
}

extension NetworkerDefaultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.sojus?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SojuCollectionViewCell.registerID, for: indexPath) as? SojuCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = model?.sojus?[indexPath.row] else { return cell }
        
        cell.configure(model)
        
        return cell
    }
    
}
