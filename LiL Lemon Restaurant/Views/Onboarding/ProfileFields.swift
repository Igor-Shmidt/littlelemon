import SwiftUI

struct ProfileFields: View {
    struct Fields: OptionSet {
        let rawValue: Int

        static let name = Fields(rawValue: 1 << 0)
        static let email = Fields(rawValue: 1 << 1)

        static let all: Self = Fields(rawValue: 0b11)
    }
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    let fields: Fields
    
    init(
        firstName: Binding<String> = .constant(""),
        lastName: Binding<String> = .constant(""),
        email: Binding<String> = .constant(""),
        fields: ProfileFields.Fields
    ) {
        self._firstName = firstName
        self._lastName = lastName
        self._email = email
        self.fields = fields
    }

    var body: some View {
        Form {
            if fields.contains(.name) {
                Section {
                    TextField("", text: $firstName)
                        .cornerRadius(12)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                } header: { Text("First Name*") }
                Section {
                    TextField("", text: $lastName)
                        .cornerRadius(12)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                        .padding(.bottom)
                } header: { Text("Last Name*").padding(.top) }
            }
            if fields.contains(.email) {
                Section {
                    TextField("", text: $email)
                        .cornerRadius(12)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                } header: { Text("Email*") }
            }
        }
        .foregroundColor(Color("approvedGray"))
        .padding()
        .formStyle(.columns)
    }
}

#Preview {
    let firstName = Binding<String>(get: { "first" }, set: {_ in})
    let lastName = Binding<String>(get: { "second" }, set: {_ in})
    let email = Binding<String>(get: { "em@a.il" }, set: {_ in})
    ProfileFields(firstName: firstName, lastName: lastName, email: email, fields: .all)
}
