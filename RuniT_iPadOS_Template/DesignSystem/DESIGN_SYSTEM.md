# RuniT Design System

This document provides detailed information about the design system used in the RuniT_iPadOS_Template application. The design system ensures consistency, accessibility, and a cohesive user experience throughout the application.

## Table of Contents

- [Color System](#color-system)
- [Typography](#typography)
- [Spacing](#spacing)
- [Components](#components)
- [Theme Management](#theme-management)
- [Usage Guidelines](#usage-guidelines)

## Color System

The color system is defined in `ColorPalette.swift` and provides a consistent color palette for the entire application.

### Primary Colors

| Color | Variable | Usage | Hex Value |
|-------|----------|-------|-----------|
| Primary Blue | `appPrimaryBlue` | Primary actions, links, and emphasis | #007AFF |
| Success Green | `appSuccessGreen` | Success states, positive values | #34C759 |
| Caution Orange | `appCautionOrange` | Warning states, approaching limits | #FF9500 |
| Danger Red | `appDangerRed` | Error states, destructive actions, negative values | #FF3B30 |

### Neutral Colors

| Color | Variable | Usage | Hex Value |
|-------|----------|-------|-----------|
| Dark Text | `appDarkText` | Primary text | #1C1C1E |
| Mid Text | `appMidText` | Secondary text | #48484A |
| Light Text | `appLightText` | Tertiary text | #8E8E93 |
| Ultra Light Text | `appUltraLightText` | Disabled text, placeholders | #C7C7CC |

### Semantic Colors

The color system includes convenience methods for financial contexts:

```swift
// Returns appropriate color based on financial amount
static func forAmount(_ amount: Double) -> Color {
    if amount < 0 {
        return appDangerRed
    } else if amount > 0 {
        return appSuccessGreen
    } else {
        return .primary
    }
}

// Returns color based on budget progress percentage
static func forBudgetProgress(_ percentage: Double) -> Color {
    switch percentage {
    case 0..<0.7:
        return appSuccessGreen
    case 0.7..<0.9:
        return appCautionOrange
    default:
        return appDangerRed
    }
}
```

### Dark Mode Support

All colors are defined with appropriate dark mode variants in the asset catalog.

## Typography

The typography system is defined in `Typography.swift` and provides consistent text styles throughout the application.

### Font Styles

| Style | Variable | Size | Weight | Design |
|-------|----------|------|--------|--------|
| Title Large | `.titleLarge` | 28pt | Bold | Default |
| Title Regular | `.titleRegular` | 22pt | Bold | Default |
| Title Small | `.titleSmall` | 17pt | Semibold | Default |
| Headline Regular | `.headlineRegular` | 15pt | Semibold | Default |
| Body Regular | `.bodyRegular` | 13pt | Regular | Default |
| Caption Regular | `.captionRegular` | 11pt | Regular | Default |
| Caption Small | `.captionSmall` | 10pt | Regular | Default |

### Financial Typography

Specialized typography for financial information:

| Style | Variable | Size | Weight | Design |
|-------|----------|------|--------|--------|
| Currency Large | `.currencyLarge` | 28pt | Bold | Monospaced |
| Currency Regular | `.currencyRegular` | 17pt | Medium | Monospaced |
| Currency Small | `.currencySmall` | 13pt | Regular | Monospaced |
| Percentage Regular | `.percentageRegular` | 13pt | Medium | Monospaced |

### Text Style Modifiers

Each typography style has a corresponding modifier for easy application:

```swift
// Title styles
.titleLargeStyle()  // Font: titleLarge, Color: appDarkText
.titleStyle()       // Font: titleRegular, Color: appDarkText
.titleSmallStyle()  // Font: titleSmall, Color: appDarkText

// Text styles
.headlineStyle()    // Font: headlineRegular, Color: appDarkText
.bodyStyle()        // Font: bodyRegular, Color: appDarkText
.captionStyle()     // Font: captionRegular, Color: appMidText
.captionSmallStyle() // Font: captionSmall, Color: appMidText

// Financial styles
.currencyLargeStyle()  // Font: currencyLarge
.currencyStyle()       // Font: currencyRegular
.currencySmallStyle()  // Font: currencySmall
.percentageStyle()     // Font: percentageRegular
```

## Spacing

The spacing system is defined in `Spacing.swift` and provides consistent spacing throughout the application.

### Base Units

All spacing values are multiples of the base unit (4pt):

| Variable | Value | Description |
|----------|-------|-------------|
| `base` | 4pt | Base unit |
| `xs` | 8pt | Extra small (2 × base) |
| `sm` | 12pt | Small (3 × base) |
| `md` | 16pt | Medium (4 × base) |
| `lg` | 24pt | Large (6 × base) |
| `xl` | 32pt | Extra large (8 × base) |
| `xxl` | 48pt | Extra extra large (12 × base) |

### Specialized Spacing

| Variable | Value | Usage |
|----------|-------|-------|
| `cardPadding` | 16pt | Standard padding inside cards |
| `listItemSpacing` | 12pt | Spacing between list items |
| `sectionSpacing` | 24pt | Spacing between sections |
| `contentSpacing` | 16pt | Spacing between content elements |

### Spacing Modifiers

```swift
.standardPadding()           // Padding of md (16pt) on all sides
.cardPadding()               // Padding of cardPadding on all sides
.standardHorizontalPadding() // Horizontal padding of md (16pt)
.standardVerticalPadding()   // Vertical padding of md (16pt)
.sectionSpacing()            // Bottom padding of sectionSpacing (24pt)
```

## Components

The design system includes reusable UI components to ensure consistency.

### Buttons

Defined in `Buttons.swift`:

- **PrimaryButton**: Main call-to-action buttons
  ```swift
  PrimaryButton(title: "Add Account") {
      // Action
  }
  ```

- **SecondaryButton**: Alternative or secondary actions
  ```swift
  SecondaryButton(title: "See Details") {
      // Action
  }
  ```

- **IconButton**: Icon-only buttons for compact actions
  ```swift
  IconButton(systemName: "plus") {
      // Action
  }
  ```

- **DangerButton**: Destructive actions
  ```swift
  DangerButton(title: "Delete") {
      // Action
  }
  ```

- **SectionHeader**: Section headers with optional action button
  ```swift
  SectionHeader(title: "Recent Transactions", buttonTitle: "View All") {
      // Action
  }
  ```

### Cards

Defined in `Cards.swift`:

- **StandardCard**: Basic card container
  ```swift
  StandardCard {
      Text("Content")
  }
  ```

- **AccountCard**: Display account information
  ```swift
  AccountCard(
      name: "Checking Account",
      institution: "Bank of America",
      balance: 2543.67,
      type: "Checking"
  )
  ```

- **TransactionCard**: Display transaction information
  ```swift
  TransactionCard(
      merchantName: "Starbucks",
      date: Date(),
      amount: -4.95,
      category: "Food"
  )
  ```

- **BudgetProgressCard**: Display budget progress
  ```swift
  BudgetProgressCard(
      spent: 750,
      total: 1000,
      category: "Dining"
  )
  ```

### Form Elements

Defined in `FormElements.swift`:

- **AppTextField**: Text input field
  ```swift
  AppTextField(label: "Name", placeholder: "Enter your name", text: $text)
  ```

- **AmountField**: Currency input field
  ```swift
  AmountField(label: "Amount", amount: $amount)
  ```

- **DatePickerField**: Date selection field
  ```swift
  DatePickerField(label: "Date", date: $date)
  ```

- **PickerField**: Selection field
  ```swift
  PickerField(label: "Category", selection: $selection, options: options)
  ```

- **ToggleField**: Boolean toggle field
  ```swift
  ToggleField(label: "Notifications", isOn: $isOn)
  ```

## Theme Management

The `ThemeManager` class provides centralized theme management:

```swift
class ThemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme?
    @Published var accentColor: Color = .appPrimaryBlue
    
    // Custom configuration options
    @Published var useUltraThinMaterial: Bool = true
    @Published var cornerRadiusSize: CornerRadiusSize = .medium
    @Published var animationsEnabled: Bool = true
    
    // ...
}
```

### ThemedCard

The `ThemedCard` component uses the theme manager to apply consistent styling:

```swift
ThemedCard {
    // Content
}
```

### Card Hover Effect

The `cardHoverEffect()` modifier adds interactive hover effects to cards:

```swift
AccountCard(/* ... */)
    .cardHoverEffect()
```

## Usage Guidelines

### Color Usage

- Use `appPrimaryBlue` for primary actions, links, and emphasis
- Use `appSuccessGreen` for success states and positive values
- Use `appCautionOrange` for warning states and approaching limits
- Use `appDangerRed` for error states, destructive actions, and negative values
- Use semantic color methods (`forAmount`, `forBudgetProgress`) for financial data

### Typography Usage

- Use title styles for headings and important information
- Use body styles for main content
- Use caption styles for supplementary information
- Use financial typography for currency and percentage values
- Apply text style modifiers consistently

### Spacing Usage

- Use the spacing constants for consistent layout
- Apply spacing modifiers for common spacing patterns
- Maintain consistent spacing between related elements
- Use appropriate spacing for different screen sizes

### Component Usage

- Use the provided components instead of creating custom ones
- Maintain consistent styling across similar components
- Follow the component API and documentation
- Extend components when necessary, maintaining design consistency

---

This design system documentation is a living document and will be updated as the design system evolves. 