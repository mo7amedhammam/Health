//
//  ReschedualRequestCard.swift
//  Sehaty
//
//  Created by mohamed hammam on 24/12/2025.
//

import SwiftUI

struct ReschedualRequestCard: View {
    var upcomingSession: UpcomingSessionM?
    var acceptAction: (() -> Void)?
    var rejectAction: (() -> Void)?

    var body: some View {
        VStack {
//            SectionHeader(image: Image(.newnxtsessionicon), title: "home_nextSession") {}
            
            ZStack(alignment: .bottomTrailing) {
                HStack {
                    Image(.nextsessionbg)
                    Spacer()
                }.padding(8)
                
                VStack(spacing: 20) {
                    ReschedualRequestCardHeaderView(session: upcomingSession)
                    HStack{
                        ReschedualRequestCardDoctorView(session: upcomingSession)
                        ReschedualRequestCardCountdownOrJoinView(session: upcomingSession)
                    }
                    ReschedualRequestCardActionsView(acceptAction:acceptAction,rejectAction: rejectAction)
                }
                .padding()
            }
//            .frame(maxWidth: .infinity, maxHeight: 200)
            .horizontalGradientBackground()
            .cardStyle(cornerRadius: 4, shadowOpacity: 0.4)
            .padding(.bottom, 5)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    ReschedualRequestCard(upcomingSession: UpcomingSessionM(id: 1, doctorName: "أحمد سامي",sessionDate: "2025-07-02T10:22:00", timeFrom: "08:12:00", packageName: "باقات كبار السن (أهالينا)", categoryName: "التغذية العلاجية", mainCategoryID: 3, categoryID: 2, sessionMethod: nil, packageID: 3, customerName:"customer name",mainCategoryName: "باقات الصحة العامة") )
}

struct ReschedualRequestCardHeaderView: View {
    var session: UpcomingSessionM?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                //                Text("pack_name".localized)
                //                    .font(.bold(size: 18))
                //                    .foregroundColor(.white)
                Text(session?.packageName ?? "")
                    .font(.bold(size: 18))
                    .foregroundColor(.white)
                
                Text(session?.mainCategoryName ?? "")
                    .font(.semiBold(size: 14))
                    .foregroundColor(.white)
                    .padding(.top,3)
                Text(session?.categoryName ?? "")
                    .font(.semiBold(size: 14))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            HStack(alignment: .top) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("old_schedual_".localized)
                        .font(.semiBold(size: 13))
                        .foregroundColor(Color(.secondary))
                        .padding(3)

                    Text(session?.formattedSessionDate ?? "")
                        .font(.regular(size: 13))
                        .foregroundColor(.white)
                    Text(session?.formattedSessionTime ?? "")
                        .font(.regular(size: 13))
                        .foregroundColor(.white)
                }
                Image(.newcal)
                    .resizable()
                    .frame(width: 15, height: 15)
            }
        }
    }
}
struct ReschedualRequestCardDoctorView: View {
    var session: UpcomingSessionM?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                let nametitle = Helper.shared.getSelectedUserType() == .Doctor ? "Patient".localized : "Doctor".localized

                    Text(nametitle)
                        .font(.regular(size: 14))
                        .foregroundColor(.white)
                Text(session?.displayName ?? "")
                    .font(.semiBold(size: 18))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
    }
}
struct ReschedualRequestCardCountdownOrJoinView: View {
    var session: UpcomingSessionM?
    
    @State private var countdown: (days: Int, hours: Int, minutes: Int) = (0, 0, 0)
    @State private var timer: Timer?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .trailing, spacing: 4) {
                Text("new_schedual_".localized)
                    .font(.semiBold(size: 13))
                    .foregroundColor(Color(.secondary))
                    .padding(3)

                Text(session?.formattedSessionDate ?? "")
                    .font(.regular(size: 13))
                    .foregroundColor(.white)
                Text(session?.formattedSessionTime ?? "")
                    .font(.regular(size: 13))
                    .foregroundColor(.white)
            }
            Image(.newcal)
                .resizable()
                .frame(width: 15, height: 15)
        }
    }
}

struct ReschedualRequestCardActionsView: View {
    var acceptAction: (() -> Void)?
    var rejectAction: (() -> Void)?
    var body: some View {
        HStack(alignment: .bottom,spacing: 10) {
            Button(action: {
                // accept Action
                acceptAction?()
            }) {
                    Text("accept_".localized)
                        .font(.bold(size: 16))
                        .foregroundColor(Color(.secondary))
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(Color(.white))
                .cardStyle(cornerRadius: 3)
            }
            
            Spacer()
            
            Button(action: {
                // regect Action
                rejectAction?()
            }) {
                    Text("reject_".localized)
                        .font(.bold(size: 16))
                        .foregroundColor(Color(.secondary))
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(Color(.white))
                .cardStyle(cornerRadius: 3)
            }
        }
        .padding(.horizontal,30)
//        .padding(.bottom)
    }
}

