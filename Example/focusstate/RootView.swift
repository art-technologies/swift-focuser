//
//  RootView.swift
//  focusstate
//
//  Created by will on 2023/11/16.
//

import SwiftUI

struct RootView: View {
  var body: some View {
    NavigationView {
      List {
        NavigationLink(destination: TextFieldView()) {
          Text("TextField")
        }
        NavigationLink(destination: TextEditorView()) {
          Text("TextEditor")
        }
      }
      .navigationTitle("All Examples")
    }
  }
}

#Preview {
  RootView()
}
