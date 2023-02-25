//
//  URL+Extensions.swift
//  MealList
//
//  Created by Qi Zhan on 2/23/23.
//

import Foundation

extension URL {

    mutating func appendQueryItem(name: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: name, value: value)

        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems

        self = urlComponents.url!
    }
    
}
