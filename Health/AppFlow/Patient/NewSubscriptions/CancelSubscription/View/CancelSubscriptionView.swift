//
//  CancelSubscriptionView.swift
//  Sehaty
//
//  Created by mohamed hammam on 01/06/2025.
//

import SwiftUI

struct CancelSubscriptionView: View {
//    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CancelSubscriptionViewModel = .init()
    @Binding var isPresent: Bool
    var customerPackageId:Int
    @State var reason: String = ""
    var onCancelSuccess: (() -> Void)? = nil // ✅ new callback

    var body: some View {
        ZStack{
            VStack{
                Image("cancelsubscription")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color(.secondary))
                    .frame(width: 54,height: 45)
                    .aspectRatio(contentMode: .fill)

                Text("cancel_confirmation_title".localized)
                    .font(.semiBold(size: 16))
                    .foregroundStyle(Color(.main))
                    .padding()
                
                VStack(alignment: .leading){
                    HStack{
                        Text("cancel_reason_title".localized)
                            .font(.semiBold(size: 20))
                            .foregroundStyle(Color(.main))
                            .frame(maxWidth:.infinity,alignment: .leading)
                        
                        Image("messagecentrepopup")
                            .resizable()
                            .frame(width: 16,height: 16)
                            .aspectRatio(contentMode: .fill)
                        
                    }
                    
                    if #available(iOS 16.0, *) {
                        TextField("cancel_placeholder".localized, text: $reason, axis: .vertical)
                            .padding(.vertical)
                            .font(.medium(size: 16))
                        
                    } else {
                        // Fallback on earlier versions
                        TextField("cancel_placeholder".localized, text: $reason)
                            .padding(.vertical)
                            .font(.medium(size: 16))
                    }
                }
                
                HStack(spacing:20){
                    CustomButton(title: "cancel_",backgroundcolor: Color(.secondary),backgroundView:nil){
                        isPresent = false
                    }

                    CustomButton(title: "confirm_",backgroundcolor: Color(.mainBlue),backgroundView:nil){
                        Task{
                            if reason.count > 0 {
                                viewModel.reason = reason
                            }
                            await viewModel.cancelSubscription()
                        }
                    }
                }
            }
            .padding()
            .cardStyle(cornerRadius: 3)
            .padding(30)
        }
        .localizeView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{Color.black.opacity(0.4)}
        .ignoresSafeArea()
        .onAppear(){
            Task{
                viewModel.customerPackageId = customerPackageId
            }
        }
        .onChange(of: viewModel.isCancelled){newval in
            guard newval == true else{return}
            isPresent = false
            onCancelSuccess?() // ✅ trigger callback
        }
    }
}

#Preview {
    CancelSubscriptionView(isPresent: .constant(false), customerPackageId: 0)
}
