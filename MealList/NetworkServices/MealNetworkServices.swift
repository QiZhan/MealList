//
//  MealNetworkServices.swift
//  MealList
//
//  Created by Qi Zhan on 2/13/23.
//

import Foundation
import UIKit

class Constants {
    public static let mealsURLStr = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    public static let mealDetailsBaseURLStr = "https://themealdb.com/api/json/v1/1/lookup.php"
}

protocol Networking {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: Networking {}

protocol MealNetworkServiceProtocol: AnyObject {
    func fetchMeals() async throws -> Meals
    func fetchMealDetails(by mealId: String) async throws -> Recipe
    func fetchMealImage() async throws -> UIImage?
}

class MealNetworkServices: MealNetworkServiceProtocol {
    
    enum NetworkServiceError: Error {
        case failed
        case badImage
        case invalidUrl, requestError, decodingError, statusNotOk
    }
    
    let session: Networking
    
    init(session: Networking = URLSession.shared) {
        self.session = session
    }
    
    func fetchMeals() async throws -> Meals {
        guard let url = URL(string: Constants.mealsURLStr) else{
            throw NetworkServiceError.invalidUrl
        }
        
        guard let (data, response) = try? await URLSession.shared.data(from: url) else{
            throw NetworkServiceError.requestError
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw NetworkServiceError.statusNotOk
        }
        
        guard let result = try? JSONDecoder().decode(Meals.self, from: data) else {
            throw NetworkServiceError.decodingError
        }
        
        return result
    }
    
    func fetchMealDetails(by mealId: String) async throws -> Recipe {
        guard var url = URL(string: Constants.mealDetailsBaseURLStr) else {
            fatalError("Missing URL")
        }
        url.appendQueryItem(name: "i", value: mealId)
        
        guard let (data, response) = try? await URLSession.shared.data(from: url) else{
            throw NetworkServiceError.requestError
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw NetworkServiceError.statusNotOk
        }
        
        guard let result = try? JSONDecoder().decode(Recipe.self, from: data) else {
            throw NetworkServiceError.decodingError
        }
        
        return result
    }
    
    func fetchMealImage() async throws -> UIImage? {
        let urlStr = Constants.mealDetailsBaseURLStr
        guard let url = URL(string: urlStr) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await session.data(for: urlRequest, delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw  NetworkServiceError.badImage
        }
        
        return UIImage(data: data)
    }
}
