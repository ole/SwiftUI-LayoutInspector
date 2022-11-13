// Based on: Swift Talk 319, Inspecting HStack Layout (2022-08-26)
// <https://talk.objc.io/episodes/S01E319-inspecting-hstack-layout>

import SwiftUI

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension View {
    /// Start debugging the layout algorithm for this subtree.
    ///
    /// This clears the debug layout log.
    public func startDebugLayout(selection: String? = nil) -> some View {
        ClearDebugLayoutLog {
            self
        }
        .environment(\.debugLayoutSelectedViewID, selection)
    }

    /// Monitor the layout proposals and responses for this view and add them to the log.
    public func debugLayout(
        _ label: String,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> some View {
        DebugLayout(label: label) {
            self
        }
        .onAppear {
            LogStore.shared.registerViewLabelAndWarnIfNotUnique(label, file: file, line: line)
        }
        .modifier(DebugLayoutSelectionHighlight(viewID: label))
    }
}

/// A custom layout that adds the layout proposals and responses for a view to a log for display.
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
struct DebugLayout: Layout {
    var label: String

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        assert(subviews.count == 1)
        logLayoutStep(label, step: .proposal(proposal))
        let response = subviews[0].sizeThatFits(proposal)
        logLayoutStep(label, step: .response(response))
        return response
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews[0].place(at: bounds.origin, proposal: proposal)
    }
}

/// Draws a highlight (dashed border) around the view that's selected
/// in the DebugLayout log table.
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
fileprivate struct DebugLayoutSelectionHighlight: ViewModifier {
    var viewID: String
    @Environment(\.debugLayoutSelectedViewID) private var selection: String?

    func body(content: Content) -> some View {
        content
            .overlay {
                let isSelected = viewID == selection
                if isSelected {
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundColor(.pink)
                }
            }
    }
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension CGFloat {
    var pretty: String {
        String(format: "%.1f", self)
    }
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension CGSize {
    var pretty: String {
        let thinSpace: Character = "\u{2009}"
        return "\(width.pretty)\(thinSpace)×\(thinSpace)\(height.pretty)"
    }
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension Optional where Wrapped == CGFloat {
    var pretty: String {
        self?.pretty ?? "nil"
    }
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension ProposedViewSize {
    var pretty: String {
        let thinSpace: Character = "\u{2009}"
        return "\(width.pretty)\(thinSpace)×\(thinSpace)\(height.pretty)"
    }
}