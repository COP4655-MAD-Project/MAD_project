//
//  ContentView.swift
//  MAD_project
//
//  Created by Christian LeMay on 10/16/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "tree.circle")
                .font(.system(size: 100))
                .foregroundStyle(Color.mint)
            Text("Hello, Miami!")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
