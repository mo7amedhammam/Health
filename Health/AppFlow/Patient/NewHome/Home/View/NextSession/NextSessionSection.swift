//
//  NextSessionSection.swift
//  Sehaty
//
//  Created by mohamed hammam on 02/07/2025.
//

import SwiftUI

struct NextSessionSection: View {
    var upcomingSession: UpcomingSessionM?
    var detailsAction: (() -> Void)?
    var rescheduleAction: (() -> Void)?

    var body: some View {
        VStack {
            SectionHeader(image: Image(.newnxtsessionicon), title: "home_nextSession") {}
            
            ZStack(alignment: .bottomTrailing) {
                HStack {
                    Image(.nextsessionbg)
                    Spacer()
                }.padding(8)
                
                VStack(spacing: 20) {
                    NextSessionHeaderView(session: upcomingSession)
                    HStack{
                        NextSessionDoctorView(session: upcomingSession)
                        NextSessionCountdownOrJoinView(session: upcomingSession)
                    }
                    NextSessionActionsView(detailsAction: detailsAction,rescheduleAction: rescheduleAction)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
            .horizontalGradientBackground()
            .cardStyle(cornerRadius: 4, shadowOpacity: 0.4)
            .padding(.bottom, 5)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    NextSessionSection(upcomingSession: UpcomingSessionM(id: 1, doctorName: "أحمد سامي",sessionDate: "2025-07-02T10:22:00", timeFrom: "08:12:00", packageName: "باقات كبار السن (أهالينا)", categoryName: "التغذية العلاجية", mainCategoryID: 3, categoryID: 2, sessionMethod: nil, packageID: 3, customerName:"customer name",mainCategoryName: "باقات الصحة العامة") )
}

struct NextSessionHeaderView: View {
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
struct NextSessionDoctorView: View {
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
struct NextSessionCountdownOrJoinView: View {
    var session: UpcomingSessionM?
    
    @State private var countdown: (days: Int, hours: Int, minutes: Int) = (0, 0, 0)
    @State private var timer: Timer?
    
    var body: some View {
        HStack {
            Spacer()
            
            if let link = session?.sessionMethod {
                Button {
                    if let url = URL(string: link) {
                        //                         Check if the Teams app is installed
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        } else {
                            // Fallback: open in Safari
                            UIApplication.shared.open(url, options: [:])
                        }
                    }
                    
                } label: {
                    HStack {
                        Image(.newjoinicon)
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("Join_now".localized)
                            .font(.bold(size: 16))
                            .foregroundColor(Color(.secondary))
                    }
                    .padding(.horizontal, 13)
                    .frame(height: 30)
                    .background(Color.white)
                    .cardStyle(cornerRadius: 3)
                }
            } else {
                CountdownTimerView(days: countdown.days, hours: countdown.hours, minutes: countdown.minutes)
                    .onAppear {
                        startTimer()
                    }
                    .onDisappear {
                        timer?.invalidate()
                    }
            }
            
            Spacer()
        }
    }
    
    private func startTimer() {
        updateCountdown()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            updateCountdown()
        }
    }
    
    private func updateCountdown() {
        countdown = session?.timeDifference() ?? (0, 0, 0)
    }
}
struct NextSessionActionsView: View {
    var detailsAction: (() -> Void)?
    var rescheduleAction: (() -> Void)?
    var body: some View {
        HStack(alignment: .bottom,spacing: 10) {
            Button(action: {
                // More details action
                detailsAction?()
            }) {
                HStack {
                    Image(.newmoreicon)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                    Text("more_detail".localized)
                        .font(.bold(size: 16))
                        .foregroundColor(Color(.secondary))
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(Color(.white))
                .cardStyle(cornerRadius: 3)
            }
            
            Spacer()
            
            Button(action: {
                // Reschedule action
                rescheduleAction?()
            }) {
                HStack {
                    Image(.newreschedual)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                    
                    Text("reSchedual".localized)
                        .underline()
                        .font(.regular(size: 12))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
            }
        }
    }
}

struct CountdownTimerView: View {
    var days: Int
    var hours: Int
    var minutes: Int
    
    var body: some View {
        HStack(spacing: 3) {
//            Spacer()
            ForEach([
                ("Days".localized, days),
                ("Hours".localized, hours),
                ("Minutes".localized, minutes)
            ], id: \.0) { label, value in
                VStack {
                    Text("\(value)")
                        .font(.semiBold(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 31, height: 31)
                        .background(Color(.secondaryMain))
                        .cardStyle(cornerRadius: 3)
                    
                    Text(label)
                        .font(.medium(size: 10))
                        .foregroundColor(.white)
                    //                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                        .layoutPriority(1)
                        .frame(maxWidth: .infinity)
                }
                
                if label != "Minutes".localized {
                    Text(":")
                        .font(.semiBold(size: 12))
                        .foregroundColor(.white)
                        .offset(y: -7)
                }
            }
        }
        .padding(.horizontal)
    }
}

