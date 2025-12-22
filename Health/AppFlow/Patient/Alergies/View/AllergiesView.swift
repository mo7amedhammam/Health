//
//  AllergiesView.swift
//  Sehaty
//
//  Created by mohamed hammam on 25/06/2025.
//

import SwiftUI

struct AllergiesView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AllergiesViewModel.shared
    @State var selectedAllergyIds: Set<Int> = []

    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Header
            TitleBar(title: "allergies_title",hasbackBtn: true)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: - Intro Text
                    
                        VStack(alignment: .leading, spacing: 10) {
                            Text("allergies_header_title".localized)
                                .font(.bold(size: 22))
                                .foregroundColor(Color(.mainBlue))
                            Text("allergies_header_subtitle".localized)
                                .font(.medium(size: 14))
                                .foregroundColor(Color(.secondary))
                                .lineSpacing(8)
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
                    
                    // MARK: - Categories and Checkboxes
//                    ForEach(allergies, id: \.allergyCategoryID) { category in
                    ForEach(viewModel.allergies ?? [], id: \.self) { category in

                        VStack(alignment: .leading, spacing: 12) {
                            Text(category.allergyCategoryName ?? "")
                                .font(.bold(size: 22))
                                .foregroundColor(Color(.mainBlue))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            WrapCheckboxList(
                                items: category.allergyList ?? [],
                                selectedIds: $selectedAllergyIds
                            )
                        }
                    }
                    .padding(.leading)
                    
//                    Spacer()

                    if viewModel.allergies?.count ?? 0 > 0  {
                        
                        // MARK: - Buttons
                        HStack(spacing: 2) {
                            CustomButton(title: "new_cancel_", backgroundView: AnyView(Color(.secondary))) {
                                dismiss()
                            }
                            
                            CustomButton(title: "new_confirm_", backgroundcolor: Color(.mainBlue)) {
                                // Submit selected IDs here
                                print("Selected IDs: \(selectedAllergyIds)")
                                Task {
                                      await viewModel.addNewAllergies(selectedIds: selectedAllergyIds)
//                                      dismiss()
                                  }
                            }
                        }
                        .padding()
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        
//        .padding()
//        .environment(\.layoutDirection, .rightToLeft)
        .onAppear {
            Task {
                   await viewModel.getMyAllergies()
                if let allergies = viewModel.allergies {
                    for category in allergies {
                        for item in category.allergyList ?? [] {
                            if (item.hasAllergy ?? false), let id = item.id {
                                selectedAllergyIds.insert(id)
                            }
                        }
                    }
                }
               }
        }
        .refreshable {
            await viewModel.getMyAllergies()
         if let allergies = viewModel.allergies {
             for category in allergies {
                 for item in category.allergyList ?? [] {
                     if (item.hasAllergy ?? false), let id = item.id {
                         selectedAllergyIds.insert(id)
                     }
                 }
             }
         }
        }
        .localizeView()
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
    }

}

#Preview {
    
    AllergiesView()
}

struct WrapCheckboxList: View {
    var items: [AllergyList]
    @Binding var selectedIds: Set<Int>

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 0)], alignment: .leading, spacing: 12) {
            ForEach(items, id: \.id) { item in
                HStack(spacing:0) {
                    Checkbox(isChecked: selectedIds.contains(item.id ?? 0)) {
//                    Checkbox(isChecked: selectedIds.contains(item.id ?? 0) ? true : (item.hasAllergy ?? false)) {
                        let id = item.id ?? 0
                        if selectedIds.contains(id) {
                            selectedIds.remove(id)
                        } else {
                            selectedIds.insert(id)
                        }
                    }
                 
                    Spacer()
                    
                    Text(item.name ?? "")
                        .font(.medium(size: 16))
                        .foregroundColor(Color(.mainBlue))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .truncationMode(.tail)
                        .minimumScaleFactor(0.9)

                }
                .padding(.leading, 2)
                .frame(height: 22)
                .background(Color(.white))
                .cornerRadius(8)
//                .onAppear {
//                    if (item.hasAllergy ?? false), let id = item.id {
//                        selectedIds.insert(id)
//                    }
//                }
            }
        }
    }
}

struct Checkbox: View {
    var isChecked: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(Color(.secondary))
        }
    }
}
