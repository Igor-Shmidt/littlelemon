import SwiftUI

let kFirstName = "first name key"
let kLastName = "last name key"
let kEmail = "email key"
let kIsLoggedIn = "kIsLoggedIn"

struct Onboarding: View {
    enum Step: Hashable {
        case name
        case email
    }

    @State private var path: [Step] = []

    var body: some View {
        NavigationStack(path: $path) {
            Intro(path: $path)
            .navigationDestination(for: Step.self) { step in
                switch step {
                case .name:
                    NameForm(path: $path)
                case .email:
                    EmailForm(path: $path)
                }
            }
        }
    }
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z]+[A-Z0-9._%+-]*@(?:[A-Z0-9]+\\.?)+\\.[A-Z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

#Preview {
    Onboarding()
}
