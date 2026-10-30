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
    /// matches never blanks it.
    func continued(to text: String) -> AddressCompletion? {
        if text == typed { return self }
        guard text.hasPrefix(typed) else { return nil }
        let added = String(text.dropFirst(typed.count))
        guard let typedSuffix = suffix.range(of: added, options: [.anchored, .caseInsensitive]),
            typedSuffix.upperBound < suffix.endIndex
        else { return nil }
        return AddressCompletion(typed: text, suffix: String(suffix[typedSuffix.upperBound...]), accepted: accepted)
    }
}
