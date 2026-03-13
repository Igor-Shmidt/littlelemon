import SwiftUI

struct Home: View {
    var body: some View {
        TabView {
            Menu()
            
            UserProfile()
        }
    }
}

#Preview {
    Home()
}
