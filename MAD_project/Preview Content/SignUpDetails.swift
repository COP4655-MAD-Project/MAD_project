import SwiftUI

struct SignUpDetailsView: View {
    @EnvironmentObject var authManager: AuthManager // Inject AuthManager as an environment object

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedEventType: String = "Birthday"
    @State private var eventDate: Date = Date()

    @State private var errorMessage: String? // To display any errors

    let eventTypes = ["Birthday", "Wedding", "Meeting", "Conference", "Party"]

    var body: some View {
        VStack {
            Text("Enter Your Event Details")
                .font(.largeTitle)
                .padding(.top, 100)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading) {
                TextField("Enter your name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    .foregroundColor(.black)

                TextField("Enter your email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    .keyboardType(.emailAddress)
                    .foregroundColor(.black)

                SecureField("Enter your password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    .foregroundColor(.black)

                Picker("Select event type", selection: $selectedEventType) {
                    ForEach(eventTypes, id: \.self) { event in
                        Text(event)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))

                DatePicker("Select event date", selection: $eventDate, displayedComponents: .date)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            }
            .padding()

            Spacer()

            Button("Submit") {
                errorMessage = nil
                // Call the `signUp` method in `AuthManager`
                authManager.signUp(
                    email: email,
                    password: password,
                    name: name,
                    eventType: selectedEventType,
                    eventDate: eventDate
                ) { result in
                    switch result {
                    case .success:
                        print("Sign-up successful!")
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding([.bottom, .top], 20)
            .frame(maxWidth: .infinity)

            // Display error message if it exists
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SignUpDetailsView()
        .environmentObject(AuthManager())
}
