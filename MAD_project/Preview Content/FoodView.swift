//
//  FoodView.swift
//  MAD_project
//
//  Created by Christian LeMay on 11/15/24.
//

import SwiftUI
import FirebaseFirestore

struct FoodItem: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool = false // Default value
}

struct FoodView: View {
    @State private var foodList: [FoodItem] = []
    @State private var isAddingFood: Bool = false
    @State private var newFoodName: String = ""
    
    let currentEventId: String
    @ObservedObject var authManager: AuthManager // Reference to AuthManager to get current user's event
    private let db = Firestore.firestore() // Firestore instance

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
                                        updateFoodCompletion(foodItem)
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
                .onAppear(perform: fetchFoodItems)
            }
        }
    }

    // Add a new food item
    private func addFood() {
        guard !newFoodName.isEmpty else { return }
        let newFoodItem = FoodItem(name: newFoodName)
        saveFoodToFirestore(newFoodItem)
        newFoodName = ""
        withAnimation {
            isAddingFood = false
        }
    }

    // Save new food to Firestore
    private func saveFoodToFirestore(_ foodItem: FoodItem) {
        let foodRef = db.collection("foodItems").document(foodItem.id.uuidString)
        let foodData: [String: Any] = [
            "foodName": foodItem.name,
            "completedBool": foodItem.isCompleted,
            "eventId": currentEventId // Use the passed event ID
        ]
        foodRef.setData(foodData) { error in
            if let error = error {
                print("Error saving food to Firestore: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    foodList.append(foodItem)
                }
            }
        }
    }

    // Fetch food items from Firestore
    private func fetchFoodItems() {
        db.collection("foodItems")
            .whereField("eventId", isEqualTo: currentEventId) // Filter by the passed event ID
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching food items: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                DispatchQueue.main.async {
                    foodList = documents.compactMap { doc in
                        let data = doc.data()
                        guard
                            let foodName = data["foodName"] as? String,
                            let completedBool = data["completedBool"] as? Bool
                        else {
                            return nil
                        }
                        return FoodItem(name: foodName, isCompleted: completedBool)
                    }
                }
            }
    }


    // Update food completion status
    private func updateFoodCompletion(_ foodItem: FoodItem) {
        let foodRef = db.collection("foodItems").document(foodItem.id.uuidString)
        foodRef.updateData(["completedBool": foodItem.isCompleted]) { error in
            if let error = error {
                print("Error updating food completion status: \(error.localizedDescription)")
            }
        }
    }

    // Delete a food item
    private func deleteFood(at offsets: IndexSet) {
        offsets.forEach { index in
            let foodItem = foodList[index]
            let foodRef = db.collection("foodItems").document(foodItem.id.uuidString)
            foodRef.delete { error in
                if let error = error {
                    print("Error deleting food item: \(error.localizedDescription)")
                }
            }
        }
        foodList.remove(atOffsets: offsets)
    }
}

#Preview {
    FoodView(currentEventId: "sampleEventId", authManager: AuthManager())
}
