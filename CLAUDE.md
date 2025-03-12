# RuniT iPadOS Template Development Guide

## Build & Run Commands
- Build and run: `Xcode Run button` or `Cmd+R`
- Clean build: `Cmd+Shift+K` 
- Test: `Cmd+U`
- Specific test: Select test in Xcode and press `Cmd+U`
- Build for iPad Pro 13-inch (M4) simulator:
  ```bash
  cd /Users/fredrickburns/Code_Repositories/RuniT_iPadOS_Template && xcodebuild clean build -scheme RuniT_iPadOS_Template -configuration Debug -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M4)'
  ```

## Project Information

### Log Files & Debugging
- Build logs: `/Users/fredrickburns/Library/Developer/Xcode/DerivedData/RuniT_iPadOS_Template-*/Logs/Build`
- Crash logs: `/Users/fredrickburns/Library/Logs/DiagnosticReports`
- Device logs: Use Console.app to access device logs for running simulators

### Important Files & Directories
- Main app entry: `/RuniT_iPadOS_Template/RuniT_iPadOS_TemplateApp.swift`
- Root view: `/RuniT_iPadOS_Template/ContentView.swift`
- Design System: `/RuniT_iPadOS_Template/DesignSystem/`
- Views: `/RuniT_iPadOS_Template/Views/`
- Models: `/RuniT_iPadOS_Template/Models/`
- Services: `/RuniT_iPadOS_Template/Services/`
- Configuration: `/RuniT_iPadOS_Template/SupabaseConfigs.xcconfig`

## Code Style Guidelines
- **Imports**: SwiftUI first, then other frameworks
- **Spacing**: 4 spaces for indentation
- **Naming**:
  - Types: CamelCase (BillsTableView, MonthlyBill)
  - Properties/methods: camelCase (monthlyAmount)
  - Colors: app-prefixed (appPrimaryBlue)
- **Architecture**: MVVM with services
- **Typography**: Use design system modifiers (.titleStyle(), .bodyStyle())
- **Colors**: Use ColorPalette.swift colors (appPrimaryBlue, appDangerRed)
- **Spacing**: Use Spacing constants (Spacing.md, Spacing.lg)
- **Components**: Use design system components when possible
- **Error handling**: Use sensible defaults, conditional UI display

## Important Development Recommendations
1. **ALWAYS verify build success before considering a task complete**
2. **Fix ALL build errors before marking a task as complete**
3. **DO NOT duplicate files or components that already exist in the project**
4. **ALWAYS check for existing components or variables before creating new ones**
5. **Maintain the project structure - add new files in their appropriate directories**
6. **Use consistent naming following the project conventions**
7. **When adding SwiftUI views, always test on iPad simulator in landscape orientation**
8. **Respect the navigation structure - app uses NavigationSplitView with sidebar**
9. **When modifying database-related code, ensure compatibility with the database schema**
10. **Implement proper error handling and loading states in UI components**

## Navigation Structure
- The app uses a two-column NavigationSplitView:
  - Left column: SidebarView with menu items
  - Right column: Detail content based on selection
- The sidebar can expand and collapse
- Navigation selection is managed through the SidebarItem enum

## Design System Components
The project includes several reusable components:
- Typography styles in Typography.swift
- Color palette in ColorPalette.swift
- Spacing constants in Spacing.swift
- UI components in DesignSystem/Components/

## Data Management
- FinanceManager: Manages financial data and transactions
- UserManager: Handles user authentication and profiles
- DatabaseService: Provides database connectivity
- ThemeManager: Controls app theming and appearance

## Common Issues & Solutions
- **Type-checking timeout**: Break complex SwiftUI views into smaller components
- **Missing components**: Check imports and ensure component visibility
- **Theme/color issues**: Use ColorPalette properties instead of direct Color references
- **Navigation issues**: Ensure proper SidebarItem usage and view hierarchy
- **Database connection errors**: Verify connection and authentication parameters