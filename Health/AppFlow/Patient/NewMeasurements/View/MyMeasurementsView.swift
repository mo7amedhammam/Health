//
//  MyMeasurementsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/07/2025.
//


import SwiftUI

struct MyMeasurementsView: View {
    @StateObject var viewModel = MyMeasurementsViewModel()
    @StateObject var router = NavigationRouter()
    @State var mustLogin: Bool = false

    var measurements:[MyMeasurementsStatsM]? {
        return viewModel.ArrStats
//        return MyMeasurementsStatsM.mockList

    }
//    @State var destination = AnyView(EmptyView())
//    @State var isactive: Bool = false
//    func pushTo(destination: any View) {
//        self.destination = AnyView(destination)
//        self.isactive = true
//    }

    var body: some View {
        VStack(spacing: 12) {
            // TitleBar
            TitleBar(title: "measurements")

            // Search bar
//            HStack {
//                TextField("... ابحث", text: .constant(""))
//                    .textFieldStyle(PlainTextFieldStyle())
//                    .padding(10)
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(.pink)
//            }
//            .background(Color.white)
//            .cornerRadius(12)
//            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
//            .padding(.horizontal)

            ScrollView {
                let columns = [GridItem(.adaptive(minimum: 320), spacing: 16)]
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(measurements ?? [], id: \.medicalMeasurementID) { item in
                        Button(action: {
                            router.push(MeasurementDetailsView(stat: item))
                        }) {
                            MeasurementCard(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 4)

                Spacer().frame(height: 80)
            }
            Spacer()

        }
        .background(
            Color(.bgPink)
            .ignoresSafeArea())
        .localizeView()
        .withNavigation(router: router)
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
        .customSheet(isPresented: $mustLogin ,height: 350){
            LoginSheetView()
        }
        .task{
            Task{
                if Helper.shared.CheckIfLoggedIn(){
//                    await viewModel.fetchStats()
                }else{
                    viewModel.clear()
                    mustLogin = true
                }
            }
        }
        .refreshable {
            if Helper.shared.CheckIfLoggedIn(){
                await viewModel.fetchStats()
            }else{
                viewModel.clear()
                mustLogin = true
            }
        }
//        NavigationLink( "", destination: destination, isActive: $isactive)

    }
}


struct MeasurementCard: View {
    var item: MyMeasurementsStatsM

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.title ?? "")
                        .font(.bold(size: 20))
                        .foregroundColor(.mainBlue)
                        .lineLimit(1)

                    (Text("\(item.measurementsCount ?? 0) ")
                        .font(.semiBold(size: 16))
                     + Text("available_measurements".localized))
                        .font(.regular(size: 16))
                        .foregroundColor(.mainBlue.opacity(0.9))
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if let imageName = item.image {
                    KFImageLoader(
                        url: URL(string: Constants.imagesURL + (imageName.validateSlashs())),
                        placeholder: Image("sehatylogobg"),
                        isOpenable: false,
                        shouldRefetch: false
                    )
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                }

//                Image(systemName: "chevron.left")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundColor(.mainBlue.opacity(0.6))
            }

            Divider()
                .padding(.vertical, 2)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text("Last_Measurement".localized)
                        .font(.regular(size: 15))
                        .foregroundColor(.mainBlue)

                    Text(item.lastMeasurementValue ?? "--")
                        .font(.bold(size: 15))
                        .foregroundColor(Color(.secondary))
                }

                if let date = item.formatteddate {
                    HStack(spacing: 6) {
                        Text("in_Date_".localized)
                            .font(.semiBold(size: 15))
                            .foregroundColor(.mainBlue)

                        Text("\(date)")
                            .font(.regular(size: 15))
                            .foregroundColor(.mainBlue)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 110)
        .cardStyle(cornerRadius: 8,shadowOpacity: 0.14 )
    }
}

struct MyMeasurementsView_Previews: PreviewProvider {
    static var previews: some View {
        MyMeasurementsView()
    }

    static var sampleMeasurements: [MyMeasurementsStatsM] = [
        MyMeasurementsStatsM(
            medicalMeasurementID: 1,
            image: "bloodPressure",
            title: "الضغط",
            measurementsCount: 1542,
            lastMeasurementValue: "120/80",
            lastMeasurementDate: "27/6/2022",
            formatValue: nil,
            regExpression: nil,
            normalRangValue: nil
        ),
        MyMeasurementsStatsM(
            medicalMeasurementID: 2,
            image: "sugar",
            title: "السكر",
            measurementsCount: 133,
            lastMeasurementValue: "240",
            lastMeasurementDate: "27/6/2022",
            formatValue: nil,
            regExpression: nil,
            normalRangValue: nil
        ),
        // Add more mocks...
    ]
}

