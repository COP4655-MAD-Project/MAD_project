import SwiftUI

struct MainPlannerView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isAddingEvent = false

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
                    // Header
                    HStack {
                        // "Sign Out" with icon
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.left")
                                .font(.headline)
                                .foregroundColor(.red)
                            Button("Sign Out") {
                                signOut()
                            }
                            .font(.headline)
                            .foregroundColor(.red)
                        }
                        .padding(.leading, 20)

                        Spacer()

                        // "Add Event" with icon
                        HStack(spacing: 5) {
                            Button("Add Event") {
                                isAddingEvent = true
                            }
                            .font(.headline)
                            .foregroundColor(.blue)
                            Image(systemName: "arrow.right")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 20)

                    // Title
                    Text("Your Events")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical)

                    // Event Feed
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            if authManager.userEvents.isEmpty {
                                Text("No events yet. Add your first event!")
                                    .foregroundColor(.white)
                                    .italic()
                                    .font(.headline)
                                    .padding(.top, 50)
                            } else {
                                ForEach(authManager.userEvents) { event in
                                    NavigationLink(destination: EventDetailView(event: event)) {
                                        EventCardView(event: event)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer()

                    // Bottom Navigation to Calendar
                    NavigationLink(destination: CalendarView().environmentObject(authManager)) {
                        VStack {
                            Image(systemName: "calendar.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Text("View Calendar")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.brown.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                    .padding(.bottom, 20)
                }
                .sheet(isPresented: $isAddingEvent) {
                    AddEventView()
                        .environmentObject(authManager)
                }
            }
        }
    }

    private func signOut() {
        authManager.signOut()
    }
}

struct EventCardView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.name)
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            Text("Date: \(event.eventDate, formatter: dateFormatter)")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.brown.opacity(0.85))
        )
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

#Preview {
    let sampleAuthManager = AuthManager()
    sampleAuthManager.userEvents = [
        Event(id: "1", name: "Birthday Party", eventType: "Birthday", eventDate: Date().addingTimeInterval(86400)),
        Event(id: "2", name: "Office Meeting", eventType: "Meeting", eventDate: Date().addingTimeInterval(172800))
    ]
    return MainPlannerView()
        .environmentObject(sampleAuthManager)
}
