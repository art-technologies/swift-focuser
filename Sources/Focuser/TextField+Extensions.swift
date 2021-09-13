//
//  File.swift
//  
//
//  Created by Augustinas Malinauskas on 01/09/2021.
//

import SwiftUI


public extension View {
    func focusedLegacy<T: FocusStateCompliant>(_ focusedField: Binding<T?>, equals: T) -> some View {
        modifier(FocusModifier(focusedField: focusedField, equals: equals))
    }
}

@available(iOS 14.0, *)
public extension View {
    func focusEditor<T: FocusStateCompliant>(_ focusedField: Binding<T?>, equals: T) -> some View {
        modifier(FocusModifierTextEditor(focusedField: focusedField, equals: equals))
    }
}

