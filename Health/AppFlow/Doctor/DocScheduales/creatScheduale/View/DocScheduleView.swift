//
//  DocScheduleView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/08/2025.
//

import SwiftUI

struct DocScheduleView: View {
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject var profileViewModel: EditProfileViewModel
    @StateObject private var viewModel = DocSchedualeViewModel.shared
    var hasbackBtn : Bool? = true
    var schedualeId : Int?
    
    @State private var showDialog = false
    @State var mustLogin: Bool = false

    init(hasbackBtn : Bool? = true, schedualeId:Int? = nil) {
        self.hasbackBtn = hasbackBtn
        self.schedualeId = schedualeId
    }
    
    var body: some View {
        ZStack {
            VStack(spacing:0){
                // MARK: - Header Section
                VStack(){
                    TitleBar(title: "doc_myscehdules",titlecolor: .white,hasbackBtn: hasbackBtn ?? true)
                        .padding(.top,55)
                    
                    VStack(spacing:5){
                        
                        if let imageURL = profileViewModel.imageURL{
                            KFImageLoader(url:URL(string:Constants.imagesURL + (imageURL.validateSlashs())),placeholder: Image(.onboarding1), isOpenable:true, shouldRefetch: false)
                                .clipShape(Circle())
                                .background(Circle()
                                    .stroke(.white, lineWidth: 5).padding(-2))
                                .frame(width: 91,height:91)
                            if profileViewModel.Name.count > 0{
                                Text(profileViewModel.Name)
                                    .font(.bold(size: 24))
                                    .foregroundStyle(Color.white)
                            }else{
                                Text("home_Welcome".localized)
                                    .font(.semiBold(size: 14))
                                    .foregroundStyle(Color.white)
                            }
                        }else{
                            Spacer()
                        }
                    }
                    .background{
                        Image(.logoWaterMarkIcon)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fill)
                            .foregroundStyle(.white)
                            .allowsHitTesting(false)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                    .padding(.vertical,10)
                }
                .frame(height: 232)
                .horizontalGradientBackground()
                
                // MARK: - Date Section
                SectionHeader(image: Image(.docSchedIc), title: "select_available_dates",subTitle: Text("select_available_dates_subtitle".localized)
                    .foregroundStyle(Color(.secondary))
                    .font(.medium(size: 10))
                    .frame(maxWidth:.infinity,alignment: .leading), MoreBtnimage: nil
                )
                .padding()
                
                // From and To Date Pickers
                HStack(spacing: 8) {
                    DatePickerField(selectedDate: $viewModel.dateFrom, title: "from_date".localized,minDate: Date())
                        .onChange(of: viewModel.dateFrom) { newValue in
                            // When dateFrom changes, ensure dateTo is >= dateFrom
                            guard let from = newValue, let to = viewModel.dateTo else { return }
                            if to < from {
                                viewModel.dateTo = from
                            }
                        }

                    DatePickerField(selectedDate: $viewModel.dateTo, title: "to_date".localized,minDate: viewModel.dateFrom)
                        .disabled(viewModel.dateFrom == nil)
                        .onChange(of: viewModel.dateTo) { newValue in
                            // When dateTo changes, ensure it's not earlier than dateFrom
                            guard let to = newValue, let from = viewModel.dateFrom else { return }
                            if to < from {
                                viewModel.dateTo = from
                            }
                        }
                }
                .padding([.horizontal, .bottom])

                
                // From and To Date Pickers
//                HStack(spacing: 8) {
//                    ImprovedDatePickerField(
//                        selectedDate: $viewModel.dateFrom,
//                        title: "from_date".localized
//                    )
//                    .onChange(of: viewModel.dateFrom) { newValue in
//                        // When dateFrom changes, ensure dateTo is >= dateFrom
//                        guard let from = newValue, let to = viewModel.dateTo else { return }
//                        if to < from {
//                            viewModel.dateTo = from
//                        }
//                    }
//
//                    ImprovedDatePickerField(
//                        selectedDate: $viewModel.dateTo,
//                        title: "to_date".localized,
//                        minimumDate: viewModel.dateFrom
//                    )
//                    .disabled(viewModel.dateFrom == nil)
//                    .opacity(viewModel.dateFrom == nil ? 0.5 : 1.0)
//                }
//                .padding([.horizontal, .bottom])
                
                // MARK: - Time Slots Section
                SectionHeader(image: Image(.docSchedIc), title: "select_available_time_slots",subTitle: Text("select_available_time_slots_subtitle".localized)
                    .foregroundStyle(Color(.secondary))
                    .font(.medium(size: 10))
                    .frame(maxWidth:.infinity,alignment: .leading), MoreBtnimage: nil
                )
                .padding([.horizontal, .top])
                
                // MARK: - Days and Shifts List
                ScrollView {
                    if let dayList = viewModel.schedualeDetails?.dayList {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(Array(dayList.enumerated()), id: \.offset) { index, day in
                                if let dayId = day.dayId, let dayName = day.name {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(dayName)
                                            .font(.bold(size: 20))
                                            .foregroundColor(.mainBlue)
                                        
                                        if let shiftList = day.shiftList, !shiftList.isEmpty {
                                            HStack(spacing: 8) {
                                                ForEach(Array(shiftList.enumerated()), id: \.offset) { shiftIndex, shift in
                                                    if let shiftId = shift.shiftId {
                                                        ShiftCardView(
                                                            shift: shift,
                                                            isSelected: shift.isSelected ?? false,
                                                            onTap: {
                                                                viewModel.toggleShift(dayId: dayId, shiftId: shiftId)
                                                            }
                                                        )
                                                    }
                                                }
                                            }
                                        } else {
                                            Text("no_shifts_available".localized)
                                                .font(.medium(size: 12))
                                                .foregroundStyle(Color(.secondary))
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("no_schedule_data".localized)
                                .font(.medium(size: 16))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 50)
                    }
                    
                    // MARK: - Footer Buttons
                    HStack(spacing: 4) {
                        CustomButton(title: "new_confirm_",backgroundcolor: Color(.mainBlue)){
                            print("Creating/Updating schedule")
                            showDialog = true
                        }
                        .disabled(viewModel.dateFrom == nil || viewModel.dateTo == nil)
                        
                        CustomButton(title: "remove_all_btn",backgroundView : AnyView(Color(.secondary))){
                            viewModel.clearSelections()
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer().frame(height: hasbackBtn ?? true ? 0 : 80)
            }
            .localizeView()
            .showHud(isShowing: $viewModel.isLoading)
            .errorAlert(isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            ), message: viewModel.errorMessage)
            .edgesIgnoringSafeArea([.top,.horizontal])
            .task{
//                Task{
                    if (Helper.shared.CheckIfLoggedIn()) {
                        async let details:() = viewModel.getMySchedualeDetails(Id: schedualeId)
                        _ = await (details)
                    } else {
                        profileViewModel.cleanup()
                        viewModel.clear()
                        mustLogin = true
                    }
//                }
            }
            
            // MARK: - Confirmation Dialog
            if showDialog {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showDialog = false
                    }

                ConfirmationDialogView(
                    iconName: "doc_sched_ic",
                    message: "confirm_title",
                    confirmTitle: "new_confirm_",
                    cancelTitle: "cancel_",
                    onConfirm: {
                        print("Confirmed")
                        Task{ await viewModel.CreateOrUpdateScheduales()}
                        showDialog = false
                    },
                    onCancel: {
                        showDialog = false
                    }
                )
            }
        }
        .fullScreenCover(isPresented: $viewModel.showSuccess, onDismiss: {}, content: {
           AnyView( DocSchedualeSelectedView() )
        })
    }
}

// MARK: - Shift Card View Component
struct ShiftCardView: View {
    let shift: ShiftList
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            Text(shift.name ?? "")
                .font(.bold(size: 14))
            
            if let fromTime = shift.fromTime, let toTime = shift.toTime {
                Text("\(fromTime) - \(toTime)")
                    .font(.medium(size: 10))
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color(.secondary) : Color("wrongsurface") )
        .foregroundStyle(isSelected ? Color(.white) : Color(.secondary))
        .cornerRadius(3)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    DocScheduleView().environmentObject(EditProfileViewModel.shared)
}

extension DocScheduleView{
    private func DocSchedualeSelectedView()->any View {
        let successView = SuccessView(
            image: Image("successicon"),
            title: "schedule_success_title".localized,
            subtitle1: "schedule_success_subtitle1".localized,
            subtitle2: "schedule_success_subtitle2".localized,
            buttonTitle: "schedule_success_btn".localized,
            buttonAction: {
//                Task{await viewModel.getMyScheduales()}
                viewModel.showSuccess = false
                dismiss()
            }
        )
        return successView
    }
}


////
////  ImprovedDatePickerField.swift
////  Sehaty
////
////  Helper component for date selection with placeholder
////
//
//import SwiftUI
//
//struct ImprovedDatePickerField: View {
//    @Binding var selectedDate: Date?
//    let title: String
//    let minimumDate: Date?
//    
//    @State private var showDatePicker = false
//    @State private var tempDate: Date = Date()
//    
//    init(selectedDate: Binding<Date?>, title: String, minimumDate: Date? = nil) {
//        self._selectedDate = selectedDate
//        self.title = title
//        self.minimumDate = minimumDate
//        
//        // Initialize tempDate with selectedDate or current date
//        if let date = selectedDate.wrappedValue {
//            self._tempDate = State(initialValue: date)
//        }
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(title)
//                .font(.medium(size: 12))
//                .foregroundColor(.secondary)
//            
//            Button(action: {
//                showDatePicker = true
//                // Update tempDate when opening picker
//                if let date = selectedDate {
//                    tempDate = date
//                } else {
//                    tempDate = minimumDate ?? Date()
//                }
//            }) {
//                HStack {
//                    if let date = selectedDate {
//                        Text(formatDate(date))
//                            .font(.medium(size: 14))
//                            .foregroundColor(.primary)
//                    } else {
//                        Text("select_date".localized)
//                            .font(.medium(size: 14))
//                            .foregroundColor(.gray)
//                    }
//                    
//                    Spacer()
//                    
//                    Image(systemName: "calendar")
//                        .foregroundColor(.mainBlue)
//                }
//                .padding(12)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//            }
//        }
//        .sheet(isPresented: $showDatePicker) {
//            NavigationView {
//                VStack {
//                    DatePicker(
//                        "",
//                        selection: $tempDate,
//                        in: (minimumDate ?? Date.distantPast)...,
//                        displayedComponents: .date
//                    )
//                    .datePickerStyle(.graphical)
//                    .padding()
//                    
//                    Spacer()
//                }
//                .navigationTitle(title)
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button("cancel_".localized) {
//                            showDatePicker = false
//                        }
//                    }
//                    
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("done_".localized) {
//                            selectedDate = tempDate
//                            showDatePicker = false
//                        }
//                        .font(.bold(size: 14))
//                    }
//                }
//            }
//        }
//    }
//    
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.locale = Locale.current
//        return formatter.string(from: date)
//    }
//}
//
//// Preview
//struct ImprovedDatePickerField_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack(spacing: 20) {
//            ImprovedDatePickerField(
//                selectedDate: .constant(nil),
//                title: "From Date"
//            )
//            
//            ImprovedDatePickerField(
//                selectedDate: .constant(Date()),
//                title: "To Date"
//            )
//        }
//        .padding()
//    }
//}
