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
                    .padding(.top, 40)

                // Timer Section
                VStack {
                    Text("Time Remaining")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)

                    Text(remainingTime)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.blue)
                        .onAppear {
                            calculateRemainingTime()
                        }
                }
                .padding(.top, 20)

                Spacer()

                // Bottom Buttons Section
                HStack(spacing: 22) {
                    NavigationLink(destination: WeatherView()) {
                        VStack {
                            Image(systemName: "cloud.sun.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            Text("Weather")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }

                    NavigationLink(destination: InvitationsView()) {
                        VStack {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            Text("Invites")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }

                    NavigationLink(destination: FoodView()) {
                        VStack {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            Text("Food List")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }

                    NavigationLink(destination: TasksView()) {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            Text("To-Do")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }

                    NavigationLink(destination: CalendarView()) {
                        VStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            Text("Calendar")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .background(Color.brown.opacity(0.8))
                .cornerRadius(15)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
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
