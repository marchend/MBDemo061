import XCTest

/// Bootstrap UI test — proof-of-life that the XCUITest target compiles and
/// links against the host app. Full critical-flow tests (Login, Transfer,
/// Sign-out) belong in feature stories.
final class AcmeBankUITests: XCTestCase {
    func test_appLaunches() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
    }
}
