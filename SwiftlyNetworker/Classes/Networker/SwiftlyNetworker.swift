//
//  SwiftlyNetworker.swift
//  SwiftlyNetworker
//
//  Created by saeng lin on 2022/03/12.
//

import Foundation

// MARK: - SwiftlyNetworker
public class SwiftlyNetworker: NetworkerLogic {
    
    public var component: NetworkerLogicDependency
    
    public struct Component: NetworkerLogicDependency {
        public var baseURL: String
        public var header: [String : String]
        public var requester: Requester
    }

    public required init(componet: NetworkerLogicDependency) {
        self.component = componet
    }
    
    public convenience init(baseURL: String) {
        self.init(componet: Component(baseURL: baseURL, header: [:], requester: URLSession.shared))
    }
    
    public convenience init(baseURL: String, header: [String: String]) {
        self.init(componet: Component(baseURL: baseURL, header: header, requester: URLSession.shared))
    }
}
