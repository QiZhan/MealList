//
//  MealListView.swift
//  MealList
//
//  Created by Qi Zhan on 2/22/23.
//

import SwiftUI

struct MealListView: View {
    
    @StateObject var vm = MealListViewModel()
    
    var body: some View {
        NavigationView {
            List(vm.mealViewModels) { mealViewModel in
                NavigationLink {
                    if let mealId = mealViewModel.id {
                        MealDetailsView(mealId: mealId)
                    }
                } label: {
                    MealRowView(mealViewModel: mealViewModel)
                }
            }
            .navigationTitle("Meals")
            .task {
                await vm.fetchMeals()
            }.alert(vm.errorMessage, isPresented: $vm.hasError) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}
