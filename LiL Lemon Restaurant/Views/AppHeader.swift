//
//  AppHeader.swift
//  LiL Lemon
//
//  Created by Igor Shmidt on 12.03.2026.
//

import SwiftUI

struct AppHeader: View {
    @AppStorage(kIsLoggedIn) private var isLoggedIn = false
    var title: String? = nil

    var logo: some View {
        Image("logo")
            .resizable()
            .clipShape(.rect(cornerRadius: 16))
            .frame(width: 160, height: 60, alignment: .trailing)
            .padding(.horizontal)
    }

    var profileImage: some View {
        Image("profile-image-placeholder")
            .resizable()
            .frame(width: 40, height: 40, alignment: .trailing)
            .padding(.trailing)
    }

    var body: some View {
        VStack(alignment: .center) {
            if isLoggedIn {
                HStack(alignment: .center) {
                    Spacer()
                    logo
                    Spacer()
                    profileImage
                }
            } else {
                logo
            }
            if let title, !title.isEmpty {
                Text(title)
                    .font(.title2.bold())
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationView {
        VStack { Color.secondary }
            .background(.secondary)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    AppHeader()
                }
            }
    }
}
