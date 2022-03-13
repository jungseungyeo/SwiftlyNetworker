//
//  Networkerable.swift
//  SwiftlyNetworker
//
//  Created by saeng lin on 2022/03/12.
//

import Foundation
import Combine

// MARK: - NetworkerLogicDependency
public protocol NetworkerLogicDependency {
    var baseURL: String { get }
    var header: [String: String] { get set }
    var requester: Requester { get }
}

// MARK: - NetworkerLogic
public protocol NetworkerLogic: AnyObject {
    var component: NetworkerLogicDependency { get set }
    func request<T: Decodable>(_ api: APIable, complete: @escaping ((Result<T, Swift.Error>) -> Void))
    func request<T: Decodable>(_ api: APIable) -> AnyPublisher<T, Error>
}

// MARK: - NetworkerLogic addHeader
extension NetworkerLogic {
    public func addHeader(_ header: [String: String]) {
        header.forEach { key, value in
            component.header[key] = value
        }
    }
}

extension NetworkerLogic {
    
    // MARK: - Closure Networker
    public func request<T: Decodable>(_ api: APIable, complete: @escaping ((Result<T, Swift.Error>) -> Void)) {
        
        var urlComponents = URLComponents(string: component.baseURL + api.path)
        
        guard let url = urlComponents?.url else {
            complete(.failure(NSError(domain: "Invalid URL", code: -999, userInfo: nil)))
            return
        }
        var urlRequest: URLRequest
        
        switch api.method {
        case .get:
            
            var parameters: [URLQueryItem] = []
            api.params?.forEach({ key, value in
                parameters.append(URLQueryItem(name: key, value: "\(value)"))
            })
            
            urlComponents?.queryItems = parameters
            
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = api.method.methodName
            
            component.header.forEach { key, value in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
            
        case .post, .delete, .put:
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = api.method.methodName
            
            if let params = api.params {
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            }
            
            component.header.forEach { key, value in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let start = CFAbsoluteTimeGetCurrent()
        if api.log {
            debugPrint("------ [URL] :: \(String(describing: urlRequest.url)) ------")
        }
        
        component.requester.request(request: urlRequest) { result in
            if api.log {
                let diff = CFAbsoluteTimeGetCurrent() - start
                debugPrint("[URL \(diff) seconds] :: \(String(describing: urlRequest.url))")
            }
            
            switch result {
            case .success(let response):
                if api.log {
                    debugPrint("[URL \(response.status) statusCode] :: \(String(describing: urlRequest.url))")
                }
                guard let data = response.data else {
                    complete(.failure(NSError(domain: "InValid Data", code: -999, userInfo: nil)))
                    return
                }
                
                guard let decode = try? JSONDecoder().decode(T.self, from: data) else {
                    complete(.failure(NSError(domain: "InValid JSONDecoder", code: -999, userInfo: nil)))
                    return
                }
                
                if api.log {
                    debugPrint("[JSON] \(decode)")
                }
                
                complete(.success(decode))
                
            case .failure(let error):
                
                if api.log {
                    debugPrint("[Error] \(error)")
                }
                
                complete(.failure(error))
            }
        }
    }
}

extension NetworkerLogic {
    
    // MARK: - Combine Networker
    public func request<T: Decodable>(_ api: APIable) -> AnyPublisher<T, Error> {
        
        var urlComponents = URLComponents(string: component.baseURL + api.path)
        
        guard let url = urlComponents?.url else {
            return Future<T, Error> { promise in
                promise(.failure(NSError(domain: "Invalid URL", code: -999, userInfo: nil)))
            }.eraseToAnyPublisher()
        }
        var urlRequest: URLRequest
        
        switch api.method {
        case .get:
            
            var parameters: [URLQueryItem] = []
            api.params?.forEach({ key, value in
                parameters.append(URLQueryItem(name: key, value: "\(value)"))
            })
            
            urlComponents?.queryItems = parameters
            
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = api.method.methodName
            
            component.header.forEach { key, value in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
            
        case .post, .delete, .put:
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = api.method.methodName
            
            if let params = api.params {
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            }
            
            component.header.forEach { key, value in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return component.requester.request(request: urlRequest)
            .tryMap { response -> T in
                guard let data = response.data else {
                    throw NSError(domain: "InValid Data", code: -999, userInfo: nil)
                }
                
                guard let decode = try? JSONDecoder().decode(T.self, from: data) else {
                    throw NSError(domain: "InValid JSONDecoder", code: -999, userInfo: nil)
                }
                
                return decode
            }.eraseToAnyPublisher()
    }
}
