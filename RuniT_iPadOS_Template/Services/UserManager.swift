import Foundation
import SwiftUI
import SwiftData

// This is a simple profile representation that UserManager will expose
// The full detailed User model is in SwiftDataModel.swift
class UserProfile {
    var id: UUID
    var displayName: String
    var email: String
    var avatarURL: URL?
    
    init(id: UUID = UUID(), displayName: String, email: String, avatarURL: URL? = nil) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.avatarURL = avatarURL
    }
    
    // Convert from SwiftData User model to UserProfile
    init(from user: User) {
        self.id = user.id
        self.displayName = user.displayName ?? "\(user.firstName ?? "") \(user.lastName ?? "")".trimmingCharacters(in: .whitespaces)
        self.email = user.email
        self.avatarURL = user.avatarUrl != nil ? URL(string: user.avatarUrl!) : nil
    }
}

class UserManager: ObservableObject {
    @Published var currentUser: UserProfile?
    @Published var isAuthenticated = false
    
    init() {
        // For demo purposes, create a sample user
        self.currentUser = UserProfile(
            displayName: "John Doe",
            email: "john.doe@example.com",
            avatarURL: URL(string: "https://randomuser.me/api/portraits/men/1.jpg")
        )
        self.isAuthenticated = true
    }
    
    func signIn(email: String, password: String) {
        // Authentication logic would go here
        // For demo, just set the current user
        self.currentUser = UserProfile(
            displayName: "John Doe",
            email: email,
            avatarURL: URL(string: "https://randomuser.me/api/portraits/men/1.jpg")
        )
        self.isAuthenticated = true
    }
    
    func signOut() {
        self.currentUser = nil
        self.isAuthenticated = false
    }
    
    // Create or update a User in SwiftData
    func saveUserToSwiftData(modelContext: ModelContext) {
        guard let profile = currentUser else { return }
        
        // Check if user already exists
        let predicate = #Predicate<User> { user in
            user.id == profile.id
        }
        
        let descriptor = FetchDescriptor<User>(predicate: predicate)
        
        do {
            let existingUsers = try modelContext.fetch(descriptor)
            
            if let existingUser = existingUsers.first {
                // Update existing user
                existingUser.email = profile.email
                existingUser.displayName = profile.displayName
                existingUser.avatarUrl = profile.avatarURL?.absoluteString
                existingUser.updatedAt = Date()
            } else {
                // Create new user
                let user = User(
                    id: profile.id,
                    email: profile.email,
                    firstName: profile.displayName.components(separatedBy: " ").first,
                    lastName: profile.displayName.components(separatedBy: " ").dropFirst().joined(separator: " "),
                    displayName: profile.displayName,
                    avatarUrl: profile.avatarURL?.absoluteString
                )
                modelContext.insert(user)
            }
            
            try modelContext.save()
        } catch {
            print("Error saving user to SwiftData: \(error)")
        }
    }
    
    // Load a user from SwiftData
    func loadUserFromSwiftData(modelContext: ModelContext, id: UUID) {
        let predicate = #Predicate<User> { user in
            user.id == id
        }
        
        let descriptor = FetchDescriptor<User>(predicate: predicate)
        
        do {
            let users = try modelContext.fetch(descriptor)
            if let user = users.first {
                self.currentUser = UserProfile(from: user)
                self.isAuthenticated = true
            }
        } catch {
            print("Error loading user from SwiftData: \(error)")
        }
    }
} 