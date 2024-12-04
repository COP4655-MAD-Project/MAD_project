import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject var authManager: AuthManager
    let event: Event

    @State private var remainingTime: String = ""

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                // Event Name
                Text(event.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 30)

                // Timer Section
                VStack {
                    Text("Time Remaining:")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)

                    Text(remainingTime)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black) // Updated color to black
                        .onAppear {
                            calculateRemainingTime()
                        }
                }
                .padding(.top, 8)

                Spacer()

                // Buttons Section
                VStack(spacing: 20) {
                    HStack(spacing: 40) {
                        NavigationLink(destination: WeatherView()) {
                            ButtonView(icon: "cloud.sun.fill", label: "Weather")
                        }
                        NavigationLink(destination: InvitationsView(eventId: event.id)) {
                            ButtonView(icon: "person.3.fill", label: "Invitations")
                        }
                    }

                    HStack(spacing: 40) {
                        NavigationLink(destination: FoodView(currentEventId: event.id, authManager: authManager)) {
                            ButtonView(icon: "fork.knife", label: "Food List")
                        }
                        NavigationLink(destination: TasksView(currentEventId: event.id, authManager: authManager)) {
                            ButtonView(icon: "checkmark.circle.fill", label: "To-Do")
                        }
                    }
                }
                .padding()
                .background(Color.brown.opacity(0.8))
                .cornerRadius(15)
                .padding(.horizontal, 20)

                Spacer() // Ensure the buttons stay in the center
            }
        }
    }

    /// Calculate and display the remaining time until the event date
    private func calculateRemainingTime() {
        let now = Date()
        if event.eventDate > now {
            let remainingInterval = event.eventDate.timeIntervalSince(now)
            let days = Int(remainingInterval / 86400)
            let hours = Int((remainingInterval.truncatingRemainder(dividingBy: 86400)) / 3600)
            remainingTime = "\(days) days and \(hours) hours"
        } else {
            remainingTime = "Event has passed."
        }
    }
}

/// Reusable Button View
struct ButtonView: View {
    let icon: String
    let label: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.white)
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 120, height: 120)
        .background(Color.brown.opacity(0.9))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    let sampleEvent = Event(
        id: "1",
        name: "John's Birthday",
        eventType: "Birthday",
        eventDate: Date().addingTimeInterval(86400)
    )
    EventDetailView(event: sampleEvent)
        .environmentObject(AuthManager())
}
