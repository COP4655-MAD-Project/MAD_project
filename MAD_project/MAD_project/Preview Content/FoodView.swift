//
//  FoodView.swift
//  MAD_project
//
//  Created by Christian LeMay on 11/15/24.
//

import SwiftUI

struct FoodItem: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool = false // Default value
}

struct FoodView: View {
    @State private var foodList: [FoodItem] = [
        FoodItem(name: "Pizza"),
        FoodItem(name: "Ice Cream", isCompleted: true),
        FoodItem(name: "Salad")
    ]
    @State private var isAddingFood: Bool = false
    @State private var newFoodName: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    // Add Event Button
                    HStack {
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        // Title
                        Text("Food Items")
                            .font(.system(size: 50, weight: .regular, design: .serif))
                            .italic()
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                isAddingFood.toggle()
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 35, weight: .bold))
                        }
                    }
                    .padding(.trailing, 10)

                    // If adding a food item, show a text box
                    if isAddingFood {
                        VStack {
                            TextField("New Food", text: $newFoodName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .foregroundColor(.black)
                                .padding()

                            HStack {
                                Button(action: addFood) {
                                    Text("Submit")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }

                                Button(action: {
                                    withAnimation {
                                        isAddingFood = false
                                    }
                                }) {
                                    Text("Cancel")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
                    }

                    // List of food items
                    List {
                        ForEach($foodList) { $foodItem in
                            VStack {
                                HStack {
                                    // Food name
                                    Text(foodItem.name)
                                        .font(.system(size: 20, weight: .bold))
                                        .strikethrough(foodItem.isCompleted, color: .gray)
                                        .foregroundColor(foodItem.isCompleted ? .gray : .black)

                                    Spacer()

                                    // Custom bubble for food completion
                                    Button(action: {
                                        foodItem.isCompleted.toggle()
                                    }) {
                                        ZStack {
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(foodItem.isCompleted ? .green : .white)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black, lineWidth: 2)
                                                )

                                            if foodItem.isCompleted {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 18))
                                            }
                                        }
                                    }
                                }

                                Divider()
                                    .background(Color.black)
                                    .frame(height: 1)
                                    .padding(.top, 5)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteFood)
                    }
                    .listStyle(.plain)

                    Spacer()
                }
                .padding()
            }
        }
    }

    // Add a new food item
    private func addFood() {
        guard !newFoodName.isEmpty else { return }
        let newFoodItem = FoodItem(name: newFoodName)
        foodList.append(newFoodItem)
        newFoodName = ""
        withAnimation {
            isAddingFood = false
        }
    }

    // Delete a food item
    private func deleteFood(at offsets: IndexSet) {
        foodList.remove(atOffsets: offsets)
    }
}

#Preview {
    FoodView()
}


