import SwiftUI

struct UserProfile: View {
    @AppStorage(kIsLoggedIn) private var isLoggedIn = false
    @State private var firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    @State private var lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    @State private var email = UserDefaults.standard.string(forKey: kEmail) ?? ""

    @State private var errorMessage = "" {
        didSet {
            showError = !errorMessage.isEmpty
        }
    }
    @State private var showError = false

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Color.white.frame(height: 0)
                HStack {
                    Image("profile-image-placeholder")
                        .resizable()
                        .frame(width: 125, height: 125)
                    HStack {
                        Button("Change") {}
                            .buttonStyle(.brandedSecondary)

                        Button("Remove") {}
                            .buttonStyle(.brandedSecondaryGhost)
                    }.padding([.horizontal,.bottom])
                    Spacer()
                }
                ScrollView {
                    ProfileFields(firstName: $firstName, lastName: $lastName, email: $email, fields: .all)
                        .padding(.bottom)

                    Button("Logout") {
                        [kFirstName, kLastName, kEmail]
                            .forEach(UserDefaults.standard.removeObject(forKey:))
                        isLoggedIn = false
                    }
                    .buttonStyle(.brandedPrimary)

                    Spacer()
                    HStack {
                        Button("Save Changes") {
                            if !validateForm() { return }
                            UserDefaults.standard.setValuesForKeys([
                                kFirstName: firstName,
                                kLastName: lastName,
                                kEmail: email
                            ])
                        }
                        .buttonStyle(.brandedSecondaryGhost)
                        Spacer()
                        Button("Discard Changes") {
                            (firstName, lastName, email) = (
                                UserDefaults.standard.string(forKey: kFirstName) ?? "",
                                UserDefaults.standard.string(forKey: kLastName) ?? "",
                                UserDefaults.standard.string(forKey: kEmail) ?? ""
                            )
                        }
                        .buttonStyle(.brandedSecondary)
                    }.padding([.horizontal,.bottom])
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    AppHeader(title: "Profile")
                }
            }
        }
        .alert(errorMessage, isPresented: $showError) {
            Button(role: .cancel) { showError.toggle() } label: { Text("Ok") }
        }
        .tabItem {
            Label("Profile", systemImage: "square.and.pencil")
        }
    }

    func validateForm() -> Bool {
        errorMessage =
        if firstName.isEmpty { "First Name field is mandatory" }
        else if lastName.isEmpty { "Last Name field is mandatory" }
        else if email.isEmpty { "Email field is mandatory" }
        else if !isValidEmail(email) { "Email in invalid format" }
        else { "" }
        return errorMessage.isEmpty
    }
}

#Preview {
    TabView {
        UserProfile()
    }
}
