//
//  MyMeasurementsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/07/2025.
//


import SwiftUI

struct MyMeasurementsView: View {
    @StateObject var viewModel = MyMeasurementsViewModel.shared
    @StateObject var router = NavigationRouter()
    @State var mustLogin: Bool = false

    var measurements:[MyMeasurementsStatsM]? {
        return viewModel.ArrStats
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

            ScrollView{
                // Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(measurements ?? [], id: \.medicalMeasurementID) { item in
                        Button(action: {
//                            pushTo(destination: MeasurementDetailsView(stat: item) )
                            router.push(MeasurementDetailsView(stat: item) )

                        }, label: {
                            MeasurementCard(item: item)
                        })
                    }
                }
                .padding()
                Spacer().frame(height:80)

            }
            Spacer()

        }
        .background(
            Color(.bgPink)
            .ignoresSafeArea())
        .localizeView()
        .withNavigation(router: router)
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
        .customSheet(isPresented: $mustLogin ,height: 350){
            LoginSheetView()
            
        }
        .onAppear{
            Task{
                if Helper.shared.CheckIfLoggedIn(){
                    await viewModel.fetchStats()
                }else{
                    viewModel.clear()
                    mustLogin = true
                }
            }
        }
//        NavigationLink( "", destination: destination, isActive: $isactive)

    }
}


struct MeasurementCard: View {
    var item: MyMeasurementsStatsM

    var body: some View {
        VStack(alignment: .trailing, spacing: 6) {
            HStack {
                VStack(alignment: .leading,spacing: 5){
                    Text(item.title ?? "")
                        .font(.bold(size: 16))
                        .foregroundColor(.mainBlue)
                    
                    (Text("\(item.measurementsCount ?? 0) ")
                        .font(.bold(size: 8))

                     + Text("available_measurements".localized))
                        .font(.regular(size: 8))
                        .foregroundColor(.mainBlue)
                }
                .frame(maxWidth: .infinity , alignment: .leading)

                if let imageName = item.image {
                    KFImageLoader(url:URL(string:Constants.imagesURL + (imageName.validateSlashs())),placeholder: Image("sehatylogobg"), isOpenable: false,shouldRefetch: false)
//                            .resizable()
//                        .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                }
            }

            Divider()

            HStack {
                Text("Last_Measurement".localized)
                    .font(.regular(size: 10))
                    .foregroundColor(.gray)
                    .foregroundColor(.mainBlue)

                Text(item.lastMeasurementValue ?? "--")
                    .font(.bold(size: 10))
                    .foregroundColor(Color(.secondary))

                Spacer()

                if let date = item.formatteddate{
                    (Text("in_Date_".localized)
                        .font(.semiBold(size: 6))
                     
                     + Text("\( date)"))
                    .font(.regular(size: 6))
                    .foregroundColor(.mainBlue)
                }
            }
        }
        .frame(height: 88)
        .padding(.horizontal)
        .background(Color.white)
        .cardStyle(cornerRadius: 3,shadowOpacity: 0.066)
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
