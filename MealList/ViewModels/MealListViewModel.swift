//
//  MealListViewModel.swift
//  MealList
//
//  Created by Qi Zhan on 2/23/23.
//

import Foundation


@MainActor
class MealListViewModel: ObservableObject {
       
    @Published var meals: [Meal] = []
    @Published var errorMessage = ""
    @Published var hasError = false

    func fetchMeals() async {
        guard let data = try? await MealNetworkServices().fetchMeals() else {
            meals = []
            hasError = true
            errorMessage  = "Server Error"
            return
        }
        
        self.meals = data.meals
    }
}
