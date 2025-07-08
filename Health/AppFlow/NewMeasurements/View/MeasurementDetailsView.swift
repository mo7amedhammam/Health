//
//  MeasurementDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/07/2025.
//


import SwiftUI

struct MeasurementDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = MyMeasurementsViewModel.shared
    @StateObject var router = NavigationRouter()

    let stat: ModelMyMeasurementsStats

    @State private var selectedRange = 0
    @State private var fromDate: Date = .now
    @State private var toDate: Date = .now
    @State private var isShowingData = true // Toggle based on API results

    var ranges = ["آخر 7 أيام", "آخر 3 شهور", "آخر سنة"]
  
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
                
                (Text("mesurement_".localized) + Text(" \(stat.title ?? "") "))
                    .font(.bold(size: 20))
                    .foregroundColor(Color(.main))
              
                Spacer()
                
                Color.clear
                    .frame(width: 31,height: 31)

            }
            .padding(.horizontal)
            .padding(.top, 12)

            // New Measurement Button
            Button(action: {
                // handle new measurement creation
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

            if isShowingData {
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

                    // Chart Placeholder
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 180)
                        .overlay(Text("Graph View Placeholder").foregroundColor(.gray))

                }
                .padding()
            } else {
                Spacer()
                VStack {
                    Image(systemName: "doc.text.magnifyingglass") // replace with your asset
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray.opacity(0.2))
                    Text("لا يوجد أي قياسات")
                        .font(.medium(size: 18))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            
            Spacer()
            
        }
        .background(
            Color(.bgPink)
            .ignoresSafeArea())
//        .localizeView()
//        .withNavigation(router: router)
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)

        .onAppear{
            Task{
                await viewModel.fetchStats()
            }
        }
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
    @State private var selectedRange: TimeRange? = nil
    @State private var fromDate:Date? = Date()
    @State private var toDate:Date? = Date()

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
                DatePickerField(selectedDate: $fromDate, title: "from_date".localized)

                DatePickerField(selectedDate: $toDate, title: "to_date".localized)
            }

            Button("search_".localized) {
                // apply filter
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
