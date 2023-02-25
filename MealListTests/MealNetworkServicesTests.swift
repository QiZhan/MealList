//
//  MealNetworkServicesTests.swift
//  MealNetworkServicesTests
//
//  Created by Qi Zhan on 2/22/25.
//

import XCTest
@testable import MealList

final class MealNetworkServicesTests: XCTestCase {

    func testFetchMealsReturnsMealsWhenSuccess() async throws {
        // Given
        let sessionMock = URLSessionMock()
        sessionMock.mockResponseData = #"{"meals":[{"strMeal":"Apam balik","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/adxcbq1619787919.jpg","idMeal":"53049"}]}"#.data(using: .utf8)!
        let service = MealNetworkServices(session: sessionMock)
        
        // When
        let response = try await service.fetchMeals()
        
        // Then
        XCTAssertEqual(response.meals.count, 1)
        XCTAssertEqual(response.meals.first?.strMeal, "Apam balik")
        XCTAssertEqual(response.meals.first?.strMealThumb, "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        XCTAssertEqual(response.meals.first?.mealId, "53049")
    }
    
    
    func testFetchMealsWhenError() async throws {
        // Given
        let sessionMock = URLSessionMock()
        let service = MealNetworkServices(session: sessionMock)
        sessionMock.mockError = MealNetworkServices.NetworkServiceError.requestError
        let expect = expectation(description: "expect call to throw error")
        do {
            // When
            let _ = try await service.fetchMeals()
        } catch {
            // Then
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 3)
    }
    
    func testFetchMealDetailsReturnsMealDetailsWhenSuccess() async throws {
        // Given
        let sessionMock = URLSessionMock()
        sessionMock.mockResponseData = #"{"meals":[{"idMeal":"53049","strMeal":"Apam balik","strDrinkAlternate":null,"strCategory":"Dessert","strArea":"Malaysian","strInstructions":"Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/adxcbq1619787919.jpg","strTags":null,"strYoutube":"https:\/\/www.youtube.com\/watch?v=6R8ffRRJcrg","strIngredient1":"Milk","strIngredient2":"Oil","strIngredient3":"Eggs","strIngredient4":"Flour","strIngredient5":"Baking Powder","strIngredient6":"Salt","strIngredient7":"Unsalted Butter","strIngredient8":"Sugar","strIngredient9":"Peanut Butter","strIngredient10":"","strIngredient11":"","strIngredient12":"","strIngredient13":"","strIngredient14":"","strIngredient15":"","strIngredient16":"","strIngredient17":"","strIngredient18":"","strIngredient19":"","strIngredient20":"","strMeasure1":"200ml","strMeasure2":"60ml","strMeasure3":"2","strMeasure4":"1600g","strMeasure5":"3 tsp","strMeasure6":"1\/2 tsp","strMeasure7":"25g","strMeasure8":"45g","strMeasure9":"3 tbs","strMeasure10":" ","strMeasure11":" ","strMeasure12":" ","strMeasure13":" ","strMeasure14":" ","strMeasure15":" ","strMeasure16":" ","strMeasure17":" ","strMeasure18":" ","strMeasure19":" ","strMeasure20":" ","strSource":"https:\/\/www.nyonyacooking.com\/recipes\/apam-balik~SJ5WuvsDf9WQ","strImageSource":null,"strCreativeCommonsConfirmed":null,"dateModified":null}]}"#.data(using: .utf8)!
        let service = MealNetworkServices(session: sessionMock)
        
        // When
        let response = try await service.fetchMealDetails(by: "meal_id")
        
        // Then
        XCTAssertEqual(response.mealDetails.count, 1)
        XCTAssertEqual(response.mealDetails.first?.strMeal, "Apam balik")
        XCTAssertEqual(response.mealDetails.first?.strInstructions, "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.")
        XCTAssertEqual(response.mealDetails.first?.idMeal, "53049")
        XCTAssertEqual(response.mealDetails.first?.strIngredient1, "Milk")
        XCTAssertEqual(response.mealDetails.first?.strMeasure1, "200ml")
    }
    
    func testFetchMealDetailsWhenError() async throws {
        // Given
        let sessionMock = URLSessionMock()
        let service = MealNetworkServices(session: sessionMock)
        sessionMock.mockError = MealNetworkServices.NetworkServiceError.requestError
        let expect = expectation(description: "expect call to throw error")
        do {
            // When
            let _ = try await service.fetchMealDetails(by: "meal_id")
        } catch {
            // Then
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 3)
    }

}

class URLSessionMock: Networking {
    var didCallDataForRequest: URLRequest?
    var didCallDataWithDelegate: URLSessionTaskDelegate?
    var mockResponseData = Data()
    var mockError: Error?
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        let mockURLResponse = HTTPURLResponse(url: url,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        return (mockResponseData, mockURLResponse!)
    }
}
