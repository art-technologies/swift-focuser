# Focuser

Focuser allows to focus SwiftUI text fields dynamically and implements ability move go through the form using Keyboard for iOS 13 and iOS 14. Implementation is designed to follow [Apple `@FocusState`](https://developer.apple.com/documentation/swiftui/focusstate) property wrapper. Since most of us cannot update our apps to serve iOS 15 exclusively `Focuser` will provide an easy way to accomplish the same thing.

## Preview

![Preview gif of Focuser](./public/preview.gif)

## Install

We are going to maintain Focuser and extend its functionality in the near future. You can use Focuser in your project using SPM

`File` > `Swift Packages` > `Add Package Dependency` and use

```
git@github.com:art-technologies/swift-focuser.git
```

## Example

Feel free to download full Xcode example project in `Example` folder.

To use Focuser you first need to `import Focuser` and define an `enum` corresponding to text fields.

```swift
import Focuser

enum FormFields {
    case none, username, password, name
}
```

`.none` is a special case used to reasign first responder. Since Focuser allows to focus keyboard to the next text fields using keybaord we have to provide additional information of what the next field should be. We provide this using extension on our struct comforming to `FocusStateCompliant` protocol. In addition of providing computed variable `next` we also provide `last`. This indicates to Focuser when it should show "done" keyboard button instead of "next".

```swift
extension FormFields: FocusStateCompliant {

    static var last: FormFields {
        .name
    }

    var next: FormFields {
        switch self {
        case .username:
            return .password
        case .password:
            return .name
        default: return .none
        }
    }
}
```

Finally we can build our form

```swift
struct ContentView: View {
    @FocusStateLegacy var focusedField: FormFields = .username
    @State var username = ""
    @State var password = ""
    @State var name = ""

    var body: some View {
        VStack{
            TextField("Username", text: $username)
                .focusedLegacy($focusedField, equals: .username)

            TextField("Password", text: $password)
                .focusedLegacy($focusedField, equals: .password)

            TextField("Name", text: $name)
                .focusedLegacy($focusedField, equals: .name)

            Button(action: {
                focusedField = .password
            }) {
                Text("Focus Password")
            }
        }
        .padding()
    }
}
```

Here we introduced "Focus Password" button showing how to focus a specific text field dynamically.

## Caveats

Make sure to apply `.focusedLegacy` modifier as the last modifier to `TextField`. I will make a fix later on to aleviate the order issue.

```swift
TextField("Username", text: $username)
   .padding(9)
   .background(Color(.systemGray6))
   .cornerRadius(8)
   .focusedLegacy($focusedField, equals: .username)
```

## To do

- Support for `TextEditor`
