import SwiftUI
import Firebase

struct InvitationsView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var guestList: [Guest] = []
    @State private var newGuest: String = ""
    let eventId: String 

    var totalAttending: Int {
        guestList.filter { $0.status == .attending }.count
    }

    var groupedGuests: [GuestStatus: [Guest]] {
        Dictionary(grouping: guestList, by: { $0.status })
    }

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

                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 5) {
                        Text("Manage Invitations")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)

                        Text("Total Guests Attending: \(totalAttending)")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))

                        Text("Total Guests: \(guestList.count)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 20)

                    if guestList.isEmpty {
                        Text("No guests invited yet!")
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 20)
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(GuestStatus.allCases, id: \.self) { status in
                                    if let guests = groupedGuests[status], !guests.isEmpty {
                                        Section(header: Text(status.rawValue)
                                            .font(.headline)
                                            .foregroundColor(.white.opacity(0.8))
                                            .padding(.leading)) {
                                            ForEach(guests) { guest in
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
                                                        }
                                                    }
                                                    .pickerStyle(MenuPickerStyle())
                                                    .frame(width: 120)
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
                                        .padding(.bottom, 10)
                                    }
                                }
                            }
                        }
                    }

                    Spacer()

                    // Add New Guest Section
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
        }
        .onAppear(perform: fetchGuests)
    }


    private func fetchGuests() {
        guard let userId = authManager.user?.uid else { return }
        authManager.fetchEventInvitations(userId: userId, eventId: eventId) { guests in
            guestList = guests
        }
    }

    private func saveGuests() {
        guard let userId = authManager.user?.uid else { return }
        authManager.saveEventInvitations(userId: userId, eventId: eventId, guests: guestList) { result in
            if case .failure(let error) = result {
                print("Error saving guests: \(error.localizedDescription)")
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

#Preview {
    let mockAuthManager = AuthManager()
    mockAuthManager.userEvents = [
        Event(id: "sampleEventId", name: "Sample Event", eventType: "Birthday", eventDate: Date())
    ]
    return InvitationsView(eventId: "sampleEventId")
        .environmentObject(mockAuthManager)
}
