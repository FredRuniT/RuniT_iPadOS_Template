import SwiftUI

struct AppConstants {
    // App Information
    static let appName = "Finance Tracker"
    static let appVersion = "1.0.0"
    
    // UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 16
        static let standardPadding: CGFloat = 16
        static let largePadding: CGFloat = 24
        static let smallPadding: CGFloat = 8
        
        static let cardShadowRadius: CGFloat = 5
        static let cardShadowOpacity: CGFloat = 0.1
        
        static let minimumColumnWidth: CGFloat = 300
        static let sidebarWidth: CGFloat = 260
        
        static let animationDuration: Double = 0.3
    }
    
    // Colors
    struct Colors {
        static let primaryAccent = Color.appPrimaryBlue
        static let secondaryAccent = Color.appSuccessGreen
        static let tertiaryAccent = Color.appCautionOrange
        static let warningColor = Color.appDangerRed
        
        static let incomeGreen = Color.appSuccessGreen
        static let expenseRed = Color.appDangerRed
    }
    
    // Date Formats
    struct DateFormats {
        static let shortDate = "MM/dd/yy"
        static let mediumDate = "MMM d, yyyy"
        static let longDate = "MMMM d, yyyy"
        static let shortDateTime = "MM/dd/yy, h:mm a"
        static let fullDateTime = "MMMM d, yyyy 'at' h:mm a"
    }
    
    // Currency Formats
    struct CurrencyFormats {
        static let standard = "$%.2f"
        static let withoutCents = "$%.0f"
        static let withThousandsSeparator = "$%,.2f"
    }
    
    // Feature Flags
    struct FeatureFlags {
        static let enableAIAssistant = true
        static let enableFamilySharing = true
        static let enableDarkMode = true
        static let enableNotifications = true
    }
} 