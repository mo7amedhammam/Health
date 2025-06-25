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
                    ForEach(viewModel.allergies ?? [], id: \.allergyCategoryID) { category in

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

                    if viewModel.allergies?.count == 0  {
                        
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
               }
        }
    }

//    // MARK: - Mock (replace with API call)
//    func loadMockData() {
//        allergies = [
//            AllergiesMElement(allergyCategoryID: 1, allergyCategoryName: "حساسية الطعام", allergyList: [
//                .init(id: 1, name: "منتجات الألبان"),
//                .init(id: 2, name: "الجلوتين"),
//                .init(id: 3, name: "المكسرات"),
//                .init(id: 4, name: "المحار والأسماك"),
//                .init(id: 5, name: "الصويا"),
//                .init(id: 6, name: "البيض"),
//                .init(id: 7, name: "الشوكولاتة")
//            ]),
//            AllergiesMElement(allergyCategoryID: 2, allergyCategoryName: "حساسية الأدوية", allergyList: [
//                .init(id: 8, name: "البنسلين"),
//                .init(id: 9, name: "الأيبوبروفين"),
//                .init(id: 10, name: "الأسبرين"),
//                .init(id: 11, name: "المضادات الحيوية الأخرى")
//            ]),
//            AllergiesMElement(allergyCategoryID: 3, allergyCategoryName: "حساسية بيئية", allergyList: [
//                .init(id: 12, name: "العفن والرطوبة"),
//                .init(id: 13, name: "حبوب اللقاح"),
//                .init(id: 14, name: "وبر الحيوانات"),
//                .init(id: 15, name: "الغبار")
//            ]),
//            AllergiesMElement(allergyCategoryID: 4, allergyCategoryName: "حساسية الجلد", allergyList: [
//                .init(id: 16, name: "اللاتكس"),
//                .init(id: 17, name: "بعض أنواع الكريمات"),
//                .init(id: 18, name: "بعض أنواع المنظفات"),
//                .init(id: 19, name: "المعادن")
//            ]),
//            AllergiesMElement(allergyCategoryID: 5, allergyCategoryName: "حساسية الجهاز التنفسي", allergyList: [
//                .init(id: 20, name: "الربو"),
//                .init(id: 21, name: "الروائح القوية"),
//                .init(id: 22, name: "البخور والدخان")
//            ])
//        ]
//    }
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
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color(.mainBlue), lineWidth: 1)
//                )
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
