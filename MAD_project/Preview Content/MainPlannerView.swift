import SwiftUI

struct MainPlannerView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isAddingEvent = false

    var body: some View {
        NavigationStack {
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Your Events")
                        .font(.largeTitle)
                        .padding()
                    
                    if authManager.userEvents.isEmpty {
                        Text("No events yet. Add your first event!")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List(authManager.userEvents) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                VStack(alignment: .leading) {
                                    Text(event.name)
                                        .font(.headline)
                                    // Text("Type: \(event.eventType)")
                                    //          .font(.subheadline)
                                    Text("Date: \(event.eventDate, formatter: dateFormatter)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: signOut) {
                            Text("Sign Out")
                                .foregroundColor(.red)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isAddingEvent = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                        }
                    }
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

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
