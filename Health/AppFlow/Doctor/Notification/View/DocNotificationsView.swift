//
//  DocNotificationsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 24/08/2025.
//
import SwiftUI

struct DocNotificationsView: View {
    // Mock Data
    let notifications: [DocNotificationM] = [
        .init(userName: "Mohammad Reza", message: "commented on your UI/UX Designer", timeAgo: "about 2 hour ago", avatarColor: Color(.secondary)),
        .init(userName: "Sandra Radden", message: "like your Web UI Design Post.", timeAgo: "about 2 hour ago", avatarColor: Color(.secondary)),
        .init(userName: "Merry Rose", message: "joined to Final Presentation 🔥", timeAgo: "about 3 hour ago", avatarColor: Color(.secondary)),
        .init(userName: "Adan Ealisth", message: "commented on Final your new shot", timeAgo: "about 4 hour ago", avatarColor: Color(.secondary)),
        .init(userName: "Michael Pinson", message: "want to follow you.", timeAgo: "about 4 hour ago", avatarColor: Color(.secondary)),
        .init(userName: "Sandra Radden", message: "like your Web UI Design Post.", timeAgo: "about 5 hour ago", avatarColor: Color(.secondary)),
        .init(userName: "Fateme Zafar", message: "want to follow you.", timeAgo: "about 6 hour ago", avatarColor: Color(.secondary))
    ]
    var hasbackBtn : Bool?
    var body: some View {
        VStack(spacing: 15) {

            TitleBar(title: "doc_notifications",hasbackBtn: hasbackBtn ?? true)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(notifications) { item in
                        DocNotificationCard(item: item)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .localizeView()
//        .showHud(isShowing:  $viewModel.isLoading)
//        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)

    }
}

struct DocNotificationCard: View {
    let item: DocNotificationM?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(item?.avatarColor ?? .secondary)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(item?.userName ?? "")
                        .font(.semiBold(size: 12))
                        .foregroundColor(.mainBlue)
                    +
                    Text(" \(item?.message ?? "")")
                        .font(.medium(size: 12))
                        .foregroundColor(.gray)
                }
                .lineSpacing(8)
                
                Spacer()
                Text(item?.timeAgo ?? "")
                    .font(.regular(size: 10))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(3)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    DocNotificationsView()
}
