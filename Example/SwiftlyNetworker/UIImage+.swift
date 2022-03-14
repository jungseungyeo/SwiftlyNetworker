//
//  UIImage+.swift
//  SwiftlyNetworker_Example
//
//  Created by saeng lin on 2022/03/14.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

private let imageCache = NSCache<AnyObject, AnyObject>()
private var sessionDataTaskAssociatedObjectKey: Void?
extension UIImageView {
    private var task: URLSessionDataTask? {
        set {
            objc_setAssociatedObject(self, &sessionDataTaskAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &sessionDataTaskAssociatedObjectKey) as? URLSessionDataTask
        }
    }
    
    private func dateImage(
        from url: URL,
        completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            self.task = URLSession.shared.dataTask(
                with: url,
                completionHandler: completion
            )
            
            self.task?.resume()
        }
    
    func loadImage(from url: String?, with thumnailImage: UIImage? = nil) {
        guard let url = url, let url = URL(string: url) else { return }
        self.loadImage(from: url, with: thumnailImage)
    }
    
    func loadImage(from url: URL?, with thumnailImage: UIImage? = nil) {
        image = thumnailImage
        backgroundColor = .darkGray
        
        guard let url = url else { return }
        
        if let imageCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            backgroundColor = .clear
            image = imageCache
        } else {
            dateImage(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                guard let image = UIImage(data: data) else { return }
                imageCache.setObject(image, forKey: url as AnyObject)
                DispatchQueue.main.async { [weak self] in
                    self?.backgroundColor = .clear
                    self?.image = image
                }
            }
        }
    }
    
    func loadCancel() {
        task?.cancel()
    }
}
