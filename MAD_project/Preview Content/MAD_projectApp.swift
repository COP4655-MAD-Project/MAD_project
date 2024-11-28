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
            if authManager.user != nil {
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
}
