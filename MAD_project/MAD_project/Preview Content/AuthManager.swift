//  AuthManager.swift
//  GroupProject1
//
//  Created by Cristian De Francesco on 11/14/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?
    
    private var handle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()
    
    init() {
        // Listen for authentication state changes
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.user = user
                self?.isAuthenticated = user != nil
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
                DispatchQueue.main.async {
                    self.user = authResult.user
                }
                saveUserDetails(userId: authResult.user.uid, email: email, name: name, eventType: eventType, eventDate: eventDate)
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
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
                print("Error saving user details to Firestore: \(error.localizedDescription)")
            } else {
                print("User details saved successfully to Firestore")
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                DispatchQueue.main.async {
                    self.user = authResult.user
                }
            } catch {
                print("Sign in failed: \(error)")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.user = nil
            }
        } catch {
            print("Sign out failed: \(error)")
        }
    }
}
