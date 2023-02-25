//
//  MealListViewModel.swift
//  MealList
//
//  Created by Qi Zhan on 2/23/23.
//

import Foundation


@MainActor
class MealListViewModel: ObservableObject {
       
    @Published private(set) var mealViewModels: [MealViewModel] = []
    @Published private(set) var errorMessage = ""
    @Published var hasError = false

    func fetchMeals() async {
        guard let data = try? await MealNetworkServices().fetchMeals() else {
            mealViewModels = []
            hasError = true
            errorMessage  = "Server Error"
            return
        }
        
        mealViewModels.removeAll()
        let meals = data.meals.filter{ $0.strMeal != nil }.sorted { $0.strMeal! < $1.strMeal! }
        for meal in meals {
            if let id = meal.mealId, let mealStr = meal.strMeal, let mealThumbStr = meal.strMealThumb {
                let vm = MealViewModel(id: id, mealStr: mealStr, mealThumbStr: mealThumbStr)
                mealViewModels.append(vm)
            }
        }
    }
}
