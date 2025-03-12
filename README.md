# RuniT_iPadOS_Template

A modern iPadOS financial tracking application template built with SwiftUI, featuring a three-column layout, custom design system, and comprehensive financial management features.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Design System](#design-system)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Development Guidelines](#development-guidelines)
- [Contributing](#contributing)

## Overview

RuniT_iPadOS_Template is a comprehensive financial management application template designed specifically for iPadOS. It leverages SwiftUI's latest features to provide a responsive, intuitive user interface with a three-column layout optimized for iPad screens. The template includes a complete design system, state management architecture, and modular components that can be easily customized and extended.

## Features

- **Three-Column Layout**: Sidebar navigation, content list, and detail view for efficient information hierarchy
- **Comprehensive Financial Tools**: Dashboard, accounts, transactions, budgeting, goals, and more
- **Custom Design System**: Consistent typography, color palette, spacing, and components
- **Responsive Design**: Adapts to different iPad sizes and orientations
- **Dark Mode Support**: Full support for both light and dark appearance modes
- **Accessibility**: VoiceOver support and dynamic type compatibility
- **SwiftUI Best Practices**: Leverages the latest SwiftUI features and patterns

## Project Structure

```
RuniT_iPadOS_Template/
├── Assets.xcassets/         # Images and color assets
├── DesignSystem/            # Design system components
│   ├── ColorPalette.swift   # Custom color definitions
│   ├── Typography.swift     # Font styles and text modifiers
│   ├── Spacing.swift        # Spacing constants and modifiers
│   ├── ThemeManager.swift   # Theme management and customization
│   └── Components/          # Reusable UI components
│       ├── Buttons.swift    # Button variants
│       ├── Cards.swift      # Card components
│       └── FormElements.swift # Form input elements
├── Extensions/              # Swift and SwiftUI extensions
├── Models/                  # Data models
├── Services/                # Business logic and data services
│   └── FinanceManager.swift # Financial data management
├── Utils/                   # Utility functions and constants
├── ViewModels/              # View models for complex views
├── Views/                   # Application views
│   ├── ContentView.swift    # Main container view
│   ├── Sidebar/            # Sidebar navigation views
│   ├── ContentList/        # Middle column content views
│   ├── Detail/             # Detail views
│   └── Dashboard/          # Dashboard-specific views
└── RuniT_iPadOS_TemplateApp.swift # App entry point
```

## Design System

The application includes a comprehensive design system to ensure consistency across the UI.

### Colors

The color system is defined in `ColorPalette.swift` and includes:

- **Primary Colors**:
  - `appPrimaryBlue`: Main brand color used for primary actions and emphasis
  - `appSuccessGreen`: Used for positive values, success states
  - `appCautionOrange`: Used for warnings and caution states
  - `appDangerRed`: Used for errors, negative values, and destructive actions

- **Neutral Colors**:
  - `appDarkText`: Primary text color
  - `appMidText`: Secondary text color
  - `appLightText`: Tertiary text color
  - `appUltraLightText`: Subtle text and disabled states

- **Convenience Methods**:
  - `forAmount(_:)`: Returns appropriate color based on financial amount
  - `forBudgetProgress(_:)`: Returns color based on budget progress percentage

### Typography

Typography is defined in `Typography.swift` with consistent text styles:

- **Title Styles**: Large, regular, and small title variants
- **Text Styles**: Headline, body, and caption variants
- **Financial Typography**: Specialized styles for currency and percentage values

Each typography style has a corresponding modifier for easy application:
```swift
Text("Dashboard")
    .titleLargeStyle()
```

### Spacing

Consistent spacing is defined in `Spacing.swift`:

- Base unit: 4pt
- Standard spacings: xs (8pt), sm (12pt), md (16pt), lg (24pt), xl (32pt), xxl (48pt)
- Specialized spacing for specific use cases

### Components

Reusable UI components include:

- **Cards**: Standard card, account card, transaction card, budget progress card
- **Buttons**: Primary, secondary, icon, and danger buttons
- **Form Elements**: Text fields, amount fields, date pickers, and toggles
- **ThemedCard**: Card with theme-aware styling and hover effects

## Architecture

The application follows a modified MVVM (Model-View-ViewModel) architecture:

- **Models**: Data structures representing domain entities
- **Views**: SwiftUI views for UI presentation
- **ViewModels**: Business logic and state management for complex views
- **Services**: Data management and business operations

### State Management

- **Environment Objects**: App-wide state using SwiftUI's environment
- **ObservableObject**: Local state management with Combine framework
- **ThemeManager**: Centralized theme management

### Navigation

- **NavigationSplitView**: Three-column navigation structure
- **SidebarItem Enum**: Typed navigation destinations
- **Programmatic Navigation**: State-based navigation control

## Getting Started

### Requirements

- Xcode 15.0+
- iOS/iPadOS 17.0+
- Swift 5.9+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/RuniT_iPadOS_Template.git
cd RuniT_iPadOS_Template
```

2. Open the project in Xcode:
```bash
open RuniT_iPadOS_Template.xcodeproj
```

3. Build and run the application on your iPad or iPad simulator.

## Development Guidelines

### Coding Style

- Follow Swift API Design Guidelines
- Use SwiftUI best practices
- Maintain separation of concerns between views, models, and business logic
- Document public APIs and complex logic

### Adding New Features

1. Create appropriate models in the Models directory
2. Implement business logic in Services or ViewModels
3. Create UI components in the Views directory
4. Update navigation if needed

### Theming

When adding new UI elements:

1. Use the design system components when possible
2. For colors, use the defined color palette in `ColorPalette.swift`
3. For text styling, use the typography modifiers
4. For spacing, use the constants defined in `Spacing.swift`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

© 2025 RuniT. All rights reserved. 