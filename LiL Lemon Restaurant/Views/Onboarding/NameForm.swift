import SwiftUI

struct NameForm: View {
    @Binding var path: [Onboarding.Step]
    @State private var firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    @State private var lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Step 2 of 3")
                .foregroundStyle(.secondary)
            Spacer()
            ProfileFields(firstName: $firstName, lastName: $lastName, fields: .name)
            Spacer()
            Button("Next") {
                UserDefaults.standard.set(firstName, forKey: kFirstName)
                UserDefaults.standard.set(lastName, forKey: kLastName)
                path.append(.email)
            }
            .buttonStyle(.brandedPrimary)
            .disabled(firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                      lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
        NameForm(path: $path)
    }
}
