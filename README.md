# AcmeBank iOS

An iOS 17+ banking app — Swift 5.10, SwiftUI, MVVM + Coordinator architecture.

## Quick Start

```bash
git clone <repo-url>
cd AcmeBank
./setup.sh
```

`setup.sh` installs [XcodeGen](https://github.com/yonaskolb/XcodeGen) via Homebrew if missing,
generates `AcmeBank.xcodeproj` from `project.yml`, and opens it in Xcode.

**Manual fallback** (for environments that block shell scripts):
```bash
brew install xcodegen
xcodegen generate
open AcmeBank.xcodeproj
```

Press **⌘R** in Xcode targeting any iOS 17 simulator.

## Run Tests

```bash
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

## Project Layout

```
AcmeBank/           Swift source files (SwiftUI app)
AcmeBankTests/      XCTest unit tests
AcmeBankUITests/    XCUITest critical-flow tests
project.yml         XcodeGen spec — source of truth for the .xcodeproj
setup.sh            One-shot post-clone setup
```

> `AcmeBank.xcodeproj` is **git-ignored** — it is generated from `project.yml`.
> Never commit the generated project file.

## Architecture

MVVM + Coordinator with SwiftUI `NavigationStack`. See [CLAUDE.md](CLAUDE.md) for
the full planned architecture, deferred work, and git workflow conventions.

## Status

Bootstrap only — Hello World shell. See `CLAUDE.md` / `AGENT.md` for the full
feature roadmap and what's deferred to follow-up PRs.
