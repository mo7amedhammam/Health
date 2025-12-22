//
//  MyPaymentsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/06/2025.
//

import SwiftUI

struct MyPaymentsView: View {
    
    @EnvironmentObject var viewModel : MyPaymentsViewModel
    
    // MARK: - Mock / ViewModel Data
    //      var balance: Double = 12400
    
//    var pastPackages: [CustomerOrderDetailM] = [
//        .init(packageName: "باقة كبار السن", customerPackageID: 1, cancelReason: nil, status: nil, date: "10 Apr 2023", amount: nil, sessionCount: 4, attendedSessionCount: 1, remainingSessionCount: 3)
//        //          ,
//        //          .init(packageName: "رياضة وتأهيل بدني", customerPackageID: 2, cancelReason: nil, status: nil, date: "10 Apr 2023", amount: nil, sessionCount: 4, attendedSessionCount: 1, remainingSessionCount: 3)
//    ]
    
//    var refundedAmounts: [CustomerOrderDetailM] = [
//        .init(packageName: nil, customerPackageID: nil, cancelReason: "عدم الإلتزام بالمواعيد المحددة", status: "مضافة إلى الرصيد", date: "10 Apr 2023", amount: 200, sessionCount: 4, attendedSessionCount: 1, remainingSessionCount: 3),
//        .init(packageName: nil, customerPackageID: nil, cancelReason: "عدم الإلتزام بالمواعيد المحددة", status: "مضافة إلى الرصيد", date: "10 Apr 2023", amount: 200, sessionCount: 4, attendedSessionCount: 1, remainingSessionCount: 3)
//    ]
    
    var body: some View {
        //        NavigationView {
        VStack(spacing: 0) {
            TitleBar(title: "payments_title",hasbackBtn: true)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("payments_header".localized)
                            .font(.bold(size: 22))
                            .foregroundColor(Color(.mainBlue))
                            .lineSpacing(5)
                        
                        Text("payments_subheader".localized)
                            .font(.medium(size: 14))
                            .foregroundColor(Color(.secondary))
                            .lineSpacing(7)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .background{
                        HStack{
                            Image("logoWaterMarkIcon")
                                .resizable()
                                .frame(width: 255, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            // Balance Card
                            HStack{
                                Image("walletIcon")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 44)

                                Text("payments_currentballance".localized)
                                    .foregroundColor(.white)
                                    .font(.semiBold(size: 22))
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("payments_wallet".localized)
                                        .foregroundColor(.white)
                                        .font(.semiBold(size: 16))
                                    
                                    Text(viewModel.ballance?.balance ?? 0.0,format:.number.precision(.fractionLength(2)))
                                        .foregroundColor(Color(.secondary))
                                        .font(.bold(size: 26))
                                }

                            }
                            .padding()
                            .horizontalGradientBackground(reverse: true)
                            .cardStyle(cornerRadius: 3,shadowOpacity: 0.3)
                            .frame( height: 76)
                            
                            if let packages = viewModel.previousSubsriptions,packages.count > 0{
                                // Past Packages
                                SectionHeader(image: Image("newvippackicon"), title: "payments_Previous_details",MoreBtnimage: nil)
                                
                                ForEach(packages, id: \ .customerPackageID){ pkg in
                                    PackageCard(package: pkg)
                                }
                            }
                            
                            if let refunded = viewModel.refundedSubsriptions,refunded.count > 0{
                                // Refunded
                                SectionHeader(image: Image("newvippackicon"), title: "payments_refund",MoreBtnimage: nil)
                                
                                ForEach(refunded, id: \ .customerPackageID){ pkg in
                                    RefundCard(package: pkg)
                                }
                            }
                            
                            // Notes
                            SectionHeader(image: Image("payments_notes"), title: "payments_notes",MoreBtnimage: nil)
                            
                            VStack(alignment: .leading, spacing: 15){
                                NoteRow(text: "payment_note1".localized)
                                NoteRow(text: "payment_note2".localized)
                                NoteRow(text: "payment_note3".localized)
                            }
                            .padding(20)
//                            .background(Color("mainBlue"))
                            .cardStyle(backgroundColor: .mainBlue,cornerRadius: 3,shadowOpacity: 0.3)
//                            .cornerRadius(3)
                        }
                        .padding()
                    }
                }
            }
            .padding(.top,40)
            
            Spacer()
        }
        .onAppear {
            Task {
                viewModel.isLoading = true
                defer { viewModel.isLoading = false}
                
                async let balance: () = viewModel.getMyBallance()
                async let previous: () = viewModel.getPreviousSubsriptions()
                async let refunded: () = viewModel.getRefundedSubsriptions()
                // Wait for all tasks to complete
                _ = await (balance, previous, refunded)
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .localizeView()
//        .reversLocalizeView()
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
    }
}

#Preview {
    MyPaymentsView().environmentObject(MyPaymentsViewModel.shared)
}


struct PackageCard: View {
    var package: CustomerOrderDetailM
    
    var body: some View {
        
        HStack(alignment: .firstTextBaseline ) {
            Image("payments_packagename")
                .foregroundColor(Color(.secondary))
            
            VStack(alignment: .leading, spacing: 12) {
                // Title & icon
                Text(package.packageName ?? "")
                    .font(.bold(size: 22))
                    .foregroundColor(Color(.main))
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                HStack{
                    VStack(alignment: .leading){
                        VStack(alignment: .leading, spacing: 4) {
                            Text("payments_buy_date".localized)
                                .font(.medium(size: 12))
                                .foregroundColor(Color(.secondary))
                            
                            Text(package.formattedDate ?? "" )
                                .font(.medium(size: 14))
                                .foregroundColor(.mainBlue)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("payments_sessionCount".localized)
                                .font(.medium(size: 12))
                                .foregroundColor(Color(.secondary))
                            
                            Text("\(package.sessionCount ?? 0)")
                                .font(.medium(size: 14))
                                .foregroundColor(.mainBlue)
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    VStack(alignment: .leading){
                        VStack(alignment: .leading, spacing: 4) {
                            Text("payments_sessionused".localized)
                                .font(.medium(size: 12))
                                .foregroundColor(Color(.secondary))
                            
                            Text("\(package.attendedSessionCount ?? 0)")
                                .font(.bold(size: 14))
                                .foregroundColor(.mainBlue)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("payments_sessionsREmaining".localized)
                                .font(.medium(size: 12))
                                .foregroundColor(Color(.secondary))
                            
                            Text("\(package.remainingSessionCount ?? 0)")
                                .font(.bold(size: 14))
                                .foregroundColor(.mainBlue)
                        }
                    }
                }
            }
        }
        .padding()
        .cardStyle(cornerRadius: 3,shadowOpacity: 0.2)
    }
}
//#Preview{
//    PackageCard(package: CustomerOrderDetailM.init(packageName: "dsdsd dsdsd fsfsf", customerPackageID: 2, cancelReason: "Sfdfdfweafcafcaedfd few few few f ew f ew f ew f. Ew f e f. Feed me and ewrmf ", status: "", date: "2025-07-06T00:00:00", amount: 2, sessionCount: 10, attendedSessionCount: 4, remainingSessionCount: 6))
//}

struct RefundCard: View {
    var package: CustomerOrderDetailM
    
    var isRefunded: Bool = true
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading,spacing: 4) {
                HStack {
                    Image("payments_card_status")
                    
                    Text("payments_refundStatus".localized)
                        .font(.medium(size: 12))
                        .foregroundColor(Color(.secondary))
                }
                //                    .frame(maxWidth: .infinity,alignment: .leading)
                
                
                Text(package.status ?? "")
                    .font(.medium(size: 14))
                    .foregroundColor(.mainBlue)
                //                            .frame(maxWidth: .infinity,alignment: .leading)
                
                if let reason = package.cancelReason {
                    HStack {
                        Image("payments_reason")
                        
                        Text("payments_refundReason".localized)
                            .font(.medium(size: 12))
                            .foregroundColor(Color(.secondary))
                    }
                    //                        .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.top, 6)
                    
                    Text(reason)
                        .font(.medium(size: 14))
                        .foregroundColor(.mainBlue)
                    //                                .frame(maxWidth: .infinity,alignment: .leading)
                    
                }
                
                VStack(alignment: .leading) {
                    HStack{
                        Image("dateicon 1")
                            .resizable()
                            .frame(width: 10,height: 10)
                        
                        Text("payments_buy_date".localized)
                            .font(.medium(size: 12))
                            .foregroundColor(Color(.secondary))
                        //                            .frame(maxWidth: .infinity,alignment: .leading)
                        
                    }
                    .padding(.top, 6)
                    //                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Text(package.formattedDate ?? "")
                        .font(.medium(size: 14))
                        .foregroundColor(.mainBlue)
                }
            }
            //                .frame(maxWidth: .infinity,alignment: .leading)
//            .layoutPriority(1)
            
            Spacer()
            
            VStack(alignment: .leading,spacing: 4) {
                //
                //                VStack(alignment: .leading){
                VStack(alignment: .leading) {
                    Text("payments_sessionused".localized)
                        .font(.medium(size: 12))
                        .foregroundColor(Color(.secondary))
                    
                    Text("\(package.attendedSessionCount ?? 0)")
                        .font(.bold(size: 14))
                        .foregroundColor(.mainBlue)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("payments_sessionsREmaining".localized)
                        .font(.medium(size: 12))
                        .foregroundColor(Color(.secondary))
                    
                    Text("\(package.remainingSessionCount ?? 0)")
                        .font(.bold(size: 14))
                        .foregroundColor(.mainBlue)
                }
                //                }
                Spacer()
                
                
                if let amount = package.amount {
                    HStack {
                        Image("payments_money")
                        
                        Text("payments_refundAmount".localized)
                            .font(.medium(size: 12))
                            .foregroundColor(Color(.secondary))
                        
//                        Spacer()
                    }
                    .padding(.top, 6)
                    
                    (Text("\(amount)")+Text("payments_egp".localized))
                        .font(.medium(size: 14))
                        .foregroundColor(.mainBlue)
                }
            }
//                        .frame(maxWidth: .infinity,alignment: .leading)
            //            .layoutPriority(0.5)
            .fixedSize(horizontal: false, vertical: true) // <- restrict width
            
        }
        .padding()
        .cardStyle(cornerRadius: 3,shadowOpacity: 0.2)
        
    }
}
#Preview{
    RefundCard(package: CustomerOrderDetailM.init(packageName: "", customerPackageID: 2, cancelReason: "", status: "", date: "2025-07-06T00:00:00", amount: 2, sessionCount: 10, attendedSessionCount: 4, remainingSessionCount: 6), isRefunded: true)
}

struct NoteRow: View {
    var text: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color.red)
                .frame(width:6, height: 6)
                .padding(.top, 5)
            Text(text)
                .font(.medium(size: 16))
                .foregroundColor(.white)
                .lineSpacing(5)
        }
    }
}
