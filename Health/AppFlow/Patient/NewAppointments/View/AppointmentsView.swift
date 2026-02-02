//
//  AppointmentsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/06/2025.
//

import SwiftUI

struct AppointmentsView: View {
    @StateObject var router = NavigationRouter()
    @StateObject var viewModel = AppointmentsViewModel()
    @State var mustLogin: Bool = false

    @State var showFilter:Bool = false
    @State var showCancel: Bool = false
    @State var idToCancel:Int?
    
    @State private var customrpackageId : Int?
    @State private var doctorId : Int?
    @State private var packageId : Int?
    @State private var sessionId : Int?
    @State private var isRescheduling: Bool = false

    var body: some View {
        VStack(spacing:0){
            VStack(){
                TitleBar(title: "appointments_title")
                    .background(Color.white)
                
                ScrollView{

                    if let session = viewModel.upcomingSession{
                        NextSessionSection(upcomingSession: session,
                                           detailsAction: {
                            
                            if Helper.shared.getSelectedUserType() == .Customer {
                                router.push( SubcripedPackageDetailsView( package: nil, CustomerPackageId: session.customerPackageId))
                                //                                    router.push(SubcripedPackageDetailsView( package: nil, CustomerPackageId: nextsession.customerPackageId))
                                print("push to SubcripedPackageDetailsView ")
                            }else if Helper.shared.getSelectedUserType() == .Doctor{
                                guard let customerPackageId = session.customerPackageId else { return }
                                router.push( ActiveCustomerPackagesView( doctorId:session.doctorId,CustomerPackageId: customerPackageId))
                            }
                        },
                                           rescheduleAction: {
                            //                                doctorId = nil
                            customrpackageId = session.customerPackageId
                            packageId = session.packageID
                            doctorId = session.doctorId
                            sessionId = session.id
                            isRescheduling = true })
                        .padding([.horizontal])
                    }
                    
                    AppointmentsListView(appointments:viewModel.appointments?.items ,selectAction: {appointment in
                        guard let customerPackageId = appointment.customerPackageId else {return}
                        if Helper.shared.getSelectedUserType() == .Customer{
                            router.push(SubcripedPackageDetailsView( package: nil, CustomerPackageId: customerPackageId))
                        }else{
                            //                        print(appointment.doctorName ?? "")
                            router.push(
                                //                            SubcripedPackageDetailsView(package: nil, CustomerPackageId:appointment.customerPackageId ?? 0)
                                ActiveCustomerPackagesView(doctorId:appointment.doctorId,CustomerPackageId: customerPackageId)
                                //                                .environmentObject(router)
                            )
                        }
                                },buttonAction:{item in
                                    idToCancel = item.packageID
//                                    if item.canRenew ?? false{
//                                        // renew subscription
//                                        guard let doctorPackageId = item.customerPackageID else { return }
//                                        pushTo(destination: PackageMoreDetailsView( doctorPackageId: doctorPackageId,currentcase:.renew))
//                                    }else if item.canCancel ?? false{
//                                        // sheet for cancel subscription
//                                        showCancel = true
//                                    }
                                },loadMore: {
//                                    guard viewModel.isLoading == false else { return }
                                    Task {
                                        await viewModel.loadMoreIfNeeded()
                                    }
                    
                                }, showFilter: $showFilter)
                                .refreshable {
                                    await viewModel.refresh()
                                }
                    
//                }else{
//
//                }
                }
//                .listStyle(.plain)
//                .refreshable {
////                        await viewModel.refresh()
//                }
                .padding(.top,30)
                
                Spacer()
            }
            //            .frame(height: 232)
            //            .horizontalGradientBackground()
            .task{
//                Task{
                    if Helper.shared.CheckIfLoggedIn(){
//                        await viewModel.refresh()
                    }else{
                        viewModel.clear()
                        mustLogin = true
                    }
//                }
            }
            .refreshable{
                if Helper.shared.CheckIfLoggedIn(){
//                        await viewModel.refresh()
                }else{
                    viewModel.clear()
                    mustLogin = true
                }
            }
            
            Spacer().frame(height: 55)
            
        }
        .localizeView()
        .withNavigation(router: router)
//        .reversLocalizeView()
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)

        .customSheet(isPresented: $showFilter,height: 330){
            FilterView(
                fromDate: $viewModel.fromDate,
                toDate: $viewModel.toDate,
                sortDirection: $viewModel.sortDirection,
                onApply: {
                    viewModel.clear()
                    Task { await viewModel.refresh() }
                },
                onCancel: {
                    viewModel.clear()
                    viewModel.resetFilter()
                    Task { await viewModel.refresh() }
                }
            )
        }
        .customSheet(isPresented: $mustLogin ,height: 350){
            LoginSheetView()
        }
        .customSheet(isPresented: $isRescheduling) {
            ReSchedualView(doctorPackageId: $customrpackageId,doctorId: $doctorId, packageId: $packageId, SessionId:$sessionId, isPresentingNewMeasurementSheet: $isRescheduling ,reschedualcase: .constant(.reschedualSession))
        }
        if showCancel{
            CancelSubscriptionView(isPresent: $showCancel, customerPackageId: idToCancel ?? 0)
                .onDisappear(perform: {
                showCancel = false
                print("cancelled dismiss")
            })
        }
    }
}

#Preview {
    AppointmentsView()
}

struct AppointmentsListView: View {
    var appointments: [AppointmentsItemM]?
//    = [AppointmentsItemM(
//        id: 1,
//        doctorName: "د. أحمد سامي",
//        sessionDate: "2025-08-05T15:15:00",
//        timeFrom: "2025-08-05T15:15:00",
//        packageName: "باقة الصحة العامة",
//        categoryName: "العلاج الطبيعي",
//        mainCategoryID: 1,
//        mainCategoryName: "الصحة",
//        categoryID: 2,
//        sessionMethod: "حضوري",
//        packageID: 10,
//        dayName: "الاثنين"
//    ),AppointmentsItemM(
//        id: 2,
//        doctorName: "د. أحمد سامي",
//        sessionDate: "2025-08-05T15:15:00",
//        timeFrom: "2025-08-05T15:15:00",
//        packageName: "باقة الصحة العامة",
//        categoryName: "العلاج الطبيعي",
//        mainCategoryID: 2,
//        mainCategoryName: "الصحة",
//        categoryID: 4,
//        sessionMethod: "حضوري",
//        packageID: 55,
//        dayName: "الاثنين"
//    )]
    var selectAction: ((AppointmentsItemM) -> Void)?
    var buttonAction: ((AppointmentsItemM) -> Void)?
    var loadMore: (() -> Void)?
    @Binding var showFilter: Bool

    var body: some View {
        VStack(spacing:0){
            SectionHeader(image: Image(.newnxtsessionicon),title: "other_sessions",MoreBtnimage: .newfilter){
                //                            show filter
                showFilter = true
            }
            .padding([.horizontal])
            if let appointments = appointments,appointments.count > 0{

//                List{
            ScrollView{
                LazyVStack{
                    
                    ForEach(appointments, id: \.self) { item in
                        AppointmentCardView(appointment: item, detaisactions: {selectAction?(item)}, renewaction: {
                            buttonAction?(item)
                        })
                        .buttonStyle(.plain)
                        .padding(.horizontal,14)
                        .padding(.vertical,5)

//                        .listRowSpacing(0)
//                        .listRowSeparator(.hidden)
//                        .listRowBackground(Color.clear)
//                        .listRowInsets(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                        
                        .onAppear {
                            // Detect when the last item appears
                            guard appointments.count >= 5 ,item == appointments.last else {return}
                            loadMore?()
                        }
                    }
                    
                    
                    //                }
                    //                .listStyle(.plain)
                }
                }
            }
        }

        
    }
}

#Preview{
    AppointmentsListView(appointments: [AppointmentsItemM(
        id: 1,
        doctorName: "د. أحمد سامي",
        sessionDate: "2025-08-05T15:15:00",
        timeFrom: "2025-08-05T15:15:00",
        packageName: "باقة الصحة العامة",
        categoryName: "استشفاء بعد مجهود أو إصابة",
        mainCategoryID: 1,
        mainCategoryName: "العلاج الطبيعي",
        categoryID: 2,
        sessionMethod: "حضوري",
        packageID: 10,
        dayName: "الاثنين"
    ),AppointmentsItemM(
        id: 2,
        doctorName: "د. أحمد سامي",
        sessionDate: "2025-08-05T15:15:00",
        timeFrom: "2025-08-05T15:15:00",
        packageName: "باقة الصحة العامة",
        categoryName: "العلاج الطبيعي",
        mainCategoryID: 2,
        mainCategoryName: "الصحة",
        categoryID: 4,
        sessionMethod: "حضوري",
        packageID: 55,
        dayName: "الاثنين"
    )], showFilter: .constant(true))
}

// MARK: - Card View
struct AppointmentCardView: View {
    let appointment: AppointmentsItemM
    var detaisactions: (() -> Void)
    var renewaction: (() -> Void)
    var body: some View {
        Button(action:{
            detaisactions()
        },label:{
        
        VStack(spacing: 0) {
            // Top Section (White background)
            VStack(alignment: .leading, spacing: 4) { // Right aligned for Arabic
                Text(appointment.packageName ?? "packageName")
                    .font(.semiBold(size: 22))
                    .foregroundColor(Color.mainBlue)
                    .padding(.bottom, 2)

                Text(appointment.categoryName ?? "categoryName") // Assuming this is "استشفاء بعد مجهود أو إصابة"
                    .font(.medium(size: 18))
                    .foregroundColor(Color(.secondary))
                
                Text(appointment.mainCategoryName ?? "categoryName") // This text "اللياقة البدنية" is static in the image, assuming it's part of the category or description
                    .font(.medium(size: 18))
                    .foregroundColor(Color(.secondary))
                    .padding(.bottom, 2)
                
                HStack {
                    // Date
                    HStack(spacing:3){
                        Text(appointment.dayName ?? "")
                        
                        Text(appointment.formattedDate ?? "")
//                            .font(.medium(size: 14))
                    }
                    .font(.medium(size: 12))
                    .foregroundColor(.mainBlue)
                    
                    Spacer()
                    
                    HStack(spacing:3){
                        Image(systemName: "clock")
                            .foregroundColor(.mainBlue)

                    // Time
                    Text(appointment.formattedTime ?? "")
                }
                    .font(.medium(size: 12))
                    .foregroundColor(Color(.secondary))

                }
                .padding(.top, 4) // Adjust spacing
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(Color.white)
            
            HStack(alignment: .bottom){
                
            // Bottom Section (Dark Blue background)
                VStack(alignment: .leading, spacing: 8) { // Right aligned for Arabic
                    let nametitle = Helper.shared.getSelectedUserType() == .Doctor ? "patient_name".localized : "doc_name".localized
                    Text(nametitle)
                        .font(.medium(size: 16))
                        .foregroundColor(.white)
                    
                    Text(appointment.displayName ?? "Name")
                        .font(.semiBold(size: 22))
                        .foregroundColor(.white)
                }
//                .frame(maxWidth: .infinity,alignment: .leading)
                    Spacer()
                
                VStack(alignment: .trailing, spacing: 8) { // Right aligned for Arabic
                    if Helper.shared.getSelectedUserType() == .Doctor{
                        Button(action: {
                            detaisactions()
                        },label:{
                            //                            HStack(spacing:3){
                            //                                Image("newreschedual")
                            //                                    .resizable()
                            //                                    .frame(width: 10, height: 8.5)
                            Text("customer_details".localized)
                                .underline()
                            //                            }
                                .foregroundStyle(Color.white)
                                .font(.regular(size: 12))
                        })
                    }
                    Spacer()

                    
                    Button(action: {
                        renewaction()
                    },label:{
                        HStack(spacing:3){
                            Image("newreschedual")
                                .resizable()
                                .frame(width: 10, height: 8.5)
                            Text("renew_subscription".localized)
                                .underline()
                        }
                        .foregroundStyle(Color.white)
                        .font(.regular(size: 12))
                    })
                }

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.mainBlue)
        }
        .cardStyle(cornerRadius: 3)

        })
    }
}

// MARK: - Preview Provider
struct AppointmentCardView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy appointment item for the preview
        let dummyAppointment = AppointmentsItemM(
            id: 1,
            doctorName: "د. أحمد سامي عبد الله", // Updated to match screenshot
            sessionDate: "2025-08-05T15:00:00", // Adjusted to match 3:00 PM example
            timeFrom: "2025-08-05T15:00:00", // Adjusted to match 3:00 PM example
            packageName: "باقة الصحة العامة",
            categoryName: "استشفاء بعد مجهود أو إصابة", // Updated to match screenshot
            mainCategoryID: 1,
            mainCategoryName: "الصحة",
            categoryID: 2,
            sessionMethod: "حضوري",
            packageID: 10,
            dayName: "الاثنين" // Correct day name for 08/05/2025 is Friday, but using model's value
        )
        
        AppointmentCardView(appointment: dummyAppointment, detaisactions: {}, renewaction: {})
            .previewLayout(.sizeThatFits) // Makes the preview fit the card content
            .padding() // Add some padding around the card in the preview
//            .background(Color.gray) // To see the card clearly on a light background
    }
}



// MARK: - Date Picker Component
struct DatePickerField: View {

    @Binding var selectedDate: Date?
    let title: String

    // Optional validation
    let minDate: Date?
    let maxDate: Date?

    // Formatter to display date as dd/MM/yyyy
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    @State private var showingDatePickerSheet = false

    // MARK: - Initializer (keeps backward compatibility)
    init(
        selectedDate: Binding<Date?>,
        title: String,
        minDate: Date? = nil,
        maxDate: Date? = nil
    ) {
        self._selectedDate = selectedDate
        self.title = title
        self.minDate = minDate
        self.maxDate = maxDate
    }

    var body: some View {
        Button {
            showingDatePickerSheet = true
        } label: {
            HStack(spacing: 0) {

                Image(.newcal)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 21, height: 21)
                    .padding(15)
                    .background(Color.mainBlue)

                VStack(alignment: .leading, spacing: 5) {

                    Text(title)
                        .font(.medium(size: 12))
                        .foregroundColor(Color(.secondary))

                    if let selectedDate {
                        Text(Self.dateFormatter.string(from: selectedDate))
                            .font(.medium(size: 12))
                            .foregroundStyle(Color.mainBlue)
                    }
                }
                .padding(8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, 12)
            .cardStyle(cornerRadius: 3, shadowOpacity: 0.088)
        }
        .customSheet(isPresented: $showingDatePickerSheet) {
            sheetContent
        }
    }

    // MARK: - Sheet Content
    private var sheetContent: some View {
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
                    set: { newValue in
                        var value = newValue
                        if let minDate {
                            value = max(value, minDate)
                        }
                        if let maxDate {
                            value = min(value, maxDate)
                        }
                        selectedDate = value
                    }
                ),
                displayedComponents:.date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()

            
//            DatePicker(
//                "SelectـDate".localized,
//                selection: Binding(
//                    get: {
//                        clamp(selectedDate ?? Date())
//                    },
//                    set: { newDate in
//                        selectedDate = clamp(newDate)
//                    }
//                ),
////                in: dateRange,
//                displayedComponents: .date
//            )
//            .datePickerStyle(.wheel)
//            .labelsHidden()
        }
    }

    // MARK: - Date Range
    private var dateRange: ClosedRange<Date>? {
        switch (minDate, maxDate) {
        case let (min?, max?):
            return min...max
        case let (min?, nil):
            return min...Date.distantFuture
        case let (nil, max?):
            return Date.distantPast...max
        default:
            return nil
        }
    }

    // MARK: - Clamp Helper
    private func clamp(_ date: Date) -> Date {
        if let minDate, date < minDate { return minDate }
        if let maxDate, date > maxDate { return maxDate }
        return date
    }
}

// MARK: - Radio Button Component
struct RadioButton: View {
    let option: SortOptions?
    @Binding var isSelected: Bool
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
//            isSelected.toggle()
        }) {
            HStack(){
                // The radio button circle
                Image(isSelected ? .radiofill : .radio)
                
                Text(option?.rawValue.localized ?? "")
                    .font(.medium(size: 16))
                    .foregroundColor(.mainBlue)
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - FilterView (Main View)
enum SortOptions:String {
    case oldestToNewest = "old_to_new"
    case newestToOldest = "new_to_old"
}
struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var fromDate: Date?
    @Binding var toDate: Date?
    @Binding var sortDirection: String?
    var onApply: (() -> Void)? = nil
    var onCancel: (() -> Void)? = nil
    
    private var isOldToNewSelected: Bool { sortDirection == "old_to_new" }
    private var isNewToOldSelected: Bool { sortDirection == "new_to_old" }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Custom Header
            HStack {
                
                // Title and Icon
                HStack(spacing: 8) {
                    Image(.newfilter) // Placeholder for filter icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.mainBlue) // Adjust color as needed
                    
                    Text("filter_".localized)
                        .font(.semiBold(size: 16))
                        .foregroundColor(.mainBlue) // Adjust color as needed
                    
                }
                Spacer()
                
                // Close Button
                Button(action: {
                    dismiss() // Dismiss the sheet
                }) {
                    Image(systemName: "xmark.circle") // Placeholder for 'x' icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(Color(.secondary))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .padding(.top)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
            
            // MARK: - Content
            VStack(alignment: .trailing, spacing: 20) { // Align content to right for RTL
                // Date Pickers
                HStack(spacing: 16) {
                    DatePickerField(selectedDate: $fromDate, title: "from_date".localized)

                    DatePickerField(selectedDate: $toDate, title: "to_date".localized)
                }
                .padding(.top, 20)
                
                // Radio Buttons
                VStack(alignment: .trailing, spacing: 10) {
                    RadioButton(option: .oldestToNewest, isSelected: .constant(isOldToNewSelected)) {
                        sortDirection = "old_to_new"
                    }
                    
                    RadioButton(option: .newestToOldest, isSelected: .constant(isNewToOldSelected)) {
                        sortDirection = "new_to_old"
                    }
                }
                .padding(.vertical, 10)
                
                Spacer() // Pushes content up
                
                // MARK: - Action Buttons
                HStack(spacing: 15) {
                    Button(action: {
                        onCancel?()
                        dismiss()
                    }) {
                        Text("cancel_".localized)
                            .font(.bold(size: 18))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(Color(.secondary))
                            .cornerRadius(3)
                    }
                    
                    Button(action: {
                        // Apply filter logic here
                        print("Apply Filter:")
                        print("From: \(String(describing: fromDate))")
                        print("To: \(String(describing: toDate))")
                        switch sortDirection {
                        case "old_to_new":
                            print("Sort: Oldest to Newest")
                            sortDirection = "asc"

                        case "new_to_old":
                            print("Sort: Newest to Oldest")
                            sortDirection = "desc"

                        default:
                            print("Sort: none")
                            sortDirection = nil
                        }
                        onApply?()
                        dismiss() // Dismiss the sheet on Apply
                    }) {
                        Text("apply_".localized)
                            .font(.bold(size: 18))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(Color.mainBlue)
                            .cornerRadius(3)
                    }
                }
                .padding(.bottom, 20) // Padding from bottom edge
            }
            .padding(.horizontal, 20) // Horizontal padding for the main content VStack
            .background(Color.white) // Main content background
        }
        
//        .reversLocalizeView()
//        .localizeView(reverse: true)
        .background(Color.white.ignoresSafeArea()) // Overall background to extend behind safe areas if needed
//        .environment(\.layoutDirection, .rightToLeft) // Force RTL layout for the entire view
    }
}

// MARK: - Preview Provider
struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(fromDate: .constant(Date()), toDate: .constant(Date()), sortDirection: .constant(nil), onApply: {}, onCancel: {})
    }
}

