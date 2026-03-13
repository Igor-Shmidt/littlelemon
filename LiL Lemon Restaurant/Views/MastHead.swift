//
//  MastHead.swift
//  LiL Lemon
//
//  Created by Igor Shmidt on 13.03.2026.
//

import SwiftUI

struct MastHead: View {
    let categories: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.white.frame(height: 0)
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Little Lemon")
                        .foregroundColor(Color("approvedYellow"))
                        .font(.largeTitle)
                    Text("Chicago")
                        .foregroundColor(.white)
                        .font(.title)
                    Text("We offer \(categories.joined(separator: ", ")).")
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    Spacer()
                }
                .frame(height: 180)
                Image("restrauntImage")
                    .resizable()
                    .cornerRadius(16)
                    .frame(width: 150, height: 150)
            }
        }
        .padding(.horizontal)
        .background(Color("approvedGreen"))
    }
}

#Preview {
    MastHead(categories: ["starters", "mains", "desserts"])
}
