// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/09/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public struct SimpleActionSheet {
    let title: LocalizedStringKey
    let message: LocalizedStringKey
    var buttons: [Button]

    public init(title: LocalizedStringKey, message: LocalizedStringKey, buttons: [SimpleActionSheet.Button]) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }

    var sheetButtons: [ActionSheet.Button] {
        buttons.map { button in
            switch button {
                case .normal(let label, let action): return .default(Text(label), action: action)
                case .destructive(let label, let action): return .destructive(Text(label), action: action)
                case .cancel: return .cancel()
            }
        }
    }

    public enum Button {
        case normal(LocalizedStringKey,() -> ())
        case destructive(LocalizedStringKey, () -> ())
        case cancel
        
        var alertButton: SwiftUI.Alert.Button {
            switch self {
                case .normal(let label, let action):
                    return .default(Text(label), action: action)
                case .destructive(let label, let action):
                    return .destructive(Text(label), action: action)
                case .cancel:
                    return .cancel()
            }
        }
    }
}

public struct SimpleActionSheetModifier: ViewModifier {
    @Binding var sheet: SimpleActionSheet?
    
    var showSheet: Binding<Bool> {
        Binding<Bool>(
            get: { sheet != nil }, set: { value in if !value { sheet = nil }}
        )
    }

    public func body(content: Content) -> some View {
        content
            .actionSheet(isPresented: showSheet) {
                ActionSheet(
                    title: Text(sheet!.title),
                    message: Text(sheet!.message),
                    buttons: sheet!.sheetButtons
                )
            }
    }
}

public extension View {
    func simpleActionSheet(_ sheet: Binding<SimpleActionSheet?>) -> some View {
        self
            .modifier(SimpleActionSheetModifier(sheet: sheet))
    }
}
