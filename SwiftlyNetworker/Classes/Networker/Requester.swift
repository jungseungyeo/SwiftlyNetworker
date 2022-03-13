//
//  Requester.swift
//  SwiftlyNetworker
//
//  Created by saeng lin on 2022/03/12.
//

import Foundation
import Combine

public protocol Requester {
    
    // MARK: - Closure Interface
    func request(request: URLRequest, completion: @escaping (Result<URLSession.Response, Swift.Error>) -> Void)
    
    
    // MARK: - Combine Interface
    func request(request: URLRequest) -> AnyPublisher<URLSession.Response, Error>
}

extension URLSession: Requester {

    public struct Response {
        let status: Int
        let data: Data?
    }
    
    public func request(request: URLRequest, completion: @escaping (Result<Response, Error>) -> Void) {
        dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                completion(.success(.init(status: response.statusCode, data: data)))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "Unknown Error", code: (response as? HTTPURLResponse)?.statusCode ?? -999 , userInfo: nil)))
            }
        }.resume()
    }
    
    public func request(request: URLRequest) -> AnyPublisher<Response, Error> {
        return Future<Response, Error> { [weak self] promise in
            
            guard let self = self else {
                promise(.failure(NSError(domain: "Invalid Self", code: -999, userInfo: nil)))
                return
            }
            
            self.request(request: request) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func request(request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> Response {
        do {
            let (data, response) = try await data(for: request, delegate: delegate)
            
            guard let httpResponse = (response as? HTTPURLResponse) else {
                throw NSError(domain: "InValid HTTPURLResponse", code: -999, userInfo: nil)
            }
            
            return .init(status: httpResponse.statusCode, data: data)
        } catch {
            throw error
        }
    }
}
