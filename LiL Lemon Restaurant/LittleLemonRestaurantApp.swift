import SwiftUI

@main
struct RestrauntApp: App {
    @AppStorage(kIsLoggedIn) private var isLoggedIn = false
    let persistence = PersistenceController()

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                Home()
                    .environment(\.managedObjectContext, persistence.container.viewContext)
            } else {
                Onboarding()
            }
        }
    }
}
