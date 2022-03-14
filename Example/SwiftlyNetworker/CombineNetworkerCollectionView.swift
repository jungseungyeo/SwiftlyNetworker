//
//  CombineNetworkerCollectionView.swift
//  SwiftlyNetworker_Example
//
//  Created by saeng lin on 2022/03/14.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import SwiftlyNetworker
import Combine

extension CombineNetworkerCollectionView {
    static func instance(_ networkerLogic: NetworkerLogic) -> CombineNetworkerCollectionView {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CombineNetworkerCollectionView") as! CombineNetworkerCollectionView
        
        
        viewController.networker = networkerLogic
        
        return viewController
    }
}

class CombineNetworkerCollectionView: UIViewController {
    
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
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        networker.request(SojuAPI.list)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] (model: Model) in
                guard let self = self else { return }
                self.model = model
                self.collectionView.reloadData()
            }.store(in: &cancellables)

    }
}

extension CombineNetworkerCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: collectionView.frame.size.width, height: 130)
    }
}

extension CombineNetworkerCollectionView: UICollectionViewDataSource {
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
