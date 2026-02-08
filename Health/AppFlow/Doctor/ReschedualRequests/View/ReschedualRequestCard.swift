//
//  ReschedualRequestCard.swift
//  Sehaty
//
//  Created by mohamed hammam on 24/12/2025.
//

import SwiftUI

struct ReschedualRequestCard: View {
    var Request: ReSchedualeRequestM?
    var acceptAction: (() -> Void)?
    var rejectAction: (() -> Void)?

    var body: some View {
        VStack {
//            SectionHeader(image: Image(.reschedualeRequestIcn), title: "requests_",MoreBtnimage: nil) {}
            
            ZStack(alignment: .bottomTrailing) {
                HStack {
                    Image(.nextsessionbg)
                    Spacer()
                }.padding(8)
                
                VStack(spacing: 20) {
                    ReschedualRequestCardHeaderView(Request: Request)
                    HStack{
                        ReschedualRequestCardDoctorView(Request: Request)
                        ReschedualRequestCardCountdownOrJoinView(Request: Request)
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
    ReschedualRequestCard(Request: ReSchedualeRequestM(
        id: 48,
        oldDate: "2026-02-07T00:00:00",
        oldTimeFrom: "15:00:00",
        package: "",
        category: "",
        doctor: "mahmoud",
        customerPackageID: 87,
        doctorID: 47,
        sessionID: 170,
        shiftID: 2,
        startDate: "2026-02-15T00:00:00",
        timeFrom: "17:00:00"
      ) )
}

struct ReschedualRequestCardHeaderView: View {
    var Request: ReSchedualeRequestM?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                //                Text("pack_name".localized)
                //                    .font(.bold(size: 18))
                //                    .foregroundColor(.white)
                Text(Request?.package ?? "")
                    .font(.bold(size: 18))
                    .foregroundColor(.white)
                
                Text(Request?.mainCategory ?? "")
                    .font(.semiBold(size: 14))
                    .foregroundColor(.white)
                    .padding(.top,3)
                Text(Request?.category ?? "")
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

                    Text(Request?.formattedOldDate ?? "")
                        .font(.regular(size: 13))
                        .foregroundColor(.white)
                    Text(Request?.formattedOldTime ?? "")
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
    var Request: ReSchedualeRequestM?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
//                let nametitle = Helper.shared.getSelectedUserType() == .Doctor ? "Patient".localized : "Doctor".localized

                    Text("Patient")
                        .font(.regular(size: 14))
                        .foregroundColor(.white)
                Text(Request?.customer ?? "")
                    .font(.semiBold(size: 18))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
    }
}
struct ReschedualRequestCardCountdownOrJoinView: View {
    var Request: ReSchedualeRequestM?
    
    @State private var countdown: (days: Int, hours: Int, minutes: Int) = (0, 0, 0)
    @State private var timer: Timer?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .trailing, spacing: 4) {
                Text("new_schedual_".localized)
                    .font(.semiBold(size: 13))
                    .foregroundColor(Color(.secondary))
                    .padding(3)

                Text(Request?.formattedNewDate ?? "")
                    .font(.regular(size: 13))
                    .foregroundColor(.white)
                Text(Request?.formattedNewTime ?? "")
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

