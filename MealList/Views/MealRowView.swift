//
//  MealRowView.swift
//  MealList
//
//  Created by Qi Zhan on 2/22/23.
//

import SwiftUI

struct MealRowView: View {
    
    var meal: Meal
    
    var body: some View {
        
        HStack {
            if let mealImageURL = meal.strMealThumb {
                ImageView(url: mealImageURL)
                    .frame(width: 100, height: 100)
                    .background(.clear)
                    .clipShape(Circle())
            
            }
            
            if let mealStr = meal.strMeal {
                Text(mealStr)
            }
        }
        
    }
}

