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
    @StateObject private var themeManager = ThemeManager()
    @State private var isSidebarVisible = true
    
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
                .environment(\.themeManager, themeManager)
                .environment(\.colorScheme, themeManager.colorScheme ?? .light)
                .accentColor(themeManager.accentColor)
                .onAppear {
                    // Set initial sidebar visibility based on device orientation
                    let orientation = UIDevice.current.orientation
                    isSidebarVisible = orientation.isLandscape
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    // Update sidebar visibility when orientation changes
                    let orientation = UIDevice.current.orientation
                    if orientation.isLandscape || orientation.isPortrait {
                        isSidebarVisible = orientation.isLandscape
                    }
                }
        }
        .modelContainer(sharedModelContainer)
        .commands {
            SidebarCommands()
            
            CommandGroup(after: .sidebar) {
                Button("Toggle Sidebar") {
                    isSidebarVisible.toggle()
                    NotificationCenter.default.post(name: NSNotification.Name("ToggleSidebar"), object: nil)
                }
                .keyboardShortcut("[", modifiers: [.command])
            }
        }
    }
}
