//
//  DocPackagesScreen.swift
//  Sehaty
//
//  Created by mohamed hammam on 24/08/2025.
//


import SwiftUI

struct DocPackagesScreen: View {
    @State private var packages: [String] = ["okkkkkk","done"] // Empty initially
    @State private var showFilter: Bool = false
    var hasbackBtn:Bool?
    
    var docpacks = [SubcripedPackageItemM(customerPackageID: 2, docotrID: 2, status: "active", subscriptionDate: "", lastSessionDate: "", packageName: "nameeee", categoryName: "cateeee", mainCategoryName: "main cateee", doctorName: "doc doc", sessionCount: 4, attendedSessionCount: 2, packageImage: "", doctorSpeciality: "special", doctorNationality: "egegege", doctorImage: "", canCancel: true, canRenew: true )]
    
    var appointments: [AppointmentsItemM]? = [AppointmentsItemM(
        id: 1,
        doctorName: "د. أحمد سامي",
        sessionDate: "2025-08-05T15:15:00",
        timeFrom: "2025-08-05T15:15:00",
        packageName: "باقة الصحة العامة",
        categoryName: "العلاج الطبيعي",
        mainCategoryID: 1,
        mainCategoryName: "الصحة",
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
    )]
    
    var packages1: FeaturedPackagesM? = .init(items: [FeaturedPackageItemM.init()],totalCount: 5)
    var body: some View {
            VStack {
                TitleBar(title: "doc_packages", hasbackBtn: hasbackBtn ?? true)

                if packages.isEmpty {
                    // ✅ حالة الـ Empty
                    Spacer()
                    VStack(spacing: 20) {
//                        Image(systemName: "gift.fill")
                        Image("nosubscription")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 162, height: 162)
                            .foregroundColor(.mainBlue.opacity(0.3))
                        
                        Text("doc_no_packages".localized)
                            .font(.semiBold(size: 22))
                            .foregroundColor(Color(.deactive))
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                    }
                    .padding(.horizontal,30)
                    Spacer()
                    
                } else {
                    // ✅ حالة وجود باقات
                    DocPackagesListView(packaces: packages1?.items,action: {package in
//                        pushTo(destination: PackageDetailsView(package: package))
                    })
                    .padding()

                }
                
                CustomButton(title: "doc_package_request",isdisabled: false,backgroundView:AnyView(Color.clear.horizontalGradientBackground())){
                    showFilter.toggle()
                }

            }
            .localizeView()
            //            .withNavigation(router: router)
//            .showHud(isShowing:  $viewModel.isLoading)
//            .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)

            .sheet(isPresented: $showFilter) {
                DocPackagesFilterView()
            }
        
    }
}
#Preview {
    DocPackagesScreen()
}

struct DocPackagesFilterView: View {
    @State private var mainCategory: String = ""
    @State private var subCategory: String = ""
    @State private var package: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TitleBar(title: "doc_packages", hasbackBtn: true)

            VStack(spacing: 16) {
                FilterRow(title: "التصنيف الرئيسي", value: $mainCategory, placeholder: "اختر التصنيف الرئيسي")
                FilterRow(title: "التصنيف الفرعي", value: $subCategory, placeholder: "اختر التصنيف الفرعي")
                FilterRow(title: "الباقة", value: $package, placeholder: "اختر الباقة")
            }
            
            Spacer()
            
            // MARK: Footer Buttons
            HStack(spacing: 4) {
                CustomButton(title: "new_send_btn",backgroundcolor: Color(.mainBlue)){
//                    print("Selected Slots:", viewModel.selectedSlots)
//                    showDialog = true
                }
                CustomButton(title: "remove_all_btn",backgroundView : AnyView(Color(.secondary))){
//                    viewModel.clear()
                }
            }
            
        }
        .localizeView()
        .padding()
    }
}

struct FilterRow: View {
    var title: String
    @Binding var value: String
    var placeholder: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text(title)
                .font(.medium(size: 14))
                .foregroundColor(.mainBlue)
            HStack {
                Text(value.isEmpty ? placeholder : value)
                    .foregroundColor(value.isEmpty ? .gray : .black)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct DocPackagesListView: View {
    var packaces: [FeaturedPackageItemM]?
    var action: ((FeaturedPackageItemM) -> Void)?
//    var likeAction : ((Int) -> Void)?

    var body: some View {
        VStack{
            
                        SectionHeader(image: Image(.newvippackicon),title: "doc_your_packages",MoreBtnimage: nil){
            //                //                            go to last mes package
                        }
            
            //            ScrollView(.horizontal,showsIndicators:false){
            
            ScrollView{
                ForEach(packaces ?? [], id: \.self){ item in
                    Button(action: {
                        action?(item)
                    }, label: {
                        ZStack(alignment: .bottom){
                            KFImageLoader(url:URL(string:Constants.imagesURL + (item.imagePath?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                                .frame( height: 180)
                            
                            
                            //                                Image(.onboarding1)
                            //                                    .resizable()
                            //                                    .aspectRatio(contentMode: .fill)
                            //                                //                                    .frame(width: 166, height: 221)
                            //                                    .frame( height: 180)
                            
                            VStack {
                                HStack(alignment:.top){
                                    // Title
                                    HStack (spacing:3){
                                        Image(.newconversationicon)
                                            .resizable()
                                            .frame(width: 16, height: 9)
                                        Text("\(item.sessionCount ?? 0) ").font(.semiBold(size: 16))
                                        
                                        Text("sessions".localized)
                                    }
                                    .font(.regular(size: 12))
                                    .foregroundStyle(Color.white)
                                    .frame(height:32)
                                    .padding(.horizontal,10)
                                    .background{Color(.secondaryMain)}
                                    .cardStyle( cornerRadius: 3)
                                    
                                    Spacer()
//                                    Button(action: {
//                                        likeAction?(item.appCountryPackageId ?? 0)
//                                    }, label: {
//                                        Image( item.isWishlist ?? false ? .newlikeicon : .newunlikeicon)
//                                            .resizable()
//                                            .frame(width: 20, height: 20)
//                                    })
                                    
                                }
                                .frame(maxWidth: .infinity,alignment:.leading)
                                .padding(10)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5),.clear]), startPoint: .top, endPoint: .bottom)
                                )
                                
                                Spacer()
                                
                                VStack {
                                    Text(item.name ?? "pack_Name".localized)
                                        .font(.bold(size: 22))
                                        .foregroundStyle(Color.white)
                                    //                                                .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    HStack(alignment: .bottom){
                                        VStack(alignment:.leading) {
                                            
                                            HStack(alignment: .center,spacing: 5){
                                                
                                                ( Text(" \(item.doctorCount ?? 0) ") + Text("subscribtions_".localized))
                                                    .font(.medium(size: 12))
//                                                    .frame(maxWidth: .infinity,alignment:.leading)
                                                
                                                Image(.greenPerson)
//                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .frame(width: 12,height:12)
                                                    .scaledToFit()
//                                                    .foregroundStyle(.white)
//                                                    .padding(3)
//                                                    .background(Color(.secondary))

                                            }
                                            .font(.medium(size: 12))
                                            .foregroundStyle(Color.white)
                                            .frame(maxWidth: .infinity,alignment:.leading)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing){
                                            (Text(item.priceAfterDiscount ?? 0,format:.number.precision(.fractionLength(1))) + Text(" "+"EGP".localized))
                                                .font(.semiBold(size: 16))
                                                .foregroundStyle(Color.white)
                                            
                                            HStack{
                                                
                                               (Text(item.priceBeforeDiscount ?? 0,format:.number.precision(.fractionLength(1))) + Text(" "+"EGP".localized)).strikethrough().foregroundStyle(Color(.secondary))
                                                    .font(.semiBold(size: 12))
                                                
                                                DiscountLine(discount: item.discount)

//                                                (Text("(".localized + "Discount".localized ) + Text( " \(item.discount ?? 0)" + "%".localized + ")".localized))
//                                                    .font(.semiBold(size: 12))
//                                                    .foregroundStyle(Color.white)
                                                
                                            }
                                            .padding(.top,2)
                                        }
                                    }
                                }
                                .padding(.top,5)
                                .padding([.bottom,.horizontal],10)
                                .background{
                                    BlurView(radius: 5)
                                        .horizontalGradientBackground( reverse: true).opacity(0.89)
                                    //                                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                                }
                                
                            }
                        }
                        
                    })
                    .cardStyle(cornerRadius: 3)
                    .horizontalGradientBackground()
                    //                        .frame(width: 200, height: 356)
//                    .padding()

                }
                .buttonStyle(.plain)
                //                    .listRowSpacing(0)
                //                    .listRowSeparator(.hidden)
                //                    .listRowBackground(Color.clear)
                
            }
            //            .listStyle(.plain)
//            .padding()

//            .cardStyle(cornerRadius: 3,shadowOpacity:0.28)
            .padding(.vertical,5)
            .padding(.bottom,5)
        }
        
    }
}


//struct DocPackagesListView: View {
////    var packages: [SubcripedPackageItemM]?
//    var packages: [AppointmentsItemM]?
//    var selectAction: ((SubcripedPackageItemM) -> Void)?
//    var buttonAction: ((SubcripedPackageItemM) -> Void)?
//    var loadMore: (() -> Void)?
//
//    var body: some View {
//        VStack(spacing: 0) {
//            SectionHeader(image: Image(.newvippackicon), title: "subscriped_packages",MoreBtnimage: nil)
//                .padding([.horizontal, .top])
//
//            if let packages = packages{
////                if let packages = packaces, packages.count > 0 {
////                ScrollView {
////                    LazyVStack(spacing: 8) {
////                        ForEach(packages, id: \.self) { item in
////                            DocAppointmentCardView
////                            
////                            SubscribedPackageCardView(item: item, selectAction: {
////                                selectAction?(item)
////                            }, buttonAction: {
////                                buttonAction?(item)
////                            })
////                            .onAppear {
////                                if item == packages.last {
////                                    loadMore?()
////                                }
////                            }
////                        }
////                    }
////                    .padding(.horizontal)
////                }
//                
//                
////                if let appointments = appointments,appointments.count > 0{
//                List{
//                    ForEach(packages, id: \.self) { item in
//                        AppointmentCardView(appointment: item, renewaction: {
////                            buttonAction?(item)
//                        })
//                        .buttonStyle(.plain)
//                        .listRowSpacing(0)
//                        .listRowSeparator(.hidden)
//                        .listRowBackground(Color.clear)
//                        .listRowInsets(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
//                        
////                        .onAppear {
////                            // Detect when the last item appears
////                            guard item == appointments.last else {return}
////                                loadMore?()
////                        }
//                    }
//                    
//                }
//            } else {
//                SubscribedPackageEmptyView()
//            }
//        }
//    }
//}

//struct DocAppointmentCardView: View {
//    let appointment: AppointmentsItemM
//    var renewaction: (() -> Void)
//    var body: some View {
//        VStack(spacing: 0) {
//            // Top Section (White background)
//            VStack(alignment: .leading, spacing: 4) { // Right aligned for Arabic
//                Text(appointment.packageName ?? "packageName")
//                    .font(.semiBold(size: 22))
//                    .foregroundColor(Color.mainBlue)
//                    .padding(.bottom, 2)
//
//                Text(appointment.categoryName ?? "categoryName") // Assuming this is "استشفاء بعد مجهود أو إصابة"
//                    .font(.medium(size: 18))
//                    .foregroundColor(Color(.secondary))
//                
//                Text(appointment.mainCategoryName ?? "categoryName") // This text "اللياقة البدنية" is static in the image, assuming it's part of the category or description
//                    .font(.medium(size: 18))
//                    .foregroundColor(Color(.secondary))
//                    .padding(.bottom, 2)
//                
//                HStack {
//                    // Date
//                    HStack(spacing:3){
//                        Text(appointment.dayName ?? "الإثنين")
//                        
//                        Text(appointment.formattedDate)
////                            .font(.medium(size: 14))
//                    }
//                    .font(.medium(size: 12))
//                    .foregroundColor(.mainBlue)
//                    
//                    Spacer()
//                    
//                    HStack(spacing:3){
//                        Image(systemName: "clock")
//                            .foregroundColor(.mainBlue)
//
//                    // Time
//                    Text(appointment.formattedTime)
//                }
//                    .font(.medium(size: 12))
//                    .foregroundColor(Color(.secondary))
//
//                }
//                .padding(.top, 4) // Adjust spacing
//            }
//            .padding(.horizontal, 16)
//            .padding(.top, 12)
//            .padding(.bottom, 8)
//            .background(Color.white)
//            
//            HStack(alignment: .bottom){
//                
//            // Bottom Section (Dark Blue background)
//                VStack(alignment: .leading, spacing: 8) { // Right aligned for Arabic
//                    Text("doc_name".localized)
//                        .font(.medium(size: 16))
//                        .foregroundColor(.white)
//                    
//                    Text(appointment.doctorName ?? "doctorName")
//                        .font(.semiBold(size: 22))
//                        .foregroundColor(.white)
//                }
////                .frame(maxWidth: .infinity,alignment: .leading)
//                    Spacer()
//                Button(action: {
//                        renewaction()
//                    },label:{
//                        HStack(spacing:3){
//                            Image("newreschedual")
//                                .resizable()
//                                .frame(width: 10, height: 8.5)
//                            Text("renew_subscription".localized)
//                                .underline()
//                        }
//                        .foregroundStyle(Color.white)
//                        .font(.regular(size: 12))
//                    })
//
//            }
//            .padding(.horizontal, 16)
//            .padding(.vertical, 12)
//            .frame(maxWidth: .infinity)
//            .background(Color.mainBlue)
//        }
//        .cardStyle(cornerRadius: 3)
//
//    }
//}

//struct DocPackageCardView: View {
//    let item: SubcripedPackageItemM
//    var selectAction: () -> Void
//    var buttonAction: () -> Void
//
//    var body: some View {
//        Button(action: selectAction) {
//            ZStack(alignment: .bottom) {
//                KFImageLoader(url: URL(string: Constants.imagesURL + (item.packageImage?.validateSlashs() ?? "")), placeholder: Image("logo"), shouldRefetch: true)
//                    .frame(height: 180)
//
//                VStack {
//                    // Top info
//                    HStack(alignment: .top) {
//                        Image("dateicon 1")
//                            .resizable()
//                            .frame(width: 11, height: 11)
//
//                        VStack(alignment: .leading) {
//                            Text("subscription_Date".localized + "  \(item.subscriptionDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd") ?? "")")
//                                .font(.semiBold(size: 12))
//                                .foregroundStyle(.white)
//
//                            Text("last_session_Date".localized + "  \(item.lastSessionDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd") ?? "")")
//                                .font(.medium(size: 10))
//                                .foregroundStyle(.white)
//                        }
//
//                        Spacer()
//
//                        HStack(spacing: 3) {
//                            Circle().frame(width: 5, height: 5)
//                            Text(item.status ?? "Active_".localized)
//                        }
//                        .font(.medium(size: 12))
//                        .foregroundStyle(.white)
//                        .padding(.horizontal, 10)
//                        .frame(height: 22)
//                        .background(Color(item.canCancel ?? false ? .active : .notActive))
//                        .cardStyle(cornerRadius: 3)
//                    }
//                    .padding(8)
//                    .background(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .clear]), startPoint: .top, endPoint: .bottom))
//
//                    Spacer()
//
//                    // Bottom info
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack {
//                            Text(item.packageName ?? "")
//                                .font(.semiBold(size: 20))
//                                .foregroundStyle(.white)
//
//                            Spacer()
//
//                            Button(action: buttonAction) {
//                                HStack(spacing: 3) {
//                                    Image(item.canRenew ?? false ? "newreschedual" : "cancelsubscription")
//                                        .resizable()
//                                        .frame(width: 10, height: 8.5)
//
//                                    Text(item.canRenew ?? false ? "renew_subscription".localized : "cancel_subscription".localized)
//                                        .underline()
//                                }
//                                .font(.regular(size: 12))
//                                .foregroundStyle(.white)
//                            }
//                        }
//
//                        Text(item.categoryName ?? "")
//                            .font(.medium(size: 14))
//                            .foregroundStyle(.white)
//
//                        HStack {
//                            Text(item.mainCategoryName ?? "")
//                                .foregroundStyle(.white)
//
//                            Spacer()
//
//                            Image(.newdocicon)
//                                .resizable()
//                                .renderingMode(.template)
//                                .frame(width: 10, height: 12)
//                                .foregroundStyle(Color(.secondary))
//
//                            Text("doc_".localized + " / " + (item.doctorName ?? "Doctor"))
//                                .font(.semiBold(size: 16))
//                                .foregroundStyle(.white)
//                        }
//                    }
//                    .padding(8)
//                    .background(
//                        BlurView(radius: 5)
//                            .horizontalGradientBackground()
//                            .opacity(0.89)
//                    )
//                }
//            }
//        }
//        .buttonStyle(.plain)
//        .cardStyle(cornerRadius: 3)
//    }
//}
