//
//  WeatherView.swift
//  MAD_project
//
//  Created by Angelo Magarelli on 11/25/24.
//

import SwiftUI

struct WeatherView: View {
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            Text("Weather for the day")
                .font(.largeTitle)
                .padding()
        }
    }
}

#Preview {
    WeatherView()
}
