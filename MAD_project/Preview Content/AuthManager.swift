import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var isSignedIn: Bool = false
    @Published var userEvents: [Event] = []

    private var handle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.user = user
                self?.isSignedIn = user != nil
                if let user = user {
                    self?.fetchUserEvents(userId: user.uid)
                }
            }
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }


    func signUp(email: String, password: String, name: String, eventType: String, eventDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                DispatchQueue.main.async { self.user = authResult.user }
                saveUserDetails(userId: authResult.user.uid, email: email, name: name, eventType: eventType, eventDate: eventDate)
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
                DispatchQueue.main.async { self.user = authResult.user }
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
                self.userEvents = []
            }
        } catch {
            print("Sign out failed: \(error)")
        }
    }

    
    
    
    private func saveUserDetails(userId: String, email: String, name: String, eventType: String, eventDate: Date) {
        let userRef = db.collection("users").document(userId)
        let userData: [String: Any] = [
            "email": email,
            "name": name,
            "eventType": eventType,
            "eventDate": eventDate
        ]
        userRef.setData(userData) { error in
            if let error = error {
                print("Error saving user details: \(error.localizedDescription)")
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

    func fetchEventInvitations(userId: String, eventId: String, completion: @escaping ([Guest]) -> Void) {
        db.collection("users").document(userId).collection("events").document(eventId).collection("invitations").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching invitations: \(error.localizedDescription)")
                completion([])
                return
            }

            let guests: [Guest] = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                guard
                    let name = data["name"] as? String,
                    let statusString = data["status"] as? String,
                    let status = GuestStatus(rawValue: statusString)
                else {
                    return nil
                }
                return Guest(name: name, status: status)
            } ?? []
            
            completion(guests)
        }
    }

    func saveEventInvitations(userId: String, eventId: String, guests: [Guest], completion: @escaping (Result<Void, Error>) -> Void) {
        let batch = db.batch()
        let invitationsRef = db.collection("users").document(userId).collection("events").document(eventId).collection("invitations")

        guests.forEach { guest in
            let guestRef = invitationsRef.document(guest.id.uuidString)
            let data: [String: Any] = [
                "name": guest.name,
                "status": guest.status.rawValue
            ]
            batch.setData(data, forDocument: guestRef)
        }

        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    func addEvent(userId: String, event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventRef = db.collection("users").document(userId).collection("events").document(event.id)
        
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
                self.userEvents.append(event)
                completion(.success(()))
            }
        }
    }

    
    func deleteEvent(userId: String, event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventRef = db.collection("users").document(userId).collection("events").document(event.id)
        
        // First delete all invitations in the subcollection
        eventRef.collection("invitations").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            let batch = self.db.batch()
            
            snapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // Now delete the event itself
                eventRef.delete { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        DispatchQueue.main.async {
                            // Update local state
                            self.userEvents.removeAll { $0.id == event.id }
                            completion(.success(()))
                        }
                    }
                }
            }
        }
    }
    
}


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


struct Guest: Identifiable {
    let id = UUID()
    var name: String
    var status: GuestStatus
}

enum GuestStatus: String, CaseIterable {
    case attending = "Attending"
    case notAttending = "Not Attending"
    case noAnswer = "N/A"
}

