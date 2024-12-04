//
//  InvitationsView.swift
//  MAD_project
//
//  Created by Angelo Magarelli on 11/25/24.
//
import SwiftUI
import Firebase

struct InvitationsView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var guestList: [Guest] = []
    @State private var newGuest: String = ""
    
    private let db = Firestore.firestore()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Manage Invitations")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 20)

                Text("Total Invited: \(guestList.count)")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))

                if guestList.isEmpty {
                    Text("No guests invited yet!")
                        .font(.subheadline)
                        .italic()
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 20)
                } else {
                    ScrollView {
                        ForEach(GuestStatus.allCases, id: \.self) { status in
                            Section(header: Text(status.rawValue)
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(.leading)
                            ) {
                                ForEach(guestList.filter { $0.status == status }) { guest in
                                    HStack {
                                        Text(guest.name)
                                            .font(.body)
                                            .foregroundColor(.brown)
                                            .padding(.leading)
                                        
                                        Spacer()

                                        Picker("", selection: Binding<GuestStatus>(
                                            get: { guest.status },
                                            set: { newStatus in
                                                updateGuestStatus(guest, to: newStatus)
                                            }
                                        )) {
                                            ForEach(GuestStatus.allCases, id: \.self) { status in
                                                Text(status.rawValue)
                                                    .font(.system(size: 14, weight: .regular)) // Font adjustments
                                                    .foregroundColor(.black) // Ensure contrast
                                                    .tag(status)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .frame(width: 120) // Make the dropdown smaller
                                        .padding(5)
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(8)
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                                        Button(action: {
                                            deleteGuest(guest)
                                        }) {
                                            Image(systemName: "trash.fill")
                                                .foregroundColor(.red)
                                                .padding(10)
                                                .background(Color.white.opacity(0.8))
                                                .clipShape(Circle())
                                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white.opacity(0.9))
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                }

                Spacer()

                HStack {
                    TextField("Enter Guest Name", text: $newGuest)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                    Button(action: addGuest) {
                        Text("Add")
                            .font(.headline)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.2))
            }
            .padding(.horizontal)
        }
        .onAppear(perform: fetchGuests)
    }

    private func fetchGuests() {
        guard let user = authManager.user else { return }
        db.collection("invitations").document(user.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()?["guests"] as? [[String: Any]] ?? []
                self.guestList = data.compactMap { dict in
                    if let name = dict["name"] as? String,
                       let statusString = dict["status"] as? String,
                       let status = GuestStatus(rawValue: statusString) {
                        return Guest(name: name, status: status)
                    }
                    return nil
                }
            } else {
                print("No guest list found or error: \(String(describing: error))")
            }
        }
    }

    private func saveGuests() {
        guard let user = authManager.user else { return }
        let guestData = guestList.map { ["name": $0.name, "status": $0.status.rawValue] }
        db.collection("invitations").document(user.uid).setData(["guests": guestData]) { error in
            if let error = error {
                print("Error saving guest list: \(error)")
            }
        }
    }

    private func addGuest() {
        guard !newGuest.isEmpty else { return }
        let newGuestEntry = Guest(name: newGuest, status: .noAnswer)
        guestList.append(newGuestEntry)
        newGuest = ""
        saveGuests()
    }

    private func updateGuestStatus(_ guest: Guest, to newStatus: GuestStatus) {
        if let index = guestList.firstIndex(where: { $0.id == guest.id }) {
            guestList[index].status = newStatus
            saveGuests()
        }
    }

    private func deleteGuest(_ guest: Guest) {
        guestList.removeAll { $0.id == guest.id }
        saveGuests()
    }
}

struct Guest: Identifiable {
    let id = UUID()
    var name: String
    var status: GuestStatus
}

enum GuestStatus: String, CaseIterable {
    case attending = "Attending"
    case notAttending = "Not Attending"
    case noAnswer = "N/A"
}

#Preview {
    InvitationsView().environmentObject(AuthManager())
}
