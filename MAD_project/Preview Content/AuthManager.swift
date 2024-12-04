//AuthManager


import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var isSignedIn: Bool = false
    @Published var userEvents: [Event] = [] // Store events for the user

    private var handle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.user = user
                self?.isSignedIn = user != nil
                if let user = user {
                    self?.fetchUserEvents(userId: user.uid) // Fetch events when the user logs in
                }
            }
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - User Authentication

    func signUp(
        email: String,
        password: String,
        name: String,
        eventType: String,
        eventDate: Date,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                DispatchQueue.main.async {
                    self.user = authResult.user
                }
                saveUserDetails(
                    userId: authResult.user.uid,
                    email: email,
                    name: name,
                    eventType: eventType,
                    eventDate: eventDate
                )
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                DispatchQueue.main.async {
                    self.user = authResult.user
                }
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.user = nil
                self.userEvents = [] // Clear events on sign out
            }
        } catch {
            print("Sign out failed: \(error)")
        }
    }

    // MARK: - Firestore Interaction

    private func saveUserDetails(
        userId: String,
        email: String,
        name: String,
        eventType: String,
        eventDate: Date
    ) {
        let userRef = db.collection("users").document(userId)
        let userData: [String: Any] = [
            "email": email,
            "name": name,
            "eventType": eventType,
            "eventDate": eventDate
        ]
        userRef.setData(userData) { error in
            if let error = error {
                print("Error saving user details to Firestore: \(error.localizedDescription)")
            } else {
                print("User details saved successfully to Firestore")
            }
        }
    }

    func fetchUserEvents(userId: String) {
        db.collection("users").document(userId).collection("events").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            self?.userEvents = documents.compactMap { doc in
                let data = doc.data()
                guard
                    let id = doc.documentID as String?,
                    let name = data["name"] as? String,
                    let eventType = data["eventType"] as? String,
                    let timestamp = data["eventDate"] as? Timestamp
                else {
                    return nil
                }
                return Event(id: id, name: name, eventType: eventType, eventDate: timestamp.dateValue())
            }
        }
    }

    func addEvent(userId: String, event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventRef = db.collection("users").document(userId).collection("events").document()

        let eventData: [String: Any] = [
            "name": event.name,
            "eventType": event.eventType,
            "eventDate": event.eventDate
        ]

        eventRef.setData(eventData) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            DispatchQueue.main.async {
                self.userEvents.append(Event(id: eventRef.documentID, name: event.name, eventType: event.eventType, eventDate: event.eventDate))
                completion(.success(()))
            }
        }
    }
}

// MARK: - Event Model

struct Event: Identifiable, Hashable {
    let id: String
    let name: String
    let eventType: String
    let eventDate: Date

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }
}

