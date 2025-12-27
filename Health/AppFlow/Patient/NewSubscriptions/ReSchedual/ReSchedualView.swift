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
    @Binding var doctorId : Int?
    @Binding var packageId : Int?
    @Binding var SessionId : Int?

    @StateObject var viewModel = ReSchedualViewModel() // fresh instance per sheet
    @State private var showingDatePicker = false
    @State private var selectedDate = Date()
    @Binding var isPresentingNewMeasurementSheet:Bool
    @Binding var reschedualcase:reschedualCases?
    // New: callback to run after success
    var onRescheduleSuccess: (() -> Void)? = nil
    
    var body: some View {
        VStack{
            
            ZStack{
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
                //                .offset(y:30)
                //                .padding(.horizontal)
                
                let title = reschedualcase == .nextSession ? "Next_Session_selection".localized : "ReSchedualling_".localized
                SectionHeader(image: Image(.newreschedual),imageForground: Color(.secondary),title: title ,MoreBtnimage: nil){
                    //                            go to last mes package
                }
            }  .padding([.horizontal])
                .padding(.vertical,8)
                
            
            
            ScrollView(.vertical,showsIndicators: false){
                HStack{
                    Button(action: {
                        showingDatePicker = true
                        
                    }, label: {
                        HStack(alignment: .center){
                            Text(selectedDate,format:.customDateFormat("MMM - yyyy"))
                                .foregroundStyle(Color(.mainBlue))
                                .font(.medium(size: 16))

                            Image(systemName: "chevron.forward")
                                .font(.system(size: 10, weight: .bold, design: .default))
                                .frame(width: 17, height: 17)
                                .foregroundStyle(Color.white)
                                .background(Color(.secondary).cornerRadius(1))
                        }
                        .padding(8)
                    })
                    .customSheet(isPresented: $showingDatePicker,height: 250, radius: 12, content: {
                        VStack(spacing:0){
                            MonthYearPicker(date: $selectedDate)
                                .frame(maxHeight: .infinity)
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
                    HStack(spacing:2.5){
                        ForEach(viewModel.availableDays ?? [],id: \.self){day in
                            Button(action: {
                                viewModel.selectedDay = day
                                viewModel.selectedShift = nil
                                viewModel.selectedSchedual = nil
                                Task{
                                    await viewModel.getAvailableShifts()
                                }
                            }, label: {
                                VStack(spacing:5) {
                                    Text("\(day.formattedDate ?? "")")
                                        .font(.semiBold(size: 16))
                                    
                                    Text(day.dayName ?? "")
                                        .font(.medium(size: 14))
                                }
                                .frame(height: 60)
                                .frame(width: 66)
                            })
                            .foregroundStyle(Color.white)
                            .background(viewModel.selectedDay == day ? Color(.secondary) : Color(.mainBlue))
                            .cardStyle(cornerRadius: 2)
                            .padding(2)
                        }
                    }
                }
                .padding(.horizontal,12)
//                .padding(.top,10)

//                GeometryReader { geometry in
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(alignment: .center,spacing: 5){
                            ForEach(viewModel.availableShifts ?? [],id: \.self){shift in
                                Button(action: {
                                    viewModel.selectedShift = shift
                                    viewModel.newDate = selectedDate
                                    viewModel.selectedSchedual = nil
                                    Task{
                                        await viewModel.getAvailableScheduals()
                                    }
                                }, label: {
                                    VStack(spacing: 7){
                                        Text(shift.name ?? "")
                                            .font(.bold(size: 15))
                                        
                                        HStack(spacing:0){
                                            Text("\(shift.formattedtimeFrom ?? "")")
                                            Text(" - ")
                                            Text("\(shift.formattedtimeTo ?? "")")
                                        }
                                            .font(.medium(size: 13))
                                    }
                                })
                                .padding(7.5)
//                                .frame( height: 36)
//                                .frame(width: (geometry.size.width/3) - 15)
                                .foregroundStyle(viewModel.selectedShift == shift ? Color.white : Color(.secondary))
                                .cardStyle(backgroundColor: viewModel.selectedShift == shift ? Color(.secondary) : Color(.wrongsurface),cornerRadius: 2,shadowOpacity:0)
                            }
                        }
                    }
//                    .padding(.horizontal)
                    .padding(.top,8)
                    .padding(.bottom,4)

//                }
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
        }
        .task {
            // Push latest values into VM at presentation time
            viewModel.doctorPackageId = doctorPackageId
            viewModel.doctorId = doctorId
            viewModel.PackageId = packageId
            viewModel.SessionId = SessionId
            await viewModel.getDoctorPackageDetails()
            await viewModel.getAvailableDays()
        }
        .onChange(of: doctorId) { newVal in
            // reflect parent updates while sheet is up
            viewModel.doctorId = newVal
        }
        .onChange(of: packageId) { newVal in
            // reflect parent updates while sheet is up
            viewModel.PackageId = newVal
        }
        .onChange(of: SessionId) { newVal in
            // reflect parent updates while sheet is up
            viewModel.SessionId = newVal
        }
        // React to success
        .onChange(of: viewModel.isReschedualed) { newValue in
            guard newValue == true else { return }
            isPresentingNewMeasurementSheet = false
            onRescheduleSuccess?()
            // reset so future sheets can trigger again if needed
            viewModel.isReschedualed = false
        }
        .localizeView()
        .showHud(isShowing: $viewModel.isLoading )
        // Two-way binding so dismissing the alert clears the error
        .errorAlert(
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            ),
            message: viewModel.errorMessage
        )
    }
}

#Preview {
    ReSchedualView( doctorPackageId: 0, doctorId: .constant(0), packageId: .constant(0), SessionId: .constant(0), isPresentingNewMeasurementSheet: .constant(true),reschedualcase: .constant(.reschedualSession))
}
