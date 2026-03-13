import SwiftUI

struct EmailForm: View {
    @Binding var path: [Onboarding.Step]
    @State private var email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    @AppStorage(kIsLoggedIn) private var isLoggedIn = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Step 3 of 3")
                .foregroundStyle(.secondary)
            Spacer()
            ProfileFields(email: $email, fields: .email)

            Spacer()
            Button("Register") {
                UserDefaults.standard.set(email, forKey: kEmail)
                isLoggedIn = true
            }
            .buttonStyle(.brandedPrimary)
            .disabled(!isValidEmail(email))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .principal) {
                AppHeader(title: "Personal details")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

@available(iOS 17, *)
#Preview {
    @Previewable @State var path: [Onboarding.Step] = [.name]
    NavigationView {
        EmailForm(path: $path)
    }
}
