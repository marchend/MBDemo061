# AcmeBank — Agent Context

## Project Overview
AcmeBank is an iOS 17+ banking app built in Swift + SwiftUI following an MVVM + Coordinator
architecture. It will let customers view accounts, review transactions, initiate transfers,
pay bills, and manage cards — all authenticated via Okta OIDC. Today's bootstrap ships the
runnable shell; all feature work lands in follow-up PRs.

## Tech Stack
| Item | Value |
|---|---|
| Platform | iOS 17+, Swift 5.10 |
| UI Framework | SwiftUI (`@main App`, `WindowGroup`) |
| Architecture | MVVM + Coordinator (`NavigationStack`) |
| Auth | Okta OIDC (`okta-mobile-swift` 2.x) — deferred |
| Networking | `URLSession` + `async/await` — deferred |
| DI | Constructor injection (no service locator) |
| Notifications | `NotificationCenter` (typed wrappers) — deferred |
| Test runner | XCTest (unit) + XCUITest (critical flows) |
| Project file | XcodeGen `project.yml` (never edit `.pbxproj`) |
| Bundle ID | `com.acmebank.mobile` |
| Min Xcode | 16.0 |

## How to Run Locally
```bash
./setup.sh           # installs XcodeGen, generates .xcodeproj, opens Xcode
# — or manually —
brew install xcodegen && xcodegen generate
open AcmeBank.xcodeproj
# Press ⌘R targeting any iOS 17 simulator
```

## How to Run Tests
```bash
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```
> Lint: `swiftlint` (`.swiftlint.yml` — deferred, added with first feature PR)

## Key Directory Structure
```
AcmeBank/
├── App/                  # @main entry + RootView + AppCoordinator (deferred)
├── Core/
│   ├── Auth/             # AuthService, KeychainStore, UserSession (deferred)
│   ├── Networking/       # APIClient, APIRouter, APIError (deferred)
│   ├── Notifications/    # AppNotification, NotificationPublisher (deferred)
│   └── Extensions/       # Decimal+Currency, Date+Greeting (deferred)
├── Domain/
│   ├── Models/           # Account, Transaction, Customer, TransferRequest (deferred)
│   └── Repositories/     # Protocol-only; no implementations here (deferred)
├── Data/
│   ├── Remote/           # APIRepository implementations (deferred)
│   └── Mock/             # MockRepository implementations (deferred)
├── Features/
│   ├── Login/            # LoginCoordinator, LoginView, LoginViewModel (deferred)
│   ├── Home/             # HomeCoordinator, HomeView, HomeViewModel (deferred)
│   ├── Accounts/         # (deferred)
│   ├── Transfer/         # (deferred)
│   └── Cards/            # (deferred)
├── DesignSystem/         # Colors.swift, Typography.swift (deferred)
├── Resources/            # Assets.xcassets, PrivacyInfo.xcprivacy
└── ContentView.swift     # Hello-World placeholder (replaced in Login PR)
AcmeBankTests/            # XCTest unit tests
AcmeBankUITests/          # XCUITest critical-flow tests (deferred)
project.yml               # XcodeGen source of truth
setup.sh                  # One-shot post-clone setup
```

## Planned Architecture (from spec)

### MVVM + Coordinator
- **View** — SwiftUI struct; renders `@Published` state; zero business logic.
- **ViewModel** — `final class: ObservableObject`; holds `@Published` state; calls repos.
- **Coordinator** — `ObservableObject`; owns `NavigationPath`; creates child Views + VMs.
- **Repository protocols** in `Domain/`; concrete types in `Data/`. VMs depend only on protocols.
- *(implemented in this PR)* — `AcmeBankApp.swift` + `ContentView.swift` placeholder
- *(deferred — future PR)* — full coordinator tree, all feature Views/ViewModels/Coordinators

### Authentication — Okta OIDC *(deferred — future PR)*
- `AuthServiceProtocol`: `signIn()`, `signOut()`, `refreshTokenIfNeeded()`
- Tokens persisted to Keychain via `KeychainStore`; never stored in `UserDefaults`
- `UserSession` value type injected through coordinators
- `RequestInterceptor` refreshes token before every request; posts `sessionExpired` on failure
- **Keychain note:** every `SecItem*` query MUST include `kSecUseDataProtectionKeychain: true`
  for CI simulator compatibility (`CODE_SIGNING_ALLOWED=NO`).

### Networking *(deferred — future PR)*
- `APIClient` wraps `URLSession` with `async/await`; decodes via `JSONDecoder` (snake_case + iso8601)
- `APIRouter` enum with typed endpoints; `API_BASE_URL` injected via xcconfig (never hardcoded)
- `APIError` typed enum: `.unauthorized`, `.clientError`, `.serverError`, `.networkUnavailable`

### Notifications *(deferred — future PR)*
- `AppNotification` enum of typed `Notification.Name` constants (no magic strings)
- `NotificationPublisher.post(_:userInfo:)` static helper
- Subscriptions belong in coordinators (Combine `sink`), never in ViewModels

### Design System *(deferred — future PR)*
- `Color` extensions: `acmeNavy`, `acmeBackground`, `acmeSurface`, `acmeText`, etc.
- `Font` extensions: `acmeTitle`, `acmeHeadline`, `acmeBody`, `acmeCaption`, `acmeMonoBalance`
- All fonts must support Dynamic Type

### Testing Conventions *(deferred — future PR)*
- XCTest (unit): every ViewModel → `*Tests.swift` in `AcmeBankTests/Features/`; ≥80% coverage
- XCUITest (UI): critical flows only (Login, Transfer, Sign-out); use `accessibilityIdentifier`
- Mock repos injected via constructor; real API in a follow-up story

## Deferred Work
- Okta OIDC integration (`okta-mobile-swift` 2.x)
- AppCoordinator + full coordinator tree (Login, TabBar, Home, Transfer, Cards, More)
- All feature screens: Login, Home, Accounts, Transfer, Cards, More
- Core/Auth layer (AuthService, KeychainStore, UserSession)
- Core/Networking layer (APIClient, APIRouter, APIError, RequestInterceptor)
- Core/Notifications layer (AppNotification, NotificationPublisher)
- Core/Extensions (Decimal+Currency, Date+Greeting, String+Initials)
- Domain models (Account, Transaction, Customer, TransferRequest)
- Repository protocols + Remote/Mock implementations
- DesignSystem (Colors, Typography, Assets)
- Okta.plist / Okta.plist.example
- API_BASE_URL xcconfig + CI injection
- SwiftLint (.swiftlint.yml) with `-warnings-as-errors`
- XCUITest critical-flow tests (Login, Transfer, Sign-out)
- Full ≥80% unit-test coverage on Core/ + Features/
- Localizable.strings / i18n

## Git Workflow

> **Default PR target branch: `develop`.** Every feature/refactor/docs PR
> opens against `develop`. PRs are only opened against `qa`, `uat`, or
> `main` for explicit promotion PRs.

**Branch model (`develop` → `qa` → `uat` → `main`):**

| Branch  | Role                       | Receives PRs from      | Promotes to |
|---------|----------------------------|------------------------|-------------|
| develop | Default integration branch | feature branches       | qa          |
| qa      | First quality gate         | develop (promotion PR) | uat         |
| uat     | Pre-prod acceptance        | qa (promotion PR)      | main        |
| main    | Production / release tags  | uat (promotion PR)     | tagged only |

All feature PRs MUST target `develop`. Never open a feature PR against
`qa`, `uat`, or `main`. Promotions happen via dedicated promotion PRs.
