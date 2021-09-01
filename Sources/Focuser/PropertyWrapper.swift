//
//  SwiftUIView.swift
//  
//
//  Created by Augustinas Malinauskas on 01/09/2021.
//

import SwiftUI

@propertyWrapper struct FocusStateLegacy<Value>: DynamicProperty where Value: Hashable {
    @State var form: Value
    
    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    var wrappedValue: Value {
        get {
            return form
        }
        
        nonmutating set {
            form = newValue
        }
    }
    
    init(wrappedValue: Value) {
        self._form = State(initialValue: wrappedValue)
    }
}
