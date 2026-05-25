# Bootstrap Plan — AcmeBank iOS

## In scope (this PR)

### Project name + tech stack decisions
- **App name:** AcmeBank
- **Platform:** iOS 17+, Swift 5.10, SwiftUI
- **Architecture:** MVVM + Coordinator (bootstrapped as a single placeholder screen; full pattern deferred)
- **Project file mechanism:** XcodeGen (`project.yml`) — never hand-crafted `.pbxproj`
- **Test runner:** XCTest (unit)
- **Bundle ID:** `com.acmebank.mobile`
- **Minimum Xcode:** 16.0

### Directory structure (Hello World only)
```
AcmeBank/
├── App/
│   └── AcmeBankApp.swift         # @main SwiftUI entry point (WindowGroup)
├── ContentView.swift             # Placeholder "AcmeBank" screen
└── Resources/
    ├── Assets.xcassets/
    │   ├── Contents.json
    │   └── AppIcon.appiconset/
    │       └── Contents.json
    └── PrivacyInfo.xcprivacy
AcmeBank/AcmeBank.entitlements    # Keychain access group stub
AcmeBankTests/
└── AcmeBankTests.swift           # ONE trivial test (ContentView initialises)
project.yml                       # XcodeGen spec
.gitignore                        # iOS / XcodeGen / macOS ignore rules
setup.sh                          # one-shot: installs xcodegen, generates .xcodeproj, opens Xcode
bootstrap_plan.md
CLAUDE.md
AGENT.md
README.md
```

> Note: The spec also declares an `AcmeBankUITests` target. Per bootstrap rules,
> a declared test target MUST contain at least one compilable test file.
> We ship a minimal smoke `AcmeBankUITests.swift` so xcodebuild does not fail.

### Files this PR creates
| File | Purpose |
|---|---|
| `project.yml` | XcodeGen project spec — source of truth for `.xcodeproj` |
| `AcmeBank/App/AcmeBankApp.swift` | `@main` SwiftUI App entry |
| `AcmeBank/ContentView.swift` | Placeholder view showing "AcmeBank" |
| `AcmeBank/Resources/Assets.xcassets/Contents.json` | Asset catalog root metadata |
| `AcmeBank/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json` | AppIcon stub (prevents CI actool error) |
| `AcmeBank/Resources/PrivacyInfo.xcprivacy` | Privacy manifest (UserDefaults reason stub) |
| `AcmeBank/AcmeBank.entitlements` | Keychain access group stub |
| `AcmeBankTests/AcmeBankTests.swift` | One trivial unit test |
| `AcmeBankUITests/AcmeBankUITests.swift` | One trivial UI test stub |
| `.gitignore` | iOS / XcodeGen / macOS ignore rules |
| `setup.sh` | One-shot project materialisation script |
| `README.md` | Project overview + setup instructions |
| `CLAUDE.md` | Agent context (full planned architecture + deferred work) |
| `AGENT.md` | Identical to CLAUDE.md |

### How to run locally
```bash
./setup.sh           # installs XcodeGen if needed, generates .xcodeproj, opens Xcode
# — or manually —
brew install xcodegen
xcodegen generate
open AcmeBank.xcodeproj
```
Then press ⌘R in Xcode (target: any iOS 17 simulator).

### How to run tests
```bash
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

### Definition of Hello World
The app launches in the iOS Simulator and shows a single centered screen displaying
the text **"AcmeBank"** on a white system background.  
The one unit test (`test_contentView_initializes`) passes, confirming the test
runner links against the app module.

---

## Out of scope — deferred to future work

- **Authentication (Okta OIDC / okta-mobile-swift)** — future PR
- **RootView auth-state switching (Login vs TabBar)** — future PR
- **AppCoordinator + Coordinator protocol** — future PR
- **LoginCoordinator / LoginView / LoginViewModel** — future PR
- **HomeCoordinator / HomeView / HomeViewModel + sub-views** — future PR
- **TabBarCoordinator + Accounts / Transfer / Cards / More tabs** — future PR
- **Core/Auth layer (AuthService, KeychainStore, UserSession)** — future PR
- **Core/Networking layer (APIClient, APIRouter, APIError, RequestInterceptor)** — future PR
- **Core/Notifications layer (AppNotification, NotificationPublisher, NotificationKey)** — future PR
- **Core/Extensions (Decimal+Currency, Date+Greeting, String+Initials)** — future PR
- **Domain models (Account, Transaction, Customer, TransferRequest)** — future PR
- **Repository protocols (AccountRepositoryProtocol, etc.)** — future PR
- **Remote API repositories (AccountAPIRepository, etc.)** — future PR
- **Mock data repositories (MockAccountRepository, etc.)** — future PR
- **DesignSystem (Colors.swift, Typography.swift)** — future PR
- **Okta.plist / Okta.plist.example config** — future PR
- **API_BASE_URL xcconfig / CI injection** — future PR
- **SwiftLint (.swiftlint.yml)** — future PR
- **XCUITest critical-flow tests (Login, Transfer, Sign-out)** — future PR
- **Full test coverage targets (≥80% on Core/ + Features/)** — future PR
- **Accounts, Transfer, Cards, More feature screens** — future PR
- **Bill payment, transfer confirmation, customer profile screens** — future PR
- **Localizable.strings / internationalisation** — future PR
