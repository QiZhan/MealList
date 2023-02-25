//
//  MealDetailsViewModel.swift
//  MealList
//
//  Created by Qi Zhan on 2/23/23.
//

import Foundation

@MainActor
class MealDetailsViewModel: ObservableObject {
       
    @Published var mealDetails: MealDetails?
    @Published var errorMessage = ""
    @Published var hasError = false
    
    func fetchMealDetails(by mealId: String) async {
        guard let data = try? await MealNetworkServices().fetchMealDetails(by: mealId) else {
            mealDetails = nil
            hasError = true
            errorMessage  = "Server Error"
            return
        }
        
        self.mealDetails = data.mealDetails[0]
        
    }
}
