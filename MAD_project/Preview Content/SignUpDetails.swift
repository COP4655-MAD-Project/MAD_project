import SwiftUI

struct SignUpDetailsView: View {
    @EnvironmentObject var authManager: AuthManager

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 20) {
                // Branding
                Text("Planorama")
                    .font(.system(size: 50, weight: .bold, design: .serif))
                    .italic()
                    .foregroundColor(.white)
                    .padding(.bottom, 30)

                // Form Fields
                VStack(spacing: 15) {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 30)

                // Submit Button
                Button(action: {
                    errorMessage = nil
                    authManager.signUp(
                        email: email,
                        password: password,
                        name: name,
                        eventType: "N/A",
                        eventDate: Date()
                    ) { result in
                        switch result {
                        case .success:
                            print("Sign-up successful!")
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 30)

                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding()
                }

                // Navigation to Log In
                Spacer()
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.white)
                    NavigationLink(destination: LogInView()) {
                        Text("Log In")
                            .foregroundColor(.brown)
                            .fontWeight(.bold)
                    }
                }
                .padding(.top, 10)

                Spacer()
            }
        }
    }
}

#Preview {
    SignUpDetailsView()
        .environmentObject(AuthManager())
}

    
    
    /*
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
*/
