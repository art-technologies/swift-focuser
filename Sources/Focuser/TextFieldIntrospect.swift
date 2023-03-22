//
//  File.swift
//  
//
//  Created by Augustinas Malinauskas on 01/09/2021.
//

import SwiftUI
import Introspect

class TextFieldObserver: NSObject, UITextFieldDelegate, ObservableObject {
    var onReturnTap: () -> () = { }
    var onDidBeginEditing: () -> () = { }
    weak var ownerTextField: UITextField?
    weak var forwardToDelegate: UITextFieldDelegate?
    
    @available(iOS 2.0, *)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        forwardToDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    @available(iOS 2.0, *)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onDidBeginEditing()
        forwardToDelegate?.textFieldDidBeginEditing?(textField)
    }

    @available(iOS 2.0, *)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        forwardToDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    @available(iOS 2.0, *)
    func textFieldDidEndEditing(_ textField: UITextField) {
        forwardToDelegate?.textFieldDidEndEditing?(textField)
    }

    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        forwardToDelegate?.textFieldDidEndEditing?(textField)
    }

    @available(iOS 2.0, *)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        forwardToDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    @available(iOS 13.0, *)
    func textFieldDidChangeSelection(_ textField: UITextField) {
        forwardToDelegate?.textFieldDidChangeSelection?(textField)
    }

    @available(iOS 2.0, *)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        forwardToDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    @available(iOS 2.0, *)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturnTap()
        return forwardToDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    @available(iOS 16.0, *)
    func textField(_ textField: UITextField, editMenuForCharactersIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        forwardToDelegate?.textField?(textField, editMenuForCharactersIn: range, suggestedActions: suggestedActions)
    }

    @available(iOS 16.0, *)
    func textField(_ textField: UITextField, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating) {
        forwardToDelegate?.textField?(textField, willPresentEditMenuWith: animator)
    }
    
    @available(iOS 16.0, *)
    func textField(_ textField: UITextField, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating) {
        forwardToDelegate?.textField?(textField, willDismissEditMenuWith: animator)
    }
}

public struct FocusModifier<Value: FocusStateCompliant & Hashable>: ViewModifier {
    @Binding var focusedField: Value?
    var equals: Value
    @StateObject var observer = TextFieldObserver()
    
    public func body(content: Content) -> some View {
        content
            .introspectTextField { textField in
                if !(textField.delegate is TextFieldObserver) {
                    observer.forwardToDelegate = textField.delegate
                    observer.ownerTextField = textField
                    textField.delegate = observer
                }
                
                observer.onDidBeginEditing = {
                    focusedField = equals
                }
                
                observer.onReturnTap = {
                    focusedField = focusedField?.next
                    
                    if focusedField == nil {
                        textField.resignFirstResponder()
                    }
                    
                }
                
                if focusedField == equals {
                    if textField.isEnabled {
                        textField.becomeFirstResponder()
                    } else {
                        focusedField = focusedField?.next
                    }
                }
                
                if equals.hashValue == Value.last.hashValue {
                    textField.returnKeyType = .done
                } else {
                    textField.returnKeyType = .next
                }
            }
            .onChange(of: focusedField) { focusedField in
                if focusedField == nil {
                    observer.ownerTextField?.resignFirstResponder()
                }
            }
            .onWillDisappear {
                if focusedField != nil {
                    focusedField = nil
                }
            }
    }
}
