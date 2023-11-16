//
//  SwiftUIView.swift
//
//
//  Created by Augustinas Malinauskas on 13/09/2021.
//

import SwiftUI
import SwiftUIIntrospect

public struct FocusModifierTextEditor<Value: FocusStateCompliant & Hashable>: ViewModifier {
    @Binding var focusedField: Value?
    var equals: Value
    @State var observer = TextFieldObserver()

    public func body(content: Content) -> some View {
        content
            .introspect(.textEditor, on: .iOS(.v14, .v15, .v16, .v17)) { tv in
                if focusedField == equals,
                   tv.isFirstResponder == false
                {
                    tv.becomeFirstResponder()
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
                focusedField = equals
            })
    }
}
