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
    static func instance() -> NetworkerDefaultViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NetworkerDefaultViewController") as! NetworkerDefaultViewController
    }
}

class NetworkerDefaultViewController: UIViewController {
    
    private lazy var networker: NetworkerLogic = {
        return SwiftlyNetworker(baseURL: "https://raw.githubusercontent.com/jungseungyeo/")
    }()
    
    private var cancelables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        networker.request(SojuAPI.list) { (result: Result<Model, Error>) in
//            switch result {
//            case .success(let model):
//                print("model: \(model)")
//            case .failure(let error):
//                print("error: \(error.localizedDescription)")
//            }
//        }
        
        
        networker.request(SojuAPI.list)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                case .finished:
                    print("finished")
                }
            } receiveValue: { (model: Model) in
                print("1231213")
            }.store(in: &cancelables)

    }
}
