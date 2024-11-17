//
//  AuthManager.swift
//  GroupProject1
//
//  Created by Cristian De Francesco on 11/14/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class AuthManager {
    var user: User?
    var isSignedIn: Bool = false

    let isMocked: Bool = false
    
    var userEmail: String? {
        isMocked ? "kingsley@dog.com" : user?.email
    }

    private var handle: AuthStateDidChangeListenerHandle?

    private let db = Firestore.firestore()

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isSignedIn = user != nil
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // Sign up method with added Firestore data saving
    func signUp(email: String, password: String, name: String, eventType: String, eventDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                // Firebase Authentication: Create user with email and password
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                user = authResult.user

                // Once sign up is successful, save additional details to Firestore
                saveUserDetails(userId: authResult.user.uid, email: email, name: name, eventType: eventType, eventDate: eventDate)
                
                // Call completion with success
                completion(.success(()))
            } catch let error {
                // Call completion with failure and pass the error
                completion(.failure(error))
            }
        }
    }

    // Method to save user details to Firestore
    private func saveUserDetails(userId: String, email: String, name: String, eventType: String, eventDate: Date) {
        // Reference to Firestore collection 'users'
        let userRef = db.collection("users").document(userId)
        
        let userData: [String: Any] = [
            "email": email,
            "name": name,
            "eventType": eventType,
            "eventDate": eventDate
        ]
        
        // Save data to Firestore
        userRef.setData(userData) { error in
            if let error = error {
                print("Error saving user details to Firestore: \(error.localizedDescription)")
            } else {
                print("User details saved successfully to Firestore")
            }
        }
    }

    // Sign in method (no change)
    func signIn(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                user = authResult.user
            } catch {
                print("Sign in failed: \(error)")
            }
        }
    }

    // Sign out method (no change)
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            print("Sign out failed: \(error)")
        }
    }
}
