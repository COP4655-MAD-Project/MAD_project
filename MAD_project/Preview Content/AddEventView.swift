//
//  AddEventView.swift
//  MAD_project
//
//  Created by Angelo Magarelli on 11/21/24.
//

import SwiftUI

struct AddEventView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var eventName: String = ""
    @State private var eventType: String = "Birthday"
    @State private var eventDate: Date = Date()
    @State private var errorMessage: String?
    
    let eventTypes = ["Birthday", "Wedding", "Meeting", "Conference", "Party"]
    
    var body: some View {

            NavigationStack {
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Add a New Event")
                        .font(.largeTitle)
                        .padding()
                    
                    TextField("Event Name", text: $eventName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                    
                    Picker("Event Type", selection: $eventType) {
                        ForEach(eventTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    DatePicker("Event Date", selection: $eventDate, displayedComponents: .date)
                        .padding()
                    
                    Button("Add Event") {
                        guard let userId = authManager.user?.uid else { return }
                        
                        let newEvent = Event(id: UUID().uuidString, name: eventName, eventType: eventType, eventDate: eventDate)
                        authManager.addEvent(userId: userId, event: newEvent) { result in
                            switch result {
                            case .success:
                                print("Event added successfully!")
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Spacer()
                }
                .padding()
                
                
            }
        }
    }
}
