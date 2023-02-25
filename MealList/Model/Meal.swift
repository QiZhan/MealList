//
//  Meal.swift
//  MealList
//
//  Created by Qi Zhan on 2/22/23.
//

import Foundation

struct Meals: Codable {
    
    let meals: [Meal]
    
}

struct Meal: Hashable, Codable, Identifiable   {
    
    let id: String?
    let strMeal: String?
    let strMealThumb: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal", strMeal, strMealThumb
    }
}
