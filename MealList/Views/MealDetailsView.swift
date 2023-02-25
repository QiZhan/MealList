//
//  MealDetailsView.swift
//  MealList
//
//  Created by Qi Zhan on 2/22/23.
//

import SwiftUI

struct MealDetailsView: View {
    
    var mealId: String
    
    @StateObject var vm = MealDetailsViewModel()
    
    var body: some View {
        ScrollView {
            
            if let mealImageURL = vm.mealDetails?.strMealThumb {
                ImageView(url: mealImageURL).frame(width: 200, height: 200).clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                if let mealStr = vm.mealDetails?.strMeal {
                    Text(mealStr).font(.title)
                }
                
                HStack {
                    if let category = vm.mealDetails?.strCategory {
                        Text(category)
                    }
                    
                    Spacer()
                    
                    if let area = vm.mealDetails?.strArea {
                        Text(area)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                if let instructions = vm.mealDetails?.strInstructions {
                    Divider()
                    Text("Instructions").font(.title2)
                    Spacer()
                    Text(instructions)
                }
                
                if let ingredientsAndMeasures = vm.mealDetails?.ingredientsAndMeasures {
                    Divider()
                    Text("Ingredients").font(.title2)
                    Spacer()
                    Text(ingredientsAndMeasures)
                }
                
            }.padding()
        }.task {
            await vm.fetchMealDetails(by: mealId)
        }.alert(vm.errorMessage, isPresented: $vm.hasError) {
            Button("OK", role: .cancel) {}
        }
    }
}
