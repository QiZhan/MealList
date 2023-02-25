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
            
            if let mealImageURL = vm.mealThumbStr {
                ImageView(url: mealImageURL)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                if let mealStr = vm.mealStr {
                    Text(mealStr).font(.title)
                }
                
                HStack {
                    if let category = vm.categoryStr {
                        Text(category)
                    }
                    
                    Spacer()
                    
                    if let area = vm.areaStr {
                        Text(area)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                if let instructions = vm.instructionsStr {
                    Divider()
                    Text("Instructions")
                        .font(.title2)
                    Spacer()
                    Text(instructions)
                }
                
                if let ingredientsAndMeasures = vm.ingredientsAndMeasuresStr {
                    Divider()
                    Text("Ingredients")
                        .font(.title2)
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
