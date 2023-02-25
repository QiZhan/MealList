//
//  UIImageView+Cache.swift
//  MealList
//
//  Created by Qi Zhan on 2/25/23.
//

import Foundation
import UIKit
import SwiftUI


protocol ImageCacheProtocol {
    func getCache() -> NSCache<AnyObject, UIImage>
}

final class ImageCache: ImageCacheProtocol {
    
    var cache: NSCache<AnyObject, UIImage> = NSCache<AnyObject, UIImage>()
    static var shared = ImageCache()
    
    private init() {}
    
    func getCache() -> NSCache<AnyObject, UIImage> {
        return cache
    }
}

extension UIImageView {
    
    func load(from urlString: String,
              session: URLSession = URLSession.shared,
              imageCache: NSCache<AnyObject, UIImage> = ImageCache.shared.getCache()) {
        guard let url = URL(string: urlString) else { return }
        let activityView = UIActivityIndicatorView(style: .large)
        
        image = nil
        activityView.center = self.center
        addSubview(activityView)
        activityView.startAnimating()
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            image = imageFromCache
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            }
            if let response = data {
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: response) {
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                        self.image = imageToCache
                    }
                }
            }
        }.resume()
    }
}

struct ImageView: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> some UIView {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.load(from: url)
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
}
