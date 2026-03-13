import SwiftUI

struct Intro: View {
    @Binding var path: [Onboarding.Step]

    var body: some View {
        VStack(spacing: 16) {
            Text("Step 1 of 3")
                .foregroundStyle(.secondary)
            Spacer()
            Text("Create your account to continue.")
            Spacer()
            Button("Next") {
                path.append(.name)
            }
            .buttonStyle(.brandedPrimary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .principal) {
                AppHeader(title: "Welcome to Little Lemon")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

@available(iOS, introduced: 17)
#Preview {
    @Previewable @State var path = [Onboarding.Step]()
    NavigationView {
        Intro(path: $path)
    }
}
