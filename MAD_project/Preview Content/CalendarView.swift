import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @State private var events: [String] = []

    var body: some View {
        ZStack {
            GradientBackground() // Use the reusable gradient background

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
                    Text("Events")
                        .font(.headline)
                        .padding(.bottom, 5)
                        .foregroundColor(.black)

                    if events.isEmpty {
                        Text("No events for the selected date.")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        List(events, id: \.self) { event in
                            Text(event)
                                .foregroundColor(.black)
                        }
                        .listStyle(.plain)
                        .background(Color.clear)
                    }

                    // Add Event Button
                    Button(action: {
                        addEvent()
                    }) {
                        Text("Add Event")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
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
        .navigationTitle("Calendar View")
    }

    // Load events from UserDefaults
    private func loadEvents(for date: Date) {
        let dateKey = formattedDate(date)
        if let savedEvents = UserDefaults.standard.array(forKey: dateKey) as? [String] {
            events = savedEvents
        } else {
            events = []
        }
    }

    // Add an event for the selected date
    private func addEvent() {
        let newEvent = "Event \(events.count + 1)"
        events.append(newEvent)

        let dateKey = formattedDate(selectedDate)
        UserDefaults.standard.set(events, forKey: dateKey)
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
    CalendarView()
}
