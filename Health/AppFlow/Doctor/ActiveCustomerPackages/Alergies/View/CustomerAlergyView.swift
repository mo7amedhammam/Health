//
//  CustomerAlergyView.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/10/2025.
//

import SwiftUI

struct CustomerAlergyView: View {
    @Environment(\.dismiss) var dismiss
    
    var customerID : Int
    @StateObject private var viewModel = CustomerAlergiesViewModel.shared

    var body: some View {
        VStack {
            TitleBar(title: "laalergy_", hasbackBtn: true)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .trailing, spacing: 32) {
                    // Use data from the view model, defaulting to empty array
                    ForEach(viewModel.allergies ?? [], id: \.allergyCategoryID) { category in
                        AllergyCategoryView(category: category)
                    }
                    
                    // Empty state
                    if (viewModel.allergies?.isEmpty ?? true) && !(viewModel.isLoading ?? false) && (viewModel.errorMessage == nil) {
                        Text("no_data_".localized)
                            .font(.medium(size: 16))
                            .foregroundColor(.mainBlue)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 24)
                    }
                    
                    // Error state
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.medium(size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 16)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            Spacer()
            
            CustomButton(title: "back_",isdisabled: false,backgroundView:AnyView(Color.clear.horizontalGradientBackground())){
                dismiss()
            }
        }
        .localizeView()
        .showHud(isShowing: $viewModel.isLoading )
        .errorAlert(isPresented:Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
        .task {
            // Bind the package/customer id and fetch
            viewModel.CustomerPackageId = customerID
            await viewModel.getCustomerAllergies()
        }
        .refreshable {
            await viewModel.getCustomerAllergies()
        }
    }
}

#Preview {
    CustomerAlergyView(customerID: 0)
}


struct AllergyCategoryView: View {
    let category: CustomerAllergyListM
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            // Category Title
            Text(category.allergyCategoryName ?? "")
                .font(.bold(size: 24))
                .foregroundColor(.mainBlue)
                .multilineTextAlignment(.trailing)
            
            // Allergy items
            VStack(alignment: .trailing, spacing: 6) {
                ForEach(category.allergyList ?? [], id: \.id) { item in
                    Text(item.name ?? "")
                        .font(.medium(size: 18))
                        .foregroundColor(.mainBlue)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

