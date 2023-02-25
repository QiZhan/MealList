//
//  MealRowView.swift
//  MealList
//
//  Created by Qi Zhan on 2/22/23.
//

import SwiftUI

struct MealRowView: View {
    
    var mealViewModel: MealViewModel
    
    var body: some View {
        
        HStack {
            ImageView(url: mealViewModel.mealThumbStr)
                .frame(width: 100, height: 100)
                .background(.gray)
                .clipShape(Circle())
            
            Text(mealViewModel.mealStr)
        }
        
    }
}

