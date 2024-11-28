import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject var authManager: AuthManager
    let event: Event

    @State private var remainingTime: String = ""
    @State private var navigateTo: String? = nil // State to handle navigation

    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                Text(event.name)
                    .font(.largeTitle)
                    .padding()
                
                Text("Event Type: \(event.eventType)")
                    .font(.title2)
                
                Text("Event Date: \(event.eventDate, formatter: dateFormatter)")
                    .font(.title3)
                
                Text("Time Remaining: \(remainingTime)")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .onAppear {
                        calculateRemainingTime()
                    }
                
                // Navigation buttons
                NavigationLink(destination: WeatherView(), tag: "Weather", selection: $navigateTo) {
                    EmptyView()
                }
                NavigationLink(destination: InvitationsView(), tag: "Invitations", selection: $navigateTo) {
                    EmptyView()
                }
                NavigationLink(destination: FoodView(), tag: "FoodList", selection: $navigateTo) {
                    EmptyView()
                }
                NavigationLink(destination: TasksView(), tag: "ToDoList", selection: $navigateTo) {
                    EmptyView()
                }
                
                Button("Check Weather") {
                    navigateTo = "Weather"
                }
                .buttonStyle(.borderedProminent)
                
                Button("Manage Invitations") {
                    navigateTo = "Invitations"
                }
                .buttonStyle(.borderedProminent)
                
                Button("Manage Food List") {
                    navigateTo = "FoodList"
                }
                .buttonStyle(.borderedProminent)
                
                Button("To-Do List") {
                    navigateTo = "ToDoList"
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
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

    /// Date formatter for event date
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

#Preview {
    let sampleEvent = Event(id: "1", name: "John's Birthday", eventType: "Birthday", eventDate: Date().addingTimeInterval(86400))
    EventDetailView(event: sampleEvent)
        .environmentObject(AuthManager())
}
