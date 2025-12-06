//
//  PackageMoreDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/05/2025.
//

import SwiftUI

enum bookingCase {
    case create
    case renew
    case cancel
}

struct PackageMoreDetailsView: View {

    var currentcase: bookingCase = .create
    var doctorPackageId: Int

    @StateObject private var viewModel: PackageMoreDetailsViewModel
    @State private var mustLogin: Bool = false

    @State private var showingDatePicker = false

    @State private var destination = AnyView(EmptyView())
    @State private var isactive: Bool = false

    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }

    init(doctorPackageId: Int, currentcase: bookingCase = .create, viewModel: PackageMoreDetailsViewModel = PackageMoreDetailsViewModel()) {
        self.currentcase = currentcase
        self.doctorPackageId = doctorPackageId
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            let doctorData = viewModel.packageDetails?.doctorData
            let packageData = viewModel.packageDetails?.packageData

            VStack() {
                TitleBar(title: "", hasbackBtn: true)
                    .padding(.top, 50)

                Spacer()

                HStack {
                    VStack(alignment: .leading) {
                        (Text("doc".localized + "/".localized) + Text(doctorData?.doctorName ?? "name".localized))
                            .font(.semiBold(size: 22))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 2) {
                            Image(.newpharmacisticon)
                                .resizable()
                                .frame(width: 12, height: 12)
                                .scaledToFit()
                                .padding(3)

                            Text(doctorData?.speciality ?? "speciality".localized)
                                .font(.semiBold(size: 12))
                                .foregroundStyle(Color.white)
                        }
                    }

                    HStack(spacing: 2) {
                        KFImageLoader(url: URL(string: Constants.imagesURL + (doctorData?.flag?.validateSlashs() ?? "")), placeholder: Image("egFlagIcon"), shouldRefetch: false)
                            .frame(width: 12, height: 12)

                        Text(doctorData?.nationality ?? "nationality".localized)
                            .font(.semiBold(size: 12))
                            .foregroundStyle(Color.white)
                    }
                }
                .padding(10)
                .background {
                    BlurView(radius: 5)
                        .horizontalGradientBackground().opacity(0.89)
                }
            }
            .background {
                KFImageLoader(url: URL(string: Constants.imagesURL + (doctorData?.doctorImage?.validateSlashs() ?? "")), placeholder: Image("logo"), shouldRefetch: true)
                    .frame(height: 195)
            }
            .frame(height: 195)

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading) {

                    HStack(alignment: .bottom) {

                        VStack(alignment: .leading, spacing: 8) {

                            Text(packageData?.packageName ?? "باقة الصحة العامة")
                                .font(.semiBold(size: 22))
                                .foregroundStyle(.white)

                            Group {
                                Text(packageData?.categoryName ?? "صحة عامة")
                                Text(packageData?.mainCategoryName ?? "التغذية العلاجية")
                            }
                            .font(.medium(size: 18))
                            .foregroundStyle(Color.white)

                            HStack(spacing: 0) {
                                Image(.newconversationicon)
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 16, height: 9)
                                    .foregroundStyle(Color(.secondaryMain))

                                (Text(" \(packageData?.sessionCount ?? 0) ")
                                    .font(.semiBold(size: 16)) + Text("sessions".localized)
                                    .font(.regular(size: 12)))

                                Text(" - " + "sessions_Duration".localized)
                                    .font(.regular(size: 12))

                                Text(" \(packageData?.duration ?? 0) " + "Minutes".localized)
                                    .font(.regular(size: 12))
                            }
                            .foregroundStyle(Color.white)
                        }

                        Spacer()

                        VStack(alignment: .center, spacing: 4) {
                            Group {
                                Text(packageData?.priceAfterDiscount ?? 0, format: .number.precision(.fractionLength(2)))
                                    .font(.semiBold(size: 16))

                                Text(" " + "EGP".localized)
                                    .font(.medium(size: 12))
                            }
                            .foregroundStyle(Color.white)

                            (Text(packageData?.priceBeforeDiscount ?? 0, format: .number.precision(.fractionLength(2))) + Text(" " + "EGP".localized))
                                .strikethrough().foregroundStyle(Color(.secondary))
                                .font(.medium(size: 12))

                            DiscountLine(discount: packageData?.discount)
                        }
                    }
                    .padding(10)
                    .background(Color.mainBlue)
                    .cardStyle(cornerRadius: 3)
                }
                .padding([.horizontal, .top], 15)
                .padding(.top, 5)

                SectionHeader(image: Image(.newreschedual), imageForground: Color(.secondary), title: "Schedualling_".localized, subTitle:
                        Text("schedualling_Hint".localized)
                        .foregroundStyle(Color(.secondary))
                        .font(.medium(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                ) {
                    // go to last mes package
                }
                .padding()

                HStack {
                    Button(action: {
                        showingDatePicker = true
                    }, label: {
                        HStack(alignment: .center) {
                            Text(viewModel.newDate, format:.customDateFormat("MMM - yyyy"))
                                .foregroundStyle(Color(.mainBlue))
                                .font(.medium(size: 14))

                            Image(systemName: "chevron.forward")
                                .font(.system(size: 8))
                                .frame(width: 15, height: 15)
                                .foregroundStyle(Color.white)
                                .background(Color(.secondary).cornerRadius(1))
                        }
                    })
                    .customSheet(isPresented: $showingDatePicker, height: 250, radius: 12, content: {
                        VStack(spacing: 0) {
                            MonthYearPicker(date: $viewModel.newDate)
                                .frame(maxHeight: .infinity)
                            Button(action: {
                                showingDatePicker = false
                            }) {
                                Text("Done".localized)
                                    .font(.bold(size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background { LinearGradient(gradient: Gradient(colors: [.mainBlue, Color(.secondary)]), startPoint: .leading, endPoint: .trailing) }
                                    .cardStyle(cornerRadius: 6)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        }
                    })
                    .task(id: viewModel.newDate) {
                        await viewModel.onMonthChanged()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // Days row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.availableDays) { day in
                            Button(action: {
                                Task { await viewModel.select(day: day) }
                            }, label: {
                                VStack {
                                    Text("\(day.date ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd"))
                                        .font(.semiBold(size: 16))

                                    Text(day.dayName ?? "")
                                        .font(.medium(size: 14))
                                }
                                .frame(height: 50)
                                .frame(width: 60)

                            })
                            .foregroundStyle(Color.white)
                            .background(viewModel.selectedDay == day ? Color(.secondary) : Color(.mainBlue))
                            .cardStyle(cornerRadius: 2)
                            .padding(2)
                        }
                    }
                }
                .padding(.horizontal)

                ZStack(){
                    GeometryReader { geometry in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .center, spacing: 5) {
                                ForEach(viewModel.availableShifts) { shift in
                                    Button(action: {
                                        Task { await viewModel.select(shift: shift) }
                                    }, label: {
                                        VStack(spacing: 5) {
                                            Text(shift.name ?? "")
                                                .font(.bold(size: 14))
                                            
                                            HStack(spacing: 0){
                                                Text("\(shift.formattedtimeFrom ?? "")")
                                                Text(" - ")
                                                Text("\(shift.formattedtimeTo ?? "")")
                                            }
                                                .font(.medium(size: 10))
                                        }
                                    })
                                    .frame(height: 36)
                                    .frame(width: (geometry.size.width / 3) - 15)
                                    .foregroundStyle(viewModel.selectedShift == shift ? Color.white : Color(.secondary))
                                    .cardStyle(backgroundColor: viewModel.selectedShift == shift ? Color(.secondary) : Color(.wrongsurface), cornerRadius: 2, shadowOpacity: 0)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
                .frame(height: 50)
                .padding(.bottom)


                if !viewModel.availableScheduals.isEmpty {
                    SshedualsGrid(scheduals: viewModel.availableScheduals, selectedschedual: $viewModel.selectedSchedual)
//                        .padding(.top)
                }

                CustomButton(title: "Continue_".localized, backgroundView:
                                AnyView(Color.clear.horizontalGradientBackground())) {
                    Task {
                        if Helper.shared.CheckIfLoggedIn() {
                            await viewModel.getBookingSession()
                        } else {
                            mustLogin = true
                        }
                    }
                }

                Spacer().frame(height: 55)
            }
        }
        .localizeView()
        .showHud2(isShowing: $viewModel.isLoading)
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
        .edgesIgnoringSafeArea([.top, .horizontal])
        .task {
            viewModel.ticketData = nil
            await viewModel.load(doctorPackageId: doctorPackageId)
        }
        .onChange(of: viewModel.ticketData) { newval in
            guard newval != nil else { return }
            pushTo(destination: TicketView(ticketData: newval, parameters: viewModel.prepareParamters()))
        }
        .customSheet(isPresented: $mustLogin, height: 350) {
            LoginSheetView()
        }

        NavigationLink("", destination: destination, isActive: $isactive)
    }
}

#Preview {
    PackageMoreDetailsView(doctorPackageId: 0)
}

struct SshedualsGrid: View {

    var scheduals: [AvailableSchedualsM]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Binding var selectedschedual: AvailableSchedualsM?

    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(scheduals) { item in
                    Button(action: {
                        selectedschedual = item
                    }, label: {
                        HStack(spacing: 0){
                            Text("\(item.formattedtimeFrom ?? "")")
                            Text(" - ")
                            Text("\(item.formattedtimeTo ?? "")")
                        }
                            .font(.medium(size: 10))
                            .foregroundStyle(item.booked ?? false ? Color(.btnDisabledTxt) : (selectedschedual == item ? Color(.white) : Color(.secondary)))
                    })
                    .padding()
                    .frame(height: 20)
                    .cardStyle(
                        backgroundColor: (item.booked ?? false ? Color(.btnDisabledBg) : (selectedschedual == item ? Color(.secondary) : Color(.clear))),
                        cornerRadius: 3,
                        shadowOpacity: 0,
                        borderColor: item.booked ?? false ? .clear : Color(.secondary)
                    )
                    .disabled(item.booked ?? false)
                }
            }
            .padding(10)
            .cardStyle(backgroundColor: .white, cornerRadius: 5, shadowOpacity: 0.09)
            .padding()
        }
        .padding(.vertical, 5)
        .padding(.bottom, 5)
    }
}

// MARK: - Identifiable helpers to stabilize ForEach
extension AvailableDayM: Identifiable {
    public var id: String { date ?? String(dayId ?? -1) }
}

extension AvailableTimeShiftM: Identifiable {}

extension AvailableSchedualsM: Identifiable {
    public var id: String { (timefrom ?? "") + "-" + (timeTo ?? "") }
}

