//
//  MedicationReminderView.swift
//  Sehaty
//
//  Created by mohamed hammam on 18/07/2025.
//

import SwiftUI

struct MedicationReminderView: View {
    @StateObject private var viewModel = MedicationReminderViewModel.shared
//    @State private var showAddSheet = true
    @State private var showFilterSheet = false

    var body: some View {
        VStack(spacing: 8) {
            TitleBar(title: "reminder_title", hasbackBtn: true)

            Button(action: {
                viewModel.showAddSheet = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(.secondary))
                        .font(.regular(size: 20))
                        .padding(5)
                        .background(Color(.white).cornerRadius(3))
                    
                    Text("add_new_reminder".localized)
                        .font(.bold(size: 24))
                }
                .foregroundColor(.white)
                .padding()
//                .frame(maxWidth: .infinity)
                .horizontalGradientBackground()
                .cardStyle(cornerRadius: 3)
            }
            .padding()

                if viewModel.reminders?.items?.count == 0 {
                VStack {
                    Spacer()
                    Image(.noreminders)
                    
                    Text("no_reminders".localized)
                        .foregroundColor(Color(.btnDisabledTxt))
                    Spacer()
                }
                } else {
                    let image = Image("newfilter").resizable().frame(width: 31,height: 31)
                    SectionHeader(image: Image("newlastmesicon"),title: "your_reminders",trailingView: AnyView(image)){
                    //                            go to last mes package
                }
                .padding([.horizontal])
                        List(viewModel.reminders?.items ?? [],id: \.self) { reminder in
                            ReminderCardView(item: reminder)
                                .listRowSeparator(.hidden)
                                .onAppear {
                                    Task{
                                        guard reminder == viewModel.reminders?.items?.last else {return}
                                        await viewModel.loadMoreIfNeeded()
                                    }
                                }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            await viewModel.refresh()
                        }
            }
        }
        .task{
//            Task{
                await viewModel.refresh()
//            }
        }
        .localizeView()
        .showHud(isShowing: $viewModel.isLoading)
        .customSheet(isPresented: $viewModel.showAddSheet,height: 570){
            AddReminderSheet().environmentObject(viewModel)
        }
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil && !viewModel.showAddSheet},
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)

//        .sheet(isPresented: $showFilterSheet) {
//            FilterReminderSheet(filter: $viewModel.filter)
//        }
    }
}

#Preview {
    MedicationReminderView()
}


struct ReminderCardView: View {
    let item: ItemNoti

    var isActive: Bool {
        item.active == true
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image("inactivedrugicon")
                
                Text(item.drugTitle ?? "")
                    .font(.semiBold(size: 22))
                    .foregroundColor(isActive ? Color(.mainBlue) : Color.red)
            }
            .padding(.bottom,10)

            Group {
                reminderRow(label: "rem_start_date", value: item.formatedStartDate ?? "-")
                Divider()
                reminderRow(label: "rem_start_time", value: item.formatedStartTime ?? "-")
                Divider()
                reminderRow(label: "rem_drug_every", value: "\(item.count ?? 0) " + (item.doseTimeTitle ?? ""))
                Divider()
                reminderRow(label: "rem_drug_duration", value: "\(item.days ?? 0) " + "days_".localized)
                Divider()
                reminderRow(label: "rem_end_date", value: item.formatedEndDate ?? "-")
            }

            Text(isActive ? "drug_active".localized : "drug_expired".localized)
                .font(.semiBold(size: 20))
                .foregroundColor(isActive ? .mainBlue : .red)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top,10)
        }
        .padding()
        .background(isActive ? Color.white : Color(.red).opacity(0.1))
        .cardStyle(cornerRadius: 5, shadowOpacity: 0.1 )
        .animation(.easeInOut, value: isActive)
    }

    private func reminderRow(label: String, value: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(Color(.wrong)).frame(width: 6, height: 6)
            Text(label.localized)
                .font(.medium(size: 16))
                .foregroundColor(isActive ? Color(.mainBlue) : Color(.wrong))
            Spacer()
            Text(value)
                .font(.medium(size: 16))
                .foregroundColor(isActive ? Color(.mainBlue) : Color(.wrong))
        }
    }
}


struct AddReminderSheet: View {
    @EnvironmentObject var viewModel: MedicationReminderViewModel

    var body: some View {
        VStack(spacing: 10) {
            // Header
            HStack {
                Image(systemName: "plus")
                    .foregroundStyle(Color(.white))
                    .frame(width: 20,height: 20)
                    .padding(5)
                    .background(Color(.secondary).cornerRadius(3))
                
                Text("add_medication_sheet_tittle".localized)
                    .font(.bold(size: 22))
                    .foregroundColor(.mainBlue)
                    .frame(maxWidth: .infinity,alignment: .leading)

                Spacer()
                
                Button(action: {
                    viewModel.showAddSheet = false
                    viewModel.clear()
                }) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.pink)
                }
                .offset(y:-20)
                Spacer()
            }
            .padding(.top)

            // Fields
            Group {
                CustomDropListInputFieldUI(title: "add_medication_name_itle", placeholder: "add_medication_name_placeholder",text: $viewModel.drugName, isDisabled: false, showDropdownIndicator:false, trailingView: AnyView(Image("newfienameIcon")))
                
                CustomDatePickerField(selectedDate: $viewModel.startDate) {
                    HStack {
                        CustomDropListInputFieldUI(title: "add_medication_start_date_title", placeholder: "add_medication_start_date_placeholder",text: $viewModel.formattedDate, isDisabled: true, showDropdownIndicator:false, trailingView: AnyView(Image("dateicon 1")))
                    }
                }
                
                CustomDatePickerField(selectedDate: $viewModel.startTime,showTime: true) {
                    HStack {
                        CustomDropListInputFieldUI(title: "add_medication_start_time_title", placeholder: "add_medication_start_time_placeholder",text: $viewModel.formattedTime, isDisabled: true, showDropdownIndicator:false, trailingView: AnyView(Image(.reminderTimeclock)))
                    }
                }

                CustomDropListInputFieldUI(title: "add_medication_frequency_title", placeholder: "add_medication_frequency_placeholder",text: $viewModel.frequencyValue, isDisabled: false, showDropdownIndicator:false, trailingView: AnyView(Image(.reminderDura)))
                    .keyboardType(.asciiCapableNumberPad)

                // Frequency Unit Radio Buttons
                HStack {
                    Spacer()
                    ForEach(FrequencyUnit.allCases, id: \.self) { unit in
                        HStack {                            
                            Image(viewModel.frequencyUnit == unit ? .radiofill : .radio)
                            
                            Text(unit.rawValue.localized)
                                .font(.bold(size: 14))
                                .foregroundColor(.mainBlue)
                        }
                        .onTapGesture {
                            viewModel.frequencyUnit = unit
                        }
                    }
                }
                
                CustomDropListInputFieldUI(title: "add_duration_title", placeholder: "add_duration_placeholder",text: $viewModel.durationDays, isDisabled: false, showDropdownIndicator:false, trailingView: AnyView(Image(.reminderDura)))
                    .keyboardType(.asciiCapableNumberPad)
            }

            HStack(spacing: 20) {
                CustomButton(title: "cancel_",backgroundcolor: Color(.secondary),backgroundView:nil){
                    viewModel.showAddSheet = false
                }

                CustomButton(title: "confirm_",backgroundcolor: Color(.mainBlue),backgroundView:nil){
                    Task{
                        await viewModel.CreateNotification()
                    }
    //                    viewModel.isPresentingNewMeasurementSheet = false
                }
            }
            .padding(.top)
        }
        .padding()
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)

    }
}
