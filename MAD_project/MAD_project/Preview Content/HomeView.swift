//
//  HomeView.swift
//  MAD_project
//
//  Created by Joel Ezan on 11/27/24.
//


import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Planorama")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.black)

                Spacer()

                HStack {
                   
                    NavigationLink(destination: CalendarView()) {
                        VStack {
                            Image(systemName: "calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("Calendar")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(10)
                    }
                    .padding(.leading, 20)

                    Spacer()

               
                    NavigationLink(destination: FoodView()) {
                        VStack {
                            Image(systemName: "fork.knife")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("Food")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(10)
                    }
                    .padding(.trailing, 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                .background(Color.white)
            }
            .background(Color(UIColor.systemGray6)) 
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        authManager.signOut()
                    }) {
                        Text("Sign Out")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
