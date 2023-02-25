//
//  UIImageView+Cache.swift
//  MealList
//
//  Created by Qi Zhan on 2/25/23.
//

import Foundation
import UIKit
import SwiftUI

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadRemoteImageFrom(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let activityView = UIActivityIndicatorView(style: .large)
        
        image = nil
        activityView.center = self.center
        addSubview(activityView)
        activityView.startAnimating()
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = imageFromCache
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
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
        
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.loadRemoteImageFrom(urlString: url)
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
}
