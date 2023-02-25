//
//  MealDetail.swift
//  MealList
//
//  Created by Qi Zhan on 2/22/23.
//

import SwiftUI

struct MealDetailsView: View {
    
    var recipe: MealDetails
    
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: recipe.strMealThumb ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
                .background(Color.gray)
                .clipShape(Circle())
            VStack(alignment: .leading) {

                
                Text(recipe.strMeal ?? "").font(.title)
                
                HStack {
//                    Text(recipe.strDrinkAlternate ?? "")
                    
                    Text(recipe.strCategory ?? "")
                    Spacer()
                    Text(recipe.strArea ?? "")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()
  
                Text("Instruction").font(.title2)
                Spacer()
                Text(recipe.strInstructions ?? "").foregroundColor(.secondary)
                
                
                Divider()
                Text("Ingredients").font(.title2)
                Spacer()
                Text(recipe.ingredientsAndMeasures)
            }.padding()
        }

    }
}

//struct MealDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MealDetailsView()
//    }
//}
