import XCTest

@testable import Crest

/// What a window's command palette keeps when the window moves to another
/// Space: a new tab can open in any Space, so its text follows; an address
/// being edited belongs to the tab left behind, so that palette closes.
@MainActor
final class BrowserCommandPaletteSpaceChangeTests: XCTestCase {
    func testNewTabTextFollowsSpaceChangeUntilDismissed() {
        let chrome = BrowserChromeState()
        chrome.presentCommandPalette()
        chrome.recordCommandPaletteQuery("google.com")

        chrome.spaceChanged()

        XCTAssertEqual(chrome.commandPaletteMode, .newTab)
        XCTAssertEqual(chrome.commandPaletteQuery(for: .newTab), "google.com")

        chrome.dismissCommandPalette()
        chrome.presentCommandPalette()
        XCTAssertEqual(chrome.commandPaletteQuery(for: .newTab), "")
    }

    func testEditedAddressClosesOnSpaceChangeAndNeverBecomesNewTabText() {
        let chrome = BrowserChromeState()
        chrome.openLocation("https://alpha.crest.test")
        chrome.recordCommandPaletteQuery("https://alpha.crest.test/edited")

        chrome.spaceChanged()

        XCTAssertNil(chrome.commandPaletteMode)
        chrome.presentCommandPalette()
        XCTAssertEqual(chrome.commandPaletteQuery(for: .newTab), "")
    }
}
