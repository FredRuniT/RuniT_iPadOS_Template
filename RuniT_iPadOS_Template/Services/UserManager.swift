import Foundation
import SwiftUI

class User {
    var id: UUID
    var name: String
    var email: String
    var avatarURL: URL?
    
    init(id: UUID = UUID(), name: String, email: String, avatarURL: URL? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
    }
}

class UserManager: ObservableObject {
    @Published var currentUser: User?
    
    init() {
        // For demo purposes, create a sample user
        self.currentUser = User(
            name: "John Doe",
            email: "john.doe@example.com",
            avatarURL: URL(string: "https://randomuser.me/api/portraits/men/1.jpg")
        )
    }
    
    func signIn(email: String, password: String) {
        // Authentication logic would go here
        // For demo, just set the current user
        self.currentUser = User(
            name: "John Doe",
            email: email,
            avatarURL: URL(string: "https://randomuser.me/api/portraits/men/1.jpg")
        )
    }
    
    func signOut() {
        self.currentUser = nil
    }
} 