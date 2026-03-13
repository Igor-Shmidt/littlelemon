import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Self.Button(configuration: configuration)
    }

    struct Button: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .bold()
                .foregroundColor(Color("approvedGray"))
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background {
                    if isEnabled {
                        Color("approvedYellow")
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color("approvedYellow"), lineWidth: 2)
                    }
                }
                .cornerRadius(16)
                .padding([.top, .horizontal])
                .opacity(isEnabled ? 1 : 0.5)
        }
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var brandedPrimary: Self { .init() }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Self.Button(configuration: configuration)
    }

    struct Button: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .bold()
                .foregroundColor(.white)
                .padding()
                .background {
                    if isEnabled {
                        Color("approvedGreen")
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color("approvedGreen"), lineWidth: 2)
                    }
                }
                .cornerRadius(16)
                .opacity(isEnabled ? 1 : 0.5)
        }
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var brandedSecondary: Self { .init() }
}

struct SecondaryGhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Self.Button(configuration: configuration)
    }

    struct Button: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .bold()
                .foregroundColor(Color("approvedGreen"))
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(isEnabled ? "approvedGreen" : "approvedGray"), lineWidth: 2)
                }
                .cornerRadius(16)
                .opacity(isEnabled ? 1 : 0.5)
        }
    }
}
extension ButtonStyle where Self == SecondaryGhostButtonStyle {
    static var brandedSecondaryGhost: Self { .init() }
}
