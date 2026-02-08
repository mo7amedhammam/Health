//
//  ReschedualeRequestsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/12/2025.
//

import SwiftUI

struct ReschedualeRequestsView: View {
    @StateObject var viewModel: ReschedualeRequestViewModel = ReschedualeRequestViewModel.shared
    
    var body: some View {
        VStack(spacing: 8) {
            TitleBar(title: "rescheduale_requests_",hasbackBtn: true)
            Spacer()
            
            if let items = viewModel.Requests, !items.isEmpty {
                SectionHeader(image: Image(.reschedualeRequestIcn), title: "requests_",MoreBtnimage: nil) {}
                    .padding(.horizontal)

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(items, id: \.self) { item in
                            ReschedualRequestCard(Request: item,acceptAction: {
                                Task{await viewModel.approuveCustomerRescheduleRequest(sessionId: item.id)}
                            },rejectAction: {
                                Task{await viewModel.approuveCustomerRescheduleRequest(sessionId: item.id,Reject: true)}
                            })
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            } else {
                ScrollView{
                    VStack(spacing: 12) {
                        Spacer(minLength: UIScreen.main.bounds.height/4)
                        Image(.reschedualeRequestIcn)
                            .resizable()
                            .frame(width: 120,height: 120)
                            .padding(.bottom)
                        
                        Text("no_requests_found".localized)
                            .font(.semiBold(size: 22))
                            .foregroundColor(Color(.btnDisabledTxt))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
            .localizeView()
            //            .withNavigation(router: router)
            .showHud(isShowing: $viewModel.isLoading )
            // Two-way binding so dismissing the alert clears the error
            .errorAlert(
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                ),
                message: viewModel.errorMessage
            )
            .task {
                await viewModel.getMyRequests()
            }
            .refreshable {
                await viewModel.refreshRequests()
            }
        
    }
}

#Preview {
    ReschedualeRequestsView()
}
