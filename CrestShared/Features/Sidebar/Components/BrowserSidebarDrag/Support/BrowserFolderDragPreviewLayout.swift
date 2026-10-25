import CoreGraphics

enum BrowserFolderDragPreviewLayout {
    static let height = BrowserTabDragPreviewLayout.rowSize.height

    /// The height a folder header takes in a lifted folder's art: ``height``,
    /// trimmed as the folder spacing setting `spacing` trims the header it was
    /// lifted from, so the rows below it keep their measured places.
    static func headerHeight(spacing: Double) -> CGFloat {
        max(
            BrowserSidebarMetrics.compactFolderHeaderHeight,
            height - 2 * BrowserSidebarMetrics.folderHeaderTrim(spacing))
    }

    static func width(for sourceWidth: CGFloat) -> CGFloat {
        BrowserTabDragPreviewLayout.resolvedRowWidth(sourceWidth)
    }

    static func rowWidth(forSourceWidth sourceWidth: CGFloat) -> CGFloat {
        BrowserTabDragPreviewLayout.rowWidth(forSourceWidth: sourceWidth)
    }
}
