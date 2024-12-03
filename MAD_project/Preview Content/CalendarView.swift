import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var selectedDate: Date = Date()
    @State private var dailyEvents: [Event] = []

    var body: some View {
        ZStack {
            GradientBackground() // Reusable gradient background

            VStack {
                // Calendar Picker
                DatePicker(
                    "Select a date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
                .onChange(of: selectedDate) { newDate in
                    loadEvents(for: newDate)
                }

                // Events Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Events on \(formattedDate(selectedDate))")
                        .font(.headline)
                        .padding(.bottom, 5)
                        .foregroundColor(.black)

                    if dailyEvents.isEmpty {
                        Text("No events for the selected date.")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        List(dailyEvents, id: \.id) { event in
                            VStack(alignment: .leading) {
                                Text(event.name)
                                    .font(.headline)
                                Text("Type: \(event.eventType)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .listStyle(.plain)
                        .background(Color.clear)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding()
            }
        }
        .onAppear {
            loadEvents(for: selectedDate) // Load events on view load
        }
        .navigationTitle("Calendar")
    }

    // Load events for the selected date
    private func loadEvents(for date: Date) {
        let formatted = formattedDate(date)
        dailyEvents = authManager.userEvents.filter { formattedDate($0.eventDate) == formatted }
    }

    // Format date to "yyyy-MM-dd"
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

// Reusable Gradient Background
struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    let mockAuthManager = AuthManager()
    mockAuthManager.userEvents = [
        Event(id: "1", name: "Birthday Party", eventType: "Birthday", eventDate: Date()),
        Event(id: "2", name: "Meeting", eventType: "Work", eventDate: Date().addingTimeInterval(86400))
    ]
    return CalendarView()
        .environmentObject(mockAuthManager)
}
