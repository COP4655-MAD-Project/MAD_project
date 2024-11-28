//
//  InvitationsView.swift
//  MAD_project
//
//  Created by Angelo Magarelli on 11/25/24.
//

import SwiftUI

struct InvitationsView: View {
    @State private var guestList: [String] = []
    @State private var newGuest: String = ""
    @State private var guestCount: Int = 0

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Manage Invitations")
                    .font(.largeTitle)
                    .padding()
                
                Text("Total Invited: \(guestCount)")
                    .font(.headline)
                    .padding()
                
                List(guestList, id: \.self) { guest in
                    Text(guest)
                        .font(.body)
                }
                
                HStack {
                    TextField("Enter Guest Name", text: $newGuest)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Add") {
                        addGuest()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
    private func addGuest() {
        guard !newGuest.isEmpty else { return }
        guestList.append(newGuest)
        newGuest = ""
        guestCount = guestList.count
    }
}

#Preview {
    InvitationsView()
}
