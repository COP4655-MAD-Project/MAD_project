import SwiftUI
import FirebaseCore

@main
struct MAD_project: App {
    @StateObject private var authManager = AuthManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        if authManager.isSignedIn {
            NavigationStack {
                MainPlannerView()
                    .environmentObject(authManager)
            }
        } else {
            LogInView()
                .environmentObject(authManager)
        }
    }
}

