//
//  SwiftUIView.swift
//  
//
//  Created by Augustinas Malinauskas on 13/09/2021.
//

import SwiftUI

public struct FocusModifierTextEditor<Value: FocusStateCompliant & Hashable>: ViewModifier {
    @Binding var focusedField: Value?
    var equals: Value
    @State var observer = TextFieldObserver()
    
    public func body(content: Content) -> some View {
        content
            .introspectTextView { tv in
                if focusedField == equals {
                    tv.becomeFirstResponder()
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
              focusedField = equals
            })
    }
}
