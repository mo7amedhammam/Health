//
//  ActiveCustomerPackagesView.swift
//  Sehaty
//
//  Created by mohamed hammam on 31/08/2025.
//
import SwiftUI

struct ActiveCustomerPackagesView: View {
    @StateObject var router = NavigationRouter.shared

    @StateObject var viewmodel = ActiveCusPackViewModel.shared
    @State var package: SubcripedPackageItemM?
    var CustomerPackageId: Int?

//    @State var destination = AnyView(EmptyView())
//    @State var isactive: Bool = false
//    func pushTo(destination: any View) {
//        self.destination = AnyView(destination)
//        self.isactive = true
//    }
//    init(package: SubcripedPackageItemM?,CustomerPackageId:Int?) {
//        if let package = package{
//            self.package = package
//        }
//        if let CustomerPackageId = CustomerPackageId{
//            self.CustomerPackageId = CustomerPackageId
//        }
//   
//    }
    @State var reschedualcase: reschedualCases? = .reschedualSession
    @State var isReschedualling: Bool = false

    enum SectionType: CaseIterable,Hashable {
        case chats, sessions, files
        
        var title: String {
            switch self {
            case .chats: return "Chats_"
            case .sessions: return "sessions_"
            case .files: return "Files_"
            }
        }
        
        var image: Image {
            switch self {
            case .chats: return Image(.chats)
            case .sessions: return Image(.sessions)
            case .files: return Image(.packagefiles)
            }
        }
    }
    
    @State var selectedSection: SectionType = .sessions
 
    @State var showCancel: Bool = false
    @State var idToCancel: Int?

    var body: some View {
        //        NavigationView(){
        VStack(spacing:0){
            VStack(){
                TitleBar(title: "",hasbackBtn: true)
                    .padding(.top,50)
                
                Spacer()
                
                ZStack (alignment:.top){
                    HStack{
                        VStack{
                            Text(package?.packageName ?? "pack_Name".localized)
                                .font(.semiBold(size: 20))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity,alignment:.leading)
                            
                            HStack{
                                Text(package?.mainCategoryName ?? "main_category")
                                Circle()
                                    .fill(Color(.secondary))
                                    .frame(width: 5, height: 5)
                                
                                Text(package?.categoryName ?? "sub_category")
                                
                            }
                            .font(.medium(size: 14))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity,alignment:.leading)
                        }
                        
                        VStack(alignment: .trailing,spacing: 5){
                            
                            HStack (spacing:3){
                                Circle()
                                    .frame(width: 5, height: 5)
                                
                                Text(package?.status ?? "Active")
                            }
                            .font(.medium(size: 10))
                            .foregroundStyle(Color.white)
                            .frame(height:22)
                            .padding(.horizontal,10)
                            .background{Color(package?.canCancel ?? false ? .active:.notActive)}
                            .cardStyle( cornerRadius: 3)
                            
                            HStack(spacing:0){
                                Text( "remain_".localized)
                                
//                                let reamin = (package?.sessionCount ?? 0) - (package?.attendedSessionCount ?? 0)
                                
                                (Text(" \(package?.remainingSessionCount ?? 0) " + "from_".localized + " \(package?.sessionCount ?? 0) "))
                                    .font(.bold(size: 12))
                                
                                Text( "sessions_ar".localized )
                                
                                Image("remainingsessions")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 9, height: 9)
                                    .padding(.horizontal,3)
                                    .foregroundStyle(.white)
                            }
                            .font(.regular(size: 12))
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(Color(.white))
                            .padding(.vertical,8)
                            
                        }
                        .font(.regular(size: 10))
                        .foregroundStyle(Color.white)
                        
                    }
                    .padding(.horizontal,10)
                    .padding(.vertical,5)
                    .background{
                        BlurView(radius: 5)
                            .horizontalGradientBackground().opacity(0.89)
                    }
                }
            }
            .background{
                KFImageLoader(url:URL(string:Constants.imagesURL + (package?.packageImage?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                    .frame( height: 238)
            }
            .frame(height: 238)
            
            ScrollView(showsIndicators: false){
                
                HStack{
                    ForEach(SectionType.allCases,id: \.self) { button in
                        Spacer()
                        Button(action: {
                            //                                 button.action?()
                            selectedSection = button
                            switch button {
                            case .chats:
                                guard let customerPackageID = package?.customerPackageID else { return }
                                router.push( ChatsView(CustomerPackageId: customerPackageID) )
                            case .sessions:
                                break
                            case .files:
                                guard let customerID = package?.customerID, let packageId = package?.customerPackageID else { return }
                                router.push( ActiveCustPackFiles(customerId: customerID,PackageId: packageId) )
                            }
                        }) {
                            VStack(spacing:7) {
                                //                                     Image(.chats)
                                button.image
                                    .resizable()
                                    .padding(15)
                                    .background(selectedSection == button ? Color(.secondary):Color(.btnDisabledTxt))
                                    .frame(width: 70,height: 70)
                                    .cardStyle(cornerRadius: 3)
                                
                                Text(button.title.localized)
                                    .font(.bold(size: 12))
                                    .foregroundStyle(selectedSection == button ? Color(.secondary):Color(.btnDisabledTxt))
                            }
                        }
                        
                        if button == .chats || button == .sessions{
                            Spacer()
                            Color.gray.opacity(0.2).frame(width: 1, height: 70)
                                .padding(.bottom)
                        }else{
                            Spacer()
                        }
                    }
                }
                .padding(.vertical)
                
                if let customerName = package?.customerName{
                    CustomerHeaderView(
                        name: customerName,
                        imageUrl: package?.customerImage ?? ""
                    ){
                        
                    }
                }
                
                CustomerMesurmentsSection(measurements: viewmodel.customerMeasurements){item in
                    guard let item = item else { return }
                    router.push(MeasurementDetailsView(stat: item))
                }
                
                CustomButton(title: "select_next_session",isdisabled: false,backgroundView:AnyView(Color.clear.horizontalGradientBackground())){
//                    showFilter.toggle()
                    Task{ reschedualcase = .nextSession }
                    isReschedualling = true
                }
                
                SubcripedNextSession(upcomingSession: viewmodel.upcomingSession,rescheduleAction: {
                    Task{ reschedualcase = .reschedualSession }
                    isReschedualling = true
                })
                    .padding(.horizontal)
                
                SubcripedSessionsList(sessions: viewmodel.subscripedSessions?.items)
                    .padding(.horizontal)
                
                //                    VStack(alignment:.leading){
                //                        AvailableDoctorsListView(){doctor in
                //                            guard let doctorPackageId  = doctor.packageDoctorID else {return}
                //                            pushTo(destination: PackageMoreDetailsView(doctorPackageId: doctorPackageId))
                //                        }
                //                            .environmentObject(viewmodel)
                //                    }
                //                    .padding([.horizontal,.top],10)
                
                //                    Spacer()
                
                Spacer().frame(height: 55)
            }
            
        }
        .edgesIgnoringSafeArea([.top,.horizontal])
        //            .task {
        //                guard let packageId  = package.id else {return}
        //                await viewmodel.getAvailableDoctors(PackageId: packageId)
        //            }
//        .reversLocalizeView()
        .localizeView()
        .withNavigation(router: router)
        .showHud(isShowing:  $viewmodel.isLoading)
        .errorAlert(isPresented: .constant(viewmodel.errorMessage != nil), message: viewmodel.errorMessage)
        .onAppear{
            selectedSection = .sessions
            Task{
                if let CustomerPackageId = CustomerPackageId{
                    async let upcoming: () = viewmodel.getUpcomingSession()
                    async let packages: () = viewmodel.getSubscripedPackageDetails(CustomerPackageId: CustomerPackageId)
                    async let measurements: () = viewmodel.getCustomerMeasurements(CustomerPackageId:CustomerPackageId)
                    
                    _ = await (upcoming,packages,measurements)

                    self.package = viewmodel.subscripedPackage
                }
            }
        }
//        NavigationLink( "", destination: destination, isActive: $isactive)
        .customSheet(isPresented: $isReschedualling){
            if let CustomerPackageId = CustomerPackageId{
                ReSchedualView(doctorPackageId: CustomerPackageId, isPresentingNewMeasurementSheet: $isReschedualling,reschedualcase:reschedualcase,onRescheduleSuccess: {
                    
                })
            }
        }
        if showCancel{
            CancelSubscriptionView(isPresent: $showCancel,customerPackageId: idToCancel ?? 0,onCancelSuccess: {
//                if let index = viewModel.subscripedPackages?.items?.firstIndex(where: { $0.customerPackageID == idToCancel }) {
//                    viewModel.subscripedPackages?.items?[index].canCancel?.toggle()
//                }
                Task{
                    if let CustomerPackageId = CustomerPackageId{
                        await viewmodel.getSubscripedPackageDetails(CustomerPackageId: CustomerPackageId)
                    }
                }
            })
        }
    }
}

#Preview {
    ActiveCustomerPackagesView(package: .init(), CustomerPackageId: 0)
}


struct CustomerHeaderView: View {
    var name: String
    var imageUrl: String?
    var onSendNotification: (() -> Void)? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Profile Image with gradient border
            ZStack {
                Circle()
                    .strokeBorder(
                        LinearGradient(colors: [.mainBlue, Color(.secondary)],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing),
                        lineWidth: 4
                    )
                    .frame(width: 73, height: 73)
                
                if let imageUrl = imageUrl {
                    KFImageLoader(url:URL(string:Constants.imagesURL + (imageUrl.validateSlashs())),placeholder: Image("logo"), shouldRefetch: true)
                        .frame(width: 66, height: 66)
                        .clipShape(Circle())
                } else {
                    Image("placeholder_user")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 66, height: 66)
                }
            }
            
            // Customer name
            ZStack {
                Image("logoWaterMarkIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 105)
                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.bold(size: 24))
                        .foregroundColor(.mainBlue)
                    
                    Button(action: {
                        onSendNotification?()
                    }) {
                        HStack(spacing: 4) {
                            Image("inactivedrugicon")
                                .resizable()
                                .frame(width: 14, height: 14)
                            Text("send_customer_notification".localized)
                                .font(.semiBold(size: 14))
                                .underline()
                        }
                        .foregroundColor(Color(.secondary))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .padding([.vertical,.leading])
    }
}
