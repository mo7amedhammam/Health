//
//  DocPaymentsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 24/08/2025.
//


import SwiftUI

struct DocPaymentsView: View {
    var hasbackBtn: Bool? = true
    @StateObject private var viewModel = DocPaymentsViewModel.shared

    // Mock Data (بدل الـ API لحد ما توصّلها بالباك إند)
//    let paidSubscriptions: [CustomerOrderDetailM] = [
//        CustomerOrderDetailM(packageName: "باقه كبار السن", customerPackageID: 1, cancelReason: nil, status: "نشط", date: "2023-04-10T00:00:00", amount: nil, sessionCount: 4, attendedSessionCount: 1, remainingSessionCount: 3),
//        CustomerOrderDetailM(packageName: "رياضة وتأهيل بدني", customerPackageID: 2, cancelReason: nil, status: "نشط", date: "2023-04-10T00:00:00", amount: nil, sessionCount: 4, attendedSessionCount: 1, remainingSessionCount: 3)
//    ]
    
//    let refundedAmounts: [CustomerOrderDetailM] = [
//        CustomerOrderDetailM(packageName: "باقه كبار السن", customerPackageID: 1, cancelReason: "عدم الإلتزام بالمواعيد المحددة", status: "مضافة إلى الرصيد", date: "2023-04-10T00:00:00", amount: 200, sessionCount: 4, attendedSessionCount: 1, remainingSessionCount: 3),
//        CustomerOrderDetailM(packageName: "رياضة وتأهيل بدني", customerPackageID: 2, cancelReason: "عدم الإلتزام بالمواعيد المحددة", status: "مضافة إلى الرصيد", date: "2023-04-10T00:00:00", amount: 200, sessionCount: 4, attendedSessionCount: 1, remainingSessionCount: 3)
//    ]
    
    var body: some View {
        VStack(spacing: 15) {
            // Header
            TitleBar(title: "doc_notifications", hasbackBtn: hasbackBtn ?? true)
            
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
                        
                        if let ballance = viewModel.ballance{
                        VStack(spacing: 0) {
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
                                    Text("doc_pay_due_amount".localized)
                                        .foregroundColor(.white)
                                        .font(.semiBold(size: 16))
                                    
                                    Text( ballance.totalNotPaid ?? 0.0,format:.number.precision(.fractionLength(2)))
                                        .foregroundColor(Color(.secondary))
                                        .font(.bold(size: 26))
                                }
                                
                            }
                            .padding()
                            .horizontalGradientBackground(reverse: true)
                            .cardStyle(cornerRadius: 3,shadowOpacity: 0.3)
                            .frame( height: 76)
                            
                            HStack {
                                VStack (spacing:8){
                                    Text("doc_pay_received".localized)
                                        .font(.semiBold(size: 12))
                                        .foregroundColor(Color(.mainBlue))
                                    Text(ballance.totalPaid ?? 0,format: .number)
                                        .font(.bold(size: 26))
                                        .foregroundColor(Color(.secondary))
                                }
                                .frame(maxWidth:.infinity)
                                Divider()
                                VStack (spacing:8){
                                    Text("doc_pay_total".localized)
                                        .font(.semiBold(size: 12))
                                        .foregroundColor(Color(.mainBlue))
                                    Text(ballance.total ?? 0,format: .number)
                                        .font(.bold(size: 26))
                                        .foregroundColor(Color(.secondary))
                                }
                                .frame(maxWidth:.infinity)
                                
                            }
                            
                            .background{
                                Color.white
                                HStack{
                                    Image("logoWaterMarkIcon")
                                        .resizable()
                                        .scaledToFill()
                                    //                                    .frame(width: 255, alignment: .leading)
                                }
                                //                            .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .cardStyle(cornerRadius: 3,shadowOpacity: 0.3)
                            .frame( height: 76)
                            
                        }
                        .padding(.vertical)
                        
                    }
                        
                        // Paid Subscriptions
                    if let packages = viewModel.previousSubsriptions,packages.count > 0{
                        SectionHeader(image: Image("newvippackicon"), title: "doc_Previous_details",MoreBtnimage: nil)
                        ForEach(packages, id: \.self) { pkg in
                            DocPackageCard(package: pkg)
                        }
                    }
                        //                    .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.bottom, 40)
            }
        }
        .task {
            await viewModel.getdata()
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .localizeView()
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
    }
}

#Preview {
    DocPaymentsView()
}

struct DocPackageCard: View {
    var package: DocOrderDetailM
    
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
                            
                            Text("\(package.usedSessionCount ?? 0)")
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
