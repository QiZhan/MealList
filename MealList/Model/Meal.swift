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

struct Meal: Codable {
    
    let mealId: String?
    let strMeal: String?
    let strMealThumb: String?
    
    enum CodingKeys: String, CodingKey {
        case mealId = "idMeal", strMeal, strMealThumb
    }
}
