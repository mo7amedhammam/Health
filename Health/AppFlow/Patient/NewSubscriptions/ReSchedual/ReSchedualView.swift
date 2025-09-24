//
//  ReSchedualView.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/07/2025.
//
enum reschedualCases{
    case nextSession
    case reschedualSession
}
import SwiftUI

struct ReSchedualView: View {
    var doctorPackageId : Int?
    @StateObject var viewModel = ReSchedualViewModel.shared
    @State private var showingDatePicker = false
    @State private var selectedDate = Date()
    @Binding var isPresentingNewMeasurementSheet:Bool
    var reschedualcase:reschedualCases? = .reschedualSession
    // New: callback to run after success
    var onRescheduleSuccess: (() -> Void)? = nil
    
    var body: some View {
        VStack{
            
            HStack {
                Spacer()
                Button(action: {
                    isPresentingNewMeasurementSheet = false
                }) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.pink)
                }
            }
            .offset(y:30)
            .padding(.horizontal)

            let title = reschedualcase == .nextSession ? "Next_Session_selection".localized : "ReSchedualling_".localized
            SectionHeader(image: Image(.newreschedual),imageForground: Color(.secondary),title: title ,MoreBtnimage: nil ){
                //                            go to last mes package
            }
            .padding()
            
            //                    YearMonthPickerView(selectedDate: $selectedDate)
            
            HStack{
                Button(action: {
                    showingDatePicker = true
                    
                }, label: {
                    HStack(alignment: .center){
                        Text(selectedDate,format:.customDateFormat("MMM - yyyy"))
                            .foregroundStyle(Color(.mainBlue))
                            .font(.medium(size: 12))
                        
                        Image(systemName: "chevron.forward")
                            .font(.system(size: 8))
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.white)
                        //                                    .padding(6)
                            .background(Color(.secondary).cornerRadius(1))
                    }
                })
                .customSheet(isPresented: $showingDatePicker,height: 250, radius: 12, content: {
                    VStack(spacing:0){
                        MonthYearPicker(date: $selectedDate)
                            .frame(maxHeight: .infinity) // Adjust height
                        Button(action: {
                            showingDatePicker = false
                            guard selectedDate != viewModel.newDate else {return}
                            viewModel.newDate = selectedDate
                            
                        }) {
                            Text("Done".localized)
                                .font(.bold(size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background{LinearGradient(gradient: Gradient(colors: [.mainBlue, Color(.secondary)]), startPoint: .leading, endPoint: .trailing)}
                                .cardStyle(cornerRadius: 6)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    }
                })
                .task(id: viewModel.newDate){
                    await viewModel.getAvailableDays()
                }
                
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            .padding(.horizontal)
            
            ScrollView(.horizontal,showsIndicators: false){
                
                HStack{
                    ForEach(viewModel.availableDays ?? [],id: \.self){day in
                        Button(action: {
                            viewModel.selectedDay = day
                            viewModel.selectedShift = nil
                            viewModel.selectedSchedual = nil
                            Task{
                                await viewModel.getAvailableShifts()
                            }
                        }, label: {
                            VStack{
                                Text("\(day.date ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd"))
                                    .font(.semiBold(size: 14))
                                
                                Text(day.dayName ?? "")
                                    .font(.medium(size: 10))
                            }
                            .frame(width: 40, height: 50)
                        })
                        .foregroundStyle(Color.white)
                        .background(viewModel.selectedDay == day ? Color(.secondary) : Color(.mainBlue))
                        .cardStyle(cornerRadius: 2)
                        .padding(2)
                    }
                }
            }
            .padding(.horizontal)
            
            GeometryReader { geometry in
                
                ScrollView(.horizontal,showsIndicators: false){
                    
                    HStack(alignment: .center,spacing: 5){
                        ForEach(viewModel.availableShifts ?? [],id: \.self){shift in
                            Button(action: {
                                viewModel.selectedShift = shift
                                viewModel.selectedSchedual = nil
                                Task{
                                    await viewModel.getAvailableScheduals()
                                }
                            }, label: {
                                VStack(spacing: 5){
                                    Text(shift.name ?? "")
                                        .font(.bold(size: 10))
                                    
                                    (Text("\(shift.timeFrom ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")) + Text(" - ") + Text("\(shift.timeTo ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")))
                                        .font(.medium(size: 9))
                                }
                            })
                            .frame( height: 36)
                            .frame(width: (geometry.size.width/3) - 15)
                            .foregroundStyle(viewModel.selectedShift == shift ? Color.white : Color(.secondary))
                            .cardStyle(backgroundColor: viewModel.selectedShift == shift ? Color(.secondary) : Color(.wrongsurface),cornerRadius: 2,shadowOpacity:0)
                        }
                    }
                }
                .padding(.horizontal)
            }
            if let scheduals = viewModel.availableScheduals,scheduals.count > 0{
                SshedualsGrid(scheduals:scheduals,selectedschedual:$viewModel.selectedSchedual)
                    .padding(.top)
            }
            
            HStack(spacing: 16) {
                CustomButton(title: "cancel_",backgroundcolor: Color(.secondary),backgroundView:nil){
                    isPresentingNewMeasurementSheet = false
                }

                CustomButton(title: "confirm_",backgroundcolor: Color(.mainBlue),backgroundView:nil){
                    Task{
                        // Call the reschedule method (to be added in ViewModel)
                        switch reschedualcase {
                        case .nextSession:
                            await viewModel.createCustomerPackage(paramters: [:] )

                        case .reschedualSession,.none:
                            await viewModel.rescheduleCustomerPackage()

                        }
                    }
                }
            }
            .padding(.top)
        }
        .task {
            // Run sequentially and await completion on the view’s task context (non-blocking UI, but ordered)
            viewModel.doctorPackageId = doctorPackageId
            await viewModel.getDoctorPackageDetails()
            await viewModel.getAvailableDays()
        }
        // React to success
        .onChange(of: viewModel.isReschedualed) { newValue in
            guard newValue == true else { return }
            isPresentingNewMeasurementSheet = false
            onRescheduleSuccess?()
            // reset so future sheets can trigger again if needed
            viewModel.isReschedualed = false
        }
    }
}

#Preview {
    ReSchedualView( doctorPackageId: 0,isPresentingNewMeasurementSheet: .constant(true),reschedualcase: .reschedualSession)
}
