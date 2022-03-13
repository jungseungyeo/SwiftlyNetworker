//
//  APIable.swift
//  SwiftlyNetworker
//
//  Created by saeng lin on 2022/03/12.
//

import Foundation

public enum HttpMethod {
    case get
    case post
    case put
    case delete
    
    var methodName: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}

public protocol APIable {
    var params: [String: Any]? { get }
    var path: String { get }
    var method: HttpMethod { get }
}

extension APIable {
    var log: Bool { return true }
}
