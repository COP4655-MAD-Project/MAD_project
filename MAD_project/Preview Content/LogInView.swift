import SwiftUI

struct LogInView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack { // Ensure the view is wrapped in a NavigationStack
            ZStack {
                GradientBackground()

                VStack(spacing: 20) {
                    // Branding
                    Text("Planorama")
                        .font(.system(size: 50, weight: .bold, design: .serif))
                        .italic()
                        .foregroundColor(.white)
                        .padding(.bottom, 30)

                    // Login Form
                    VStack(spacing: 15) {
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

                    // Login Button
                    Button(action: {
                        errorMessage = nil
                        authManager.signIn(email: email, password: password) { result in
                            switch result {
                            case .success:
                                print("Login successful!")
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }) {
                        Text("Log In")
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

                    // Navigation to Sign Up
                    Spacer()
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                        NavigationLink(destination: SignUpDetailsView()) {
                            Text("Sign Up")
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
}

#Preview {
    LogInView()
        .environmentObject(AuthManager())
}
