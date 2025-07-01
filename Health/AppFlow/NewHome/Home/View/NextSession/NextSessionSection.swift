//
//  NextSessionSection.swift
//  Sehaty
//
//  Created by mohamed hammam on 02/07/2025.
//

import SwiftUI

struct NextSessionSection: View {
    var upcomingSession: UpcomingSessionM?

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
                    NextSessionActionsView()
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
        NextSessionSection(upcomingSession: UpcomingSessionM(id: 1, doctorName: "أحمد سامي", sessionDate: "2025-07-02T10:22:00", timeFrom: "08:12:00", packageName: "باقات كبار السن (أهالينا)", categoryName: "التغذية العلاجية", mainCategoryID: 3, categoryID: 2, sessionMethod: "method", packageID: 3,mainCategoryName: "باقات الصحة العامة") )
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
                        .font(.regular(size: 12))
                        .foregroundColor(.white)
                    Text(session?.formattedSessionTime ?? "")
                        .font(.regular(size: 12))
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
                Text("Doctor".localized)
                    .font(.regular(size: 14))
                    .foregroundColor(.white)
                Text(session?.doctorName ?? "")
                    .font(.semiBold(size: 18))
                    .foregroundColor(.white)
            }

            Spacer()
        }
    }
}
struct NextSessionCountdownOrJoinView: View {
    var session: UpcomingSessionM?

    var body: some View {
        HStack {
            Spacer()

            if session?.isJoinAvailable == true {
                Button {
                    if let link = session?.sessionMethod, let url = URL(string: link) {
                        UIApplication.shared.open(url)
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
                let countdown: (days: Int, hours: Int, minutes: Int) = session?.timeDifference() ?? (0, 0, 0)
                CountdownTimerView(days: countdown.days , hours: countdown.hours , minutes: countdown.minutes)
            }

            Spacer()
        }
    }
}
struct NextSessionActionsView: View {
    var body: some View {
        HStack(alignment: .bottom) {
            Button(action: {
                // More details action
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
            Spacer()
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
                }

                if label != "Minutes".localized {
                    Text(":")
                        .font(.medium(size: 12))
                        .foregroundColor(.white)
                        .offset(y: -7)
                }
            }
        }
    }
}

//struct NextSessionSection: View {
//    var upcomingSession: UpcomingSessionM?
//    var canJoin = true
//
//    var body: some View {
//        VStack{
//            SectionHeader(image: Image(.newnxtsessionicon),title: "home_nextSession"){
//                //                            go to last mes package
//            }
//
//            ZStack(alignment: .bottomTrailing){
//                HStack {
//                    Image(.nextsessionbg)
//                    Spacer()
//                }.padding(8)
//
//                VStack{
//                    HStack{
//                        VStack{
//                            // Title
//                            Text("pack_name".localized)
//                                .font(.semiBold(size: 14))
//                                .foregroundStyle(Color.white)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(.bottom,1)
//                            // Title
//                            Text(upcomingSession?.packageName ?? "")
//                                .font(.medium(size: 10))
//                                .foregroundStyle(Color.white)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                        }
//
//                        Spacer()
//
//                        HStack(alignment:.top) {
//
//                            VStack(){
//                                // Title
//                                Text(upcomingSession?.formatedSessionDate ?? "")
//                                    .font(.regular(size: 12))
//                                    .foregroundStyle(Color.white)
//                                    .frame(maxWidth: .infinity, alignment: .trailing)
//                                    .padding(.bottom,1)
//
//                                // Title
//                                Text(upcomingSession?.fformatedSessionTime ?? "")
//                                    .font(.regular(size: 12))
//                                    .foregroundStyle(Color.white)
//                                    .frame(maxWidth: .infinity, alignment: .trailing)
//                            }
//                            Image(.newcal)
//                                .resizable()
//                                .frame(width: 15, height: 15)
//                        }
//                    }
//                    Spacer()
//
//                    HStack{
//                        VStack{
//                            // Title
//                            Text("Doctor".localized)
//                                .font(.regular(size: 12))
//                                .foregroundStyle(Color.white)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(.bottom,1)
//                            // Title
//                            Text(upcomingSession?.doctorName ?? "")
//                                .font(.semiBold(size: 16))
//                                .foregroundStyle(Color.white)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                        }
//
//                        Spacer()
//
//                        if canJoin{
//                            Button(action: {
//
//                            }){
//                                HStack(alignment: .center){
//                                    Image(.newjoinicon)
//                                        .resizable()
//                                        .frame(width: 15, height: 15)
//
//                                    Text("Join_now".localized)
//                                        .font(.bold(size: 12))
//                                        .foregroundStyle(Color(.secondary))
//
//                                }
//                                .padding(.horizontal,13)
//                                .frame(height: 30)
//                                //                                            .padding(.vertical,15)
//                                .background{Color(.white)}
//                                .cardStyle( cornerRadius: 3)
//                            }
//                        }else{
//                            HStack(alignment:.top,spacing:3) {
//                                VStack(){
//                                    // Title
//                                    Text("2")
//                                        .font(.medium(size: 14))
//                                        .foregroundStyle(Color.white)
//                                        .frame(width: 31, height: 31)
//                                        .background{Color(.secondaryMain)}
//                                        .cardStyle( cornerRadius: 3)
//
//                                    // Title
//                                    Text("Days".localized)
//                                        .font(.regular(size: 8))
//                                        .foregroundStyle(Color.white)
//                                        .minimumScaleFactor(0.5)
//                                        .lineLimit(1)
//                                }
//
//                                Text(":")
//                                    .font(.regular(size: 12))
//                                    .foregroundStyle(Color.white)
//                                    .offset(y:10)
//
//                                VStack(){
//                                    // Title
//                                    Text("11")
//                                        .font(.medium(size: 14))
//                                        .foregroundStyle(Color.white)
//                                        .frame(width: 31, height: 31)
//                                        .background{Color(.secondaryMain)}
//                                        .cardStyle( cornerRadius: 3)
//
//                                    // Title
//                                    Text("Hours".localized)
//                                        .font(.regular(size: 8))
//                                        .foregroundStyle(Color.white)
//                                        .minimumScaleFactor(0.5)
//                                        .lineLimit(1)
//                                }
//
//                                Text(":")
//                                    .font(.regular(size: 12))
//                                    .foregroundStyle(Color.white)
//                                    .offset(y:10)
//
//                                VStack(){
//                                    // Title
//                                    Text("31")
//                                        .font(.medium(size: 14))
//                                        .foregroundStyle(Color.white)
//                                        .frame(width: 31, height: 31)
//                                        .background{Color(.secondaryMain)}
//                                        .cardStyle( cornerRadius: 3)
//
//                                    // Title
//                                    Text("Minutes".localized)
//                                        .font(.regular(size: 8))
//                                        .foregroundStyle(Color.white)
//                                        .minimumScaleFactor(0.5)
//                                        .lineLimit(1)
//                                }
//                            }
//                        }
//                        Spacer()
//
//                    }
//
//                    Spacer()
//
//                    HStack(alignment:.bottom,spacing:3) {
//
//                        Button(action: {
//
//                        }){
//                            HStack(alignment: .center){
//                                Image( .newmoreicon)
//                                    .renderingMode(.template)
//                                    .resizable()
//                                    .frame(width: 15, height: 15)
//                                    .foregroundStyle(Color.white)
//
//                                Text("more_detail".localized)
//                                    .font(.bold(size: 12))
//                                    .foregroundStyle(Color.white)
//                            }
//                            //                                        .padding(.horizontal,30)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 30)
//                            .background{Color(.secondaryMain)}
//                            .cardStyle( cornerRadius: 3)
//                        }
//
//                        Spacer()
//
//                        Button(action: {
//
//                        }){
//                            HStack(alignment: .bottom){
//                                Image(.newreschedual)
//                                    .renderingMode(.template)
//                                    .resizable()
//                                    .frame(width: 15, height: 15)
//
//                                    .foregroundStyle(Color.white)
//
//                                Text("reSchedual".localized)
//                                    .underline()
//                                    .font(.regular(size: 12))
//                                    .foregroundStyle(Color.white)
//                            }
//                            .padding(.horizontal,10)
//                            .padding(.bottom,5)
//                            .frame(alignment:.bottom)
//                        }
//                    }
//                }
//                .padding()
//            }
//            .frame(maxWidth: .infinity, maxHeight: 200)
////            .background(Color.mainBlue)
//            .horizontalGradientBackground()
//            .cardStyle(cornerRadius: 4,shadowOpacity: 0.4)
//            .padding(.bottom,5)
//
//        }
//        .padding(.vertical,5)
//        .padding(.bottom,5)
//
//    }
//}
