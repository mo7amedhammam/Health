//
//  MeasurementDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/07/2025.
//


import SwiftUI

struct MeasurementDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = MyMeasurementsDetaislViewModel.shared
//    @StateObject var router = NavigationRouter()

    let stat: ModelMyMeasurementsStats
  
    var body: some View {
        VStack(spacing: 16) {
            
            // Top Header
            HStack {
                Button(action:{
                    dismiss()
                }) {
                    Image(.backLeft)
                        .resizable()
                        .flipsForRightToLeftLayoutDirection(true)
                }
                .frame(width: 31,height: 31)

                Spacer()
                
                HStack(spacing: 0){
                    Text(" \(stat.title ?? "") ")
                    Text("mesurement_".localized)
                }
                    .font(.bold(size: 20))
                    .foregroundColor(Color(.main))
                    .localizeView(reverse: Helper.shared.getLanguage() == "ar" )
              
                Spacer()
                
                Color.clear
                    .frame(width: 31,height: 31)

            }
            .padding(.horizontal)
            .padding(.top, 12)

            ScrollView{
                // New Measurement Button
                Button(action: {
                    // handle new measurement creation
                    viewModel.isPresentingNewMeasurementSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundStyle(Color(.secondary))
                            .font(.regular(size: 20))
                            .padding(5)
                            .background(Color(.white).cornerRadius(3))
                        
                        Text("add_new_mes".localized)
                            .font(.bold(size: 24))
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .horizontalGradientBackground()
                    .cardStyle(cornerRadius: 3)
                }
                .padding(.horizontal)
                
                if stat.measurementsCount ?? 0 > 0 {
                    VStack(spacing: 12) {
                        HStack{
                            Image(.newmegicon)
                            
                            // Measurement Count
                            ( Text("mesurement_recorded".localized) + Text(" \(stat.measurementsCount ?? 0) ")                        .foregroundColor(Color(.secondary)) + Text("mesurement_JusMesurment".localized))
                                .font(.bold(size: 18))
                                .foregroundColor(.mainBlue)
                                .frame(maxWidth: .infinity,alignment: .leading)
                        }
                        
                        HStack {
                            Image("newlastmesicon")
                                .resizable()
                                .frame(width: 16,height: 16)
                            
                            Text("la_search".localized)
                                .font(.semiBold(size: 20))
                                .foregroundColor(.mainBlue)
                            
                        }
                        .padding(.vertical)
                        
                        MeasurementSearchSection()
                            .environmentObject(viewModel)
                        
                        // Chart Placeholder
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color.gray.opacity(0.1))
//                            .frame(height: 180)
//                            .overlay(Text("Graph View Placeholder").foregroundColor(.gray))
                        
                    }
                    .padding()
                    
                    if let normalRang = viewModel.ArrNormalRange {
                        HStack {
                            Image("newlastmesicon")
                                .resizable()
                                .frame(width: 16,height: 16)
                            
                            Text("last_mes_results".localized)
                                .font(.semiBold(size: 20))
                                .foregroundColor(.mainBlue)
                            
                        }
                        
                            // Normal Range View
                            VStack(spacing: 10) {
                                HStack {
                                    Text("normal_range".localized)
                                        .font(.bold(size: 14))
                                        .foregroundColor(.white)
                                    Spacer()
                                    
                                    let normalFrom = normalRang.fromValue ?? ""
                                    let normalTo = normalRang.toValue ?? ""
                                    
                                    Text("\(normalFrom)" + " - " + "\(normalTo)")
                                        .font(.bold(size: 12))
                                        .foregroundColor(.white)
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.white)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image("inrangeicon")
                                            Text("within_normal_range".localized)
                                                .font(.regular(size: 14))
                                                .foregroundColor(.white)
                                        }
                                        
                                        HStack {
                                            Image("outofrangeicon")
                                            Text("outside_normal_range".localized)
                                                .font(.regular(size: 14))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(maxWidth:.infinity,alignment:.leading)
                                    
                                    if let imageName = stat.image {
                                        KFImageLoader(url:URL(string:Constants.imagesURL + (imageName.validateSlashs())),placeholder: Image("sehatylogobg"), isOpenable: false,shouldRefetch: false)
                                        //                            .resizable()
                                        //                        .clipShape(Circle())
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                    }
                                }
                            }
                            .padding()
                            .padding(.horizontal)
                            .frame( height: 124)
                            .background(Color(.mainBlue))
                            .cardStyle( cornerRadius: 6)
                            .padding(.horizontal)
                   
                        Spacer(minLength: 30)

                        }

                        // List of Measurements
                    if let ArrMeasurement = viewModel.ArrMeasurement?.measurements , let measurements = ArrMeasurement.items  {
                        ForEach(measurements,id: \.self) { item in

                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(item.inNormalRang ?? false ? "inrangeicon" : "outofrangeicon")
                                
                                    Text(item.value ?? "")
                                        .font(.semiBold(size: 16))
                                        .foregroundColor(item.inNormalRang ?? false ? .green : .red)

                                    Spacer()

                                    Text(item.formatteddate ?? "")
                                        .font(item.inNormalRang ?? false ? .medium(size: 14) : .regular(size: 10))
                                        .foregroundColor(Color(.secondary))
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .background(.gray.opacity(0.5))
                                
                                if let comment = item.comment, comment.count > 0 {
                                    Text(comment)
                                        .font(.regular(size: 14))
                                        .foregroundColor(.mainBlue)
                                        .frame(maxWidth:.infinity, alignment: .center)
                                        .frame( height: 56)

                                } else {
                                    Text("no_comment".localized)
                                        .font(.regular(size: 15))
                                        .foregroundColor(.gray.opacity(0.5))
                                        .frame(maxWidth:.infinity, alignment: .center)
                                        .frame( height: 56)
                                }
                                
                            }
                            .padding()
                            .padding(.horizontal)
                            .background(Color(.white))
                            .cardStyle( cornerRadius: 6)
                            .padding(.horizontal)
                        }
                        .listStyle(.plain)
                        Spacer(minLength: 30)

                    }
                    
                    
                } else {
                    
                    Spacer(minLength: 150)

                    VStack {
                        
                        Image(.nomegicon)
                        
                        Text("no_mes_found".localized)
                            .font(.semiBold(size: 22))
                            .foregroundColor(Color(.btnDisabledTxt))
                    }
            }
            }
            
            Spacer()
            
        }
        .background(
            Color(.bgPink))
        .edgesIgnoringSafeArea(.bottom)
        .localizeView()
//        .withNavigation(router: router)
        .onAppear{
            Task{
                viewModel.currentStats = stat
                async let normalRang: () = viewModel.fetchNormalRange()
                async let details: () = viewModel.fetchMeasurementDetails()

                 _ = await (normalRang,details)
            }
        }
        .customSheet(isPresented: $viewModel.isPresentingNewMeasurementSheet,height: 444){
            NewMeasurementSheetView().environmentObject(viewModel)
                .frame(height: 444)
        }
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)

        
    }
}

#Preview {
    MeasurementDetailsView(stat: ModelMyMeasurementsStats(
        medicalMeasurementID: 1,
        image: "bloodPressure",
        title: "الضغط",
        measurementsCount: 1542,
        lastMeasurementValue: "120/80",
        lastMeasurementDate: "27/6/2022",
        formatValue: nil,
        regExpression: nil,
        normalRangValue: nil
    ) )
}


struct MeasurementSearchSection: View {
    @EnvironmentObject var viewModel : MyMeasurementsDetaislViewModel
    @State private var selectedRange: TimeRange? = nil

    enum TimeRange: String, CaseIterable {
        case last7Days = "last_7_days"
        case last3Months = "last_3_months"
        case lastYear = "last_year"
    }

    var body: some View {
        VStack(spacing: 20) {
            // Time Range Buttons
            HStack(spacing: 10) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Button(action: {
                        selectedRange = range
                        let today = Date()
                        let calendar = Calendar.current
                        switch range {
                        case .last7Days:
                            viewModel.dateTo = today
                            viewModel.dateFrom = calendar.date(byAdding: .day, value: -7, to: today)
                        case .last3Months:
                            viewModel.dateTo = today
                            viewModel.dateFrom = calendar.date(byAdding: .month, value: -3, to: today)
                        case .lastYear:
                            viewModel.dateTo = today
                            viewModel.dateFrom = calendar.date(byAdding: .year, value: -1, to: today)
                        }
                    }) {
                        Text(range.rawValue.localized)
                            .font(.bold(size: 14))
                            .padding(.vertical, 12)
//                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(
                                selectedRange == range ? Color(.white) : Color(.secondary))
                            .background(
                                (selectedRange == range ? Color(.secondary) : Color(.white))
                                    .cardStyle(cornerRadius: 3,shadowOpacity: 0.077)
                            )
                    }
                }
            }

            Button(action: {
                selectedRange = nil
                viewModel.dateTo = nil
                viewModel.dateFrom = nil
            },label: {
            // All Measurements
            Text("all_messurements".localized)
                    .font(.semiBold(size: 20))
                .foregroundColor(.mainBlue)
                .padding()
                .frame(maxWidth: .infinity)
//                .background(Color.white)
                .cardStyle(cornerRadius: 3,shadowOpacity: 0.077)
            })
            
            // Separator with "أو"
            HStack {
                Divider().frame(height: 1).background(Color(.gray))
                Text("ـــــــ " + "or_".localized +  " ـــــــ")
                    .font(.bold(size: 18))
                    .foregroundColor(.pink)
                Divider().frame(height: 1).background(Color(.gray))
            }

            // From and To Date Pickers
            HStack(spacing: 8) {
                DatePickerField(selectedDate: $viewModel.dateFrom, title: "from_date".localized)

                DatePickerField(selectedDate: $viewModel.dateTo, title: "to_date".localized)
            }

            Button("search_".localized) {
                // apply filter
                Task{
                    await viewModel.fetchMeasurementDetails()
                }
            }
            .font(.bold(size: 24))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .horizontalGradientBackground()
            .cardStyle(cornerRadius: 3,shadowOpacity: 0.077)
        }
        .padding()
        .background(Color.white)
        .cardStyle(cornerRadius: 3,shadowOpacity: 0.088)
    }
}


struct NewMeasurementSheetView: View {
    @EnvironmentObject var viewModel: MyMeasurementsDetaislViewModel

    var body: some View {
    VStack(spacing: 16) {
        HStack {
            Image(systemName: "plus")
                .foregroundStyle(Color(.white))
                .frame(width: 20,height: 20)
                .padding(5)
                .background(Color(.secondary).cornerRadius(3))
            
            Text("add_new_mes".localized)
                .font(.bold(size: 22))
                .foregroundColor(.mainBlue)
                .frame(maxWidth: .infinity,alignment: .leading)

            Spacer()
            
            Button(action: {
                viewModel.isPresentingNewMeasurementSheet = false
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

        CustomDropListInputFieldUI(title: "mes_val_title", placeholder: "mes_val_placeholder",text: $viewModel.value, isDisabled: false, showDropdownIndicator:false, trailingView: AnyView(Image("newfienameIcon")))
        
        CustomDatePickerField(selectedDate: $viewModel.date) {
            HStack {
                CustomDropListInputFieldUI(title: "mes_date_title", placeholder: "mes_date_placeholder",text: $viewModel.formatteddate, isDisabled: true, showDropdownIndicator:false, trailingView: AnyView(Image("dateicon 1")))
            }
        }
        
        CustomDropListInputFieldUI(title: "mes_comment_title", placeholder: "mes_comment_placeholder",text: $viewModel.comment, isDisabled: false, showDropdownIndicator:false, trailingView: AnyView(Image("messagecentrepopup").resizable().frame(width: 17,height: 17)))
        
        HStack(spacing: 16) {
            CustomButton(title: "cancel_",backgroundcolor: Color(.secondary),backgroundView:nil){
                viewModel.isPresentingNewMeasurementSheet = false
            }

            CustomButton(title: "confirm_",backgroundcolor: Color(.mainBlue),backgroundView:nil){
                Task{
                    await viewModel.createMeasurement()
                }
//                    viewModel.isPresentingNewMeasurementSheet = false
            }

        }
        .padding(.top)

        Spacer()
    }
    .padding()
    .localizeView()
}
}


struct CustomDatePickerField<Content: View>: View {
    @Binding var selectedDate: Date?
    let content: () -> Content

    @State private var showingDatePickerSheet = false

    var body: some View {
        Button(action: {
            showingDatePickerSheet = true
        }) {
            content()
        }
        .customSheet(isPresented: $showingDatePickerSheet) {
            VStack {
                HStack {
                    Spacer()
                    Button("Done_".localized) {
                        showingDatePickerSheet = false
                    }
                    .padding()
                }

                DatePicker(
                    "SelectـDate".localized,
                    selection: Binding(
                        get: { selectedDate ?? Date() },
                        set: { selectedDate = $0 }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
            }
        }
    }
}
