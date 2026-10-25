import SwiftUI

extension View {
    /// Applies folder indentation and density while allowing accessible text to grow.
    func browserSavedFolderHeaderLayout(
        configuration: BrowserFolderGroupConfiguration
    ) -> some View {
        modifier(BrowserFolderHeaderDensityLayout(configuration: configuration))
    }
}

private struct BrowserFolderHeaderDensityLayout: ViewModifier {
    let configuration: BrowserFolderGroupConfiguration
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private var tabScale: Double { BrowserDeviceAppearanceStore.shared.tabScale }

    func body(content: Content) -> some View {
        let metrics = configuration.headerMetrics
        let density = BrowserSidebarDensity(dynamicTypeSize.isAccessibilitySize ? max(1, tabScale) : tabScale)
        let touch = !metrics.usesFixedRowHeight
        // The folder spacing setting may trim the row's slack above and below
        // the title, never below the smallest target a row keeps.
        let height = max(
            density.rowHeight(base: BrowserSidebarMetrics.compactFolderHeaderHeight, touch: touch),
            density.rowHeight(base: CrestLayout.sidebarRowHeight, touch: touch)
                - 2 * BrowserSidebarMetrics.folderHeaderTrim(BrowserDeviceAppearanceStore.shared.foldersSpacing))
        content.frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, configuration.headerLeadingInset)
            .padding(.trailing, metrics.contentTrailingInset)
            .frame(
                minHeight: height,
                maxHeight: metrics.usesFixedRowHeight && !dynamicTypeSize.isAccessibilitySize
                    ? height
                    : nil
            )
    }
}
