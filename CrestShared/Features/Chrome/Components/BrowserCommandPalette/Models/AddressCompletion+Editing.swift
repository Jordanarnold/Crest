import Foundation

/// How accepting a completion edits the field: the suffix is typed after what
/// was typed when the accepted text only adds to it; otherwise the accepted
/// text, which names its scheme, replaces the field.
extension AddressCompletion {
    // MARK: - Variables

    var completedQuery: String { typed + suffix }

    var insertionText: String { accepted == completedQuery ? suffix : accepted }

    var insertionRange: NSRange {
        accepted == completedQuery
            ? NSRange(location: typed.utf16.count, length: 0)
            : NSRange(location: 0, length: typed.utf16.count)
    }

    // MARK: - Actions - Typing

    /// This completion for `text`: itself when `text` is what it completes,
    /// the rest of its suffix when `text` types further into that suffix, or
    /// nil when `text` leaves it or types all of it. The field keeps showing
    /// it while the core ranks the new text, so a keystroke that still
    /// matches never blanks it. As the core matches, the scheme and host
    /// match in any case and the path only exactly.
    func continued(to text: String) -> AddressCompletion? {
        if text == typed { return self }
        guard text.hasPrefix(typed) else { return nil }
        let completed = Array(completedQuery)
        let added = Array(text.dropFirst(typed.count))
        let start = typed.count
        guard start + added.count < completed.count else { return nil }
        let pathStart = pathStart(of: completed)
        for (offset, character) in added.enumerated() {
            let position = start + offset
            let expected = completed[position]
            let matches = position < pathStart ? character.lowercased() == expected.lowercased() : character == expected
            guard matches else { return nil }
        }
        return AddressCompletion(typed: text, suffix: String(suffix.dropFirst(added.count)), accepted: accepted)
    }

    /// Where the path begins in `address`: its first `/` after an `http://`
    /// or `https://` it starts with, or its end when it has none.
    private func pathStart(of address: [Character]) -> Int {
        let scheme = ["https://", "http://"].first { String(address.prefix($0.count)).lowercased() == $0 }
        let host = scheme?.count ?? 0
        return address[host...].firstIndex(of: "/") ?? address.count
    }
}
