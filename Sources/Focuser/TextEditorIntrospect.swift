//
//  SwiftUIView.swift
//  
//
//  Created by Augustinas Malinauskas on 13/09/2021.
//

import SwiftUI

class TextViewObserver: NSObject, UITextViewDelegate, ObservableObject {
    var onDidBeginEditing: () -> () = { }
    weak var forwardToDelegate: UITextViewDelegate?
    weak var ownerTextView: UITextView?
    
    @available(iOS 2.0, *)
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        forwardToDelegate?.textViewShouldBeginEditing?(textView) ?? true
    }

    @available(iOS 2.0, *)
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        forwardToDelegate?.textViewShouldEndEditing?(textView) ?? true
    }

    
    @available(iOS 2.0, *)
    func textViewDidBeginEditing(_ textView: UITextView) {
        onDidBeginEditing()
        forwardToDelegate?.textViewDidBeginEditing?(textView)
    }

    @available(iOS 2.0, *)
    func textViewDidEndEditing(_ textView: UITextView) {
        forwardToDelegate?.textViewDidEndEditing?(textView)
    }

    
    @available(iOS 2.0, *)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        forwardToDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }

    @available(iOS 2.0, *)
    func textViewDidChange(_ textView: UITextView) {
        forwardToDelegate?.textViewDidChange?(textView)
    }

    
    @available(iOS 2.0, *)
    func textViewDidChangeSelection(_ textView: UITextView) {
        forwardToDelegate?.textViewDidChangeSelection?(textView)
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        forwardToDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        forwardToDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }

    
    @available(iOS, introduced: 7.0, deprecated: 10.0)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        forwardToDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange) ?? true
    }

    @available(iOS, introduced: 7.0, deprecated: 10.0)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        forwardToDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange) ?? true
    }
    
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        forwardToDelegate?.textView?(textView, editMenuForTextIn: range, suggestedActions: suggestedActions)
    }

    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating) {
        forwardToDelegate?.textView?(textView, willPresentEditMenuWith: animator)
    }

    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating) {
        forwardToDelegate?.textView?(textView, willDismissEditMenuWith: animator)
    }
}

public struct FocusModifierTextEditor<Value: FocusStateCompliant & Hashable>: ViewModifier {
    @Binding var focusedField: Value?
    var equals: Value
    @StateObject var observer = TextViewObserver()
    
    public func body(content: Content) -> some View {
        content
            .introspectTextView { textView in
                if !(textView.delegate is TextViewObserver) {
                    observer.forwardToDelegate = textView.delegate
                    observer.ownerTextView = textView
                    textView.delegate = observer
                }
                
                observer.onDidBeginEditing = {
                    focusedField = equals
                }
                
                if focusedField == equals {
                    if textView.isUserInteractionEnabled {
                        textView.becomeFirstResponder()
                    } else {
                        focusedField = focusedField?.next
                    }
                }
            }
            .onChange(of: focusedField) { focusedField in
                if focusedField == nil {
                    observer.ownerTextView?.resignFirstResponder()
                }
            }
            .onWillDisappear {
                if focusedField != nil {
                    focusedField = nil
                }
            }
    }
}
