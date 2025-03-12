//
//  RuniT_iPadOS_TemplateApp.swift
//  RuniT_iPadOS_Template
//
//  Created by Fredrick Burns on 3/12/25.
//

import SwiftUI
import SwiftData

@main
struct RuniT_iPadOS_TemplateApp: App {
    @StateObject private var userManager = UserManager()
    @StateObject private var financeManager = FinanceManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .environmentObject(financeManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
