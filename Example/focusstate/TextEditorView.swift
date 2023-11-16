//
//  TextEditorView.swift
//  focusstate
//
//  Created by will on 2023/11/16.
//

import Focuser
import SwiftUI

struct TextEditorView: View {
  enum FormFields: FocusStateCompliant {
    case textEditor

    static var last: Self { .textEditor }
    var next: Self? { nil }
  }

  @FocusStateLegacy var focusedField: FormFields?
  @State var text = "Edit me!"
    
  var body: some View {
    TextEditor(text: $text)
      .padding()
      .background(Color(.systemGray6))
      .cornerRadius(20)
      .padding()
      .focusedLegacy($focusedField, equals: .textEditor)
  }
}

#Preview {
  TextEditorView()
}
