//
//  LogIn.swift
//  GroupProject1
//
//  Created by Cristian De Francesco on 11/14/24.
//

import SwiftUI

struct LogInView: View {
    @Environment(AuthManager.self) var authManager
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Planorama")
                        .font(.system(size: 60, weight: .regular, design: .serif))
                        .italic()
                        .font(.largeTitle)

                    VStack {
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .foregroundColor(.black)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .foregroundColor(.black)
                    }
                    .textInputAutocapitalization(.never)
                    .padding(40)

                    HStack {
                        NavigationLink(destination: SignUpDetailsView()) {
                            Text("Sign Up")
                                .font(.headline)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button("Login") {
                            print("Login user: \(email), \(password)")
                            authManager.signIn(email: email, password: password)
                        }
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
}

#Preview {
    LogInView()
        .environment(AuthManager())
}

