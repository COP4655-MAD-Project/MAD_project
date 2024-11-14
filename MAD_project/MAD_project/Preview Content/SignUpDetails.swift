//
//  SignUpDetails.swift
//  GroupProject1
//
//  Created by Cristian De Francesco on 11/14/24.
//
import SwiftUI

struct SignUpDetailsView: View {
    @Environment(AuthManager.self) var authManager
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedEventType: String = "Birthday"
    @State private var eventDate: Date = Date()
    
    @State private var errorMessage: String?
    
    let eventTypes = ["Birthday", "Wedding", "Meeting", "Conference", "Party"]
    
    var body: some View {
        VStack {
            Text("Enter Your Event Details")
                .font(.largeTitle)
                .padding(.top, 100)
                .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(alignment: .leading) {
                // Name field
                TextField("Enter your name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    .foregroundColor(.black)
                
                // Email field
                TextField("Enter your email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    .keyboardType(.emailAddress)
                    .foregroundColor(.black)
                
                // Password field
                SecureField("Enter your password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    .foregroundColor(.black)
                
                // Event Type picker
                Picker("Select event type", selection: $selectedEventType) {
                    ForEach(eventTypes, id: \.self) { event in
                        Text(event)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                
                // Event Date picker
                DatePicker("Select event date", selection: $eventDate, displayedComponents: .date)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            }
            
            Spacer()
            
            Button("Submit") {
                            // Clear the error message before trying to sign up
                            errorMessage = nil

                            // authenticates the user and signs them up
                            authManager.signUp(email: email, password: password, name: name, eventType: selectedEventType, eventDate: eventDate) { result in
                                switch result {
                                case .success():
                                    print("Sign-up successful!")
                                case .failure(let error):// If sign-up fails, display the error message
                                    errorMessage = (error as NSError).localizedDescription
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding([.bottom, .top], 20)
                        .frame(maxWidth: .infinity)

                        // Display error message if any
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .padding()
                        }
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]), startPoint: .top, endPoint: .bottom))
                    .edgesIgnoringSafeArea(.all)
                }
            }

struct SignUpDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpDetailsView()
            .environment(AuthManager())
    }
}
