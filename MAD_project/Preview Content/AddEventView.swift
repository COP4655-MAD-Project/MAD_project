import SwiftUI

struct AddEventView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss // Used to close the sheet after adding an event
    @State private var eventName: String = ""
    @State private var eventType: String = "Birthday"
    @State private var eventDate: Date = Date()
    @State private var errorMessage: String?
    
    let eventTypes = ["Birthday", "Wedding", "Meeting", "Conference", "Party"]
    
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
                    Text("Add Event")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    // Input Fields
                    VStack(spacing: 15) {
                        // Event Name Input
                        TextField("Event Name", text: $eventName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .foregroundColor(.black)

                        // Event Type Picker
                        VStack(alignment: .leading) {
                            Text("Event Type")
                                .font(.headline)
                                .foregroundColor(.white)
                            Picker("Select Event Type", selection: $eventType) {
                                ForEach(eventTypes, id: \.self) { type in
                                    Text(type)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }

                        // Event Date Picker
                        VStack(alignment: .leading) {
                            Text("Event Date")
                                .font(.headline)
                                .foregroundColor(.white)
                            DatePicker("", selection: $eventDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)

                    // Add Event Button
                    Button(action: {
                        guard let userId = authManager.user?.uid else { return }
                        
                        let newEvent = Event(id: UUID().uuidString, name: eventName, eventType: eventType, eventDate: eventDate)
                        authManager.addEvent(userId: userId, event: newEvent) { result in
                            switch result {
                            case .success:
                                dismiss() // Close the sheet
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            Text("Add Event")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                    // Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    Spacer()
                }
            }
        }
    }
}
