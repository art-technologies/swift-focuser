//
//  File.swift
//
//
//  Created by Augustinas Malinauskas on 01/09/2021.
//

import SwiftUI
import SwiftUIIntrospect

class TextFieldObserver: NSObject, UITextFieldDelegate {
    var onReturnTap: () -> Void = {}
    weak var forwardToDelegate: UITextFieldDelegate?

    @available(iOS 2.0, *)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        forwardToDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    @available(iOS 2.0, *)
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
}

public struct FocusModifier<Value: FocusStateCompliant & Hashable>: ViewModifier {
    @Binding var focusedField: Value?
    var equals: Value
    @State var observer = TextFieldObserver()

    public func body(content: Content) -> some View {
        content
            .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { tf in
                if !(tf.delegate is TextFieldObserver) {
                    observer.forwardToDelegate = tf.delegate
                    tf.delegate = observer
                }

                /// when user taps return we navigate to next responder
                observer.onReturnTap = {
                    focusedField = focusedField?.next ?? Value.last
                }

                /// to show kayboard with `next` or `return`
                if equals.hashValue == Value.last.hashValue {
                    tf.returnKeyType = .done
                } else {
                    tf.returnKeyType = .next
                }

                if focusedField == equals,
                   tf.isFirstResponder == false
                {
                    tf.becomeFirstResponder()
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
                focusedField = equals
            })
    }
}
