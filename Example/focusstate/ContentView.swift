//
//  ContentView.swift
//  focusstate
//
//  Created by Augustinas Malinauskas on 01/09/2021.
//

import SwiftUI
import Focuser

enum FormFields {
    case username, password, name
}

extension FormFields: FocusStateCompliant {

    static var last: FormFields {
        .name
    }
    
    var next: FormFields? {
        switch self {
        case .username:
            return .password
        case .password:
            return .name
        default: return nil
        }
    }
}

struct ContentView: View {
    @FocusStateLegacy var focusedField: FormFields?
    @State var username = ""
    @State var password = ""
    @State var name = ""
    
    var body: some View {
        VStack{
            TextField("Username", text: $username)
                .padding(9)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .focusedLegacy($focusedField, equals: .username)
            
            TextField("Password", text: $password)
                .padding(9)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .focusedLegacy($focusedField, equals: .password)
            
            TextField("Name", text: $name)
                .padding(9)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .focusedLegacy($focusedField, equals: .name)
            
            
            Button(action: {
                focusedField = FormFields.password
            }) {
                Text("Focus Password")
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
