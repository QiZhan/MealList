//
//  MealDetailsViewModel.swift
//  MealList
//
//  Created by Qi Zhan on 2/23/23.
//

import Foundation

@MainActor
class MealDetailsViewModel: ObservableObject {
    
    @Published private(set) var mealStr: String?
    @Published private(set) var mealThumbStr: String?
    @Published private(set) var categoryStr: String?
    @Published private(set) var areaStr: String?
    @Published private(set) var instructionsStr: String?
    @Published private(set) var ingredientsAndMeasuresStr: String?
    @Published private(set) var errorMessage = ""
    @Published var hasError = false
    
    func fetchMealDetails(by mealId: String) async {
        guard let data = try? await MealNetworkServices().fetchMealDetails(by: mealId) else {
            ingredientsAndMeasuresStr = nil
            hasError = true
            errorMessage  = "Server Error"
            
            return
        }
        let mealDetails = data.mealDetails[0]
        
        mealStr = mealDetails.strMeal
        categoryStr = mealDetails.strCategory
        areaStr = mealDetails.strArea
        mealThumbStr = mealDetails.strMealThumb
        instructionsStr = mealDetails.strInstructions
        ingredientsAndMeasuresStr = getIngredientsAndMeasures(from: mealDetails)
    }
    
    private func getIngredientsAndMeasures(from mealDetails: MealDetails) -> String {
        var arr = [String]()
        
        for idx in 1...20 {
            if let ingredient = mealDetails["strIngredient\(idx)"] as? String,
               let measure = mealDetails["strMeasure\(idx)"] as? String,
               !ingredient.isEmpty {
                let ingredientAndMeasure = ingredient + ": " + measure + "\n"
                arr.append(ingredientAndMeasure)
            }
        }
        
        return arr.reduce("") { $0 + $1 }
    }
    
}
