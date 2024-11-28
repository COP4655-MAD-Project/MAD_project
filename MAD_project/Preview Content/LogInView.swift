import SwiftUI

struct LogInView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Planorama")
                        .font(.system(size: 60, weight: .regular, design: .serif))
                        .italic()
                        .font(.largeTitle)

                    VStack {
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .foregroundColor(.black)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .foregroundColor(.black)
                    }
                    .textInputAutocapitalization(.never)
                    .padding(40)

                    HStack {
                        NavigationLink(destination: SignUpDetailsView()) {
                            Text("Sign Up")
                                .font(.headline)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button("Login") {
                            errorMessage = nil
                            authManager.signIn(email: email, password: password) { result in
                                switch result {
                                case .success:
                                    print("Login successful!")
                                case .failure(let error):
                                    errorMessage = error.localizedDescription
                                }
                            }
                        }
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    LogInView()
        .environmentObject(AuthManager())
}
