//
//  CustomerAlergyView.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/10/2025.
//

import SwiftUI

struct CustomerAlergyView: View {
    @Environment(\.dismiss) var dismiss
    @State var allergies: [CustomerAllergyListM] = mockAllergies

    var customerID : Int

    var body: some View {
        VStack {
            TitleBar(title: "laalergy_", hasbackBtn: true)
            ScrollView(showsIndicators: false) {
                          VStack(alignment: .trailing, spacing: 32) {
                              ForEach(allergies, id: \.allergyCategoryID) { category in
                                  AllergyCategoryView(category: category)
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
        //            .withNavigation(router: router)
//            .showHud(isShowing:  $viewModel.isLoading)
//            .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)

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
