//
//  SubcripedPackageDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 28/05/2025.
//

import SwiftUI

struct SubcripedPackageDetailsView: View {
    @StateObject var router = NavigationRouter.shared

    @StateObject var viewmodel = SubcripedPackageDetailsViewModel.shared
    @State var package: SubcripedPackageItemM?
    var CustomerPackageId: Int?

    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    init(package: SubcripedPackageItemM?,CustomerPackageId:Int?) {
        if let package = package{
            self.package = package
        }
        if let CustomerPackageId = CustomerPackageId{
            self.CustomerPackageId = CustomerPackageId
        }
   
    }
    @State var isReschedualling: Bool = false

    enum SectionType: CaseIterable,Hashable {
        case chats, sessions, files
        
        var title: String {
            switch self {
            case .chats: return "Chats"
            case .sessions: return "Sessions"
            case .files: return "Files"
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
                            HStack(spacing:0){
                                Text( "remain_".localized)
                                
                                let reamin = (package?.sessionCount ?? 0) - (package?.attendedSessionCount ?? 0)
                                
                                (Text(" \(reamin) " + "from".localized + " \(package?.sessionCount ?? 0) "))
                                    .font(.bold(size: 12))
                                
                                Text( "sessions_ar".localized )
                                
                                Image("remainingsessions")
                                    .resizable()
                                    .frame(width: 9, height: 9)
                                    .padding(.horizontal,3)
                                
                            }
                            .font(.regular(size: 12))
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(Color(.white))
                            .padding(.vertical,8)
                            
                            Button(action: {
                                guard let customerPackageID = package?.customerPackageID else { return }

                                if package?.canRenew ?? false{
                                    // renew subscription
                                    guard let docotrID = package?.docotrID else { return }
                                    router.push(PackageMoreDetailsView( doctorPackageId: docotrID,currentcase:.renew) )
                                    
                                }else if package?.canCancel ?? false{
                                    // sheet for cancel subscription
                                    idToCancel = customerPackageID
                                    showCancel = true
                                }
                                
                            },label:{
                                HStack(spacing:3){
                                    Image(package?.canRenew ?? false ? "newreschedual" : "cancelsubscription")
                                        .resizable()
                                        .frame(width: 10, height: 8.5)
                                    Text(package?.canRenew ?? false ? "renew_subscription".localized: "cancel_subscription".localized)
                                        .underline()
                                }
                                .foregroundStyle(Color.white)
                                .font(.regular(size: 12))
                            })
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
                    .offset(y:-11)
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
                                pushTo(destination: ChatsView(CustomerPackageId: customerPackageID) )
                            case .sessions:
                                break
                            case .files:
                                guard let customerPackageID = package?.customerPackageID else { return }
                                pushTo(destination: PackageFilesView(CustomerPackageId: customerPackageID) )
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
                
                ZStack{
                    VStack(spacing:8){
                        
                        KFImageLoader(url:URL(string:Constants.imagesURL + (package?.doctorImage?.validateSlashs() ?? "")),placeholder: Image("logo") , shouldRefetch: true)
                            .frame(height: 160)
                            .frame(maxWidth:.infinity)
                            .cardStyle(cornerRadius: 3,shadowOpacity: 0.1)
                        //                            .padding(.v)
                        
                        HStack(alignment: .center,spacing: 5){
                            (Text("doc_".localized + " / ".localized) + Text(package?.doctorName ?? "Doctor name"))
                                .font(.bold(size: 16))
                                .frame(maxWidth: .infinity,alignment:.leading)
                                .foregroundStyle(Color.white)
                            
                            HStack(spacing:2) {
                                Text(package?.doctorSpeciality ?? "speciality")
                                    .font(.medium(size: 10))
                                    .foregroundStyle(Color.white)
                                
                                Image(.newpharmacisticon)
                                //                                            .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 12,height:12)
                                    .scaledToFit()
                                //                                            .foregroundStyle(.white)
                                    .padding(3)
                            }
                            //                                        .background(Color(.secondary))
                        }
                        
                        HStack(spacing:2) {
                            Image(.egFlagIcon)
                                .resizable()
                                .frame(width: 12,height:8)
                                .scaledToFit()
                                .padding(3)
                            
                            Text(package?.doctorNationality ?? "egyption")
                                .font(.semiBold(size: 12))
                                .foregroundStyle(Color.white)
                        }
                        .frame(maxWidth: .infinity,alignment:.leading)
                        
                    }
                    .padding(8)
                }
                .horizontalGradientBackground()
                .cardStyle(cornerRadius: 3,shadowOpacity: 0.1)
                .padding(.horizontal)
                
                SubcripedNextSession(upcomingSession: viewmodel.upcomingSession,detailsAction: {
                    
                },rescheduleAction: {
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
            Task{
                if let CustomerPackageId = CustomerPackageId{
                    async let upcoming: () = viewmodel.getUpcomingSession()
                    async let packages: () = viewmodel.getSubscripedSessionsList(customerPackageId: CustomerPackageId)
                    
                    _ = await (upcoming,packages)

                    self.package = viewmodel.subscripedPackage
                }
            }
        }
        NavigationLink( "", destination: destination, isActive: $isactive)
            .customSheet(isPresented: $isReschedualling){
                ReSchedualView(isPresentingNewMeasurementSheet: $isReschedualling,reschedualcase: .reschedualSession)
            }
        if showCancel{
            CancelSubscriptionView(isPresent: $showCancel, customerPackageId: idToCancel ?? 0,onCancelSuccess: {
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
    SubcripedPackageDetailsView(package: .init(), CustomerPackageId: 0)
}

struct SubcripedNextSession: View {
    var upcomingSession: UpcomingSessionM?
//    var canJoin = true
    var detailsAction: (() -> Void)?
    var rescheduleAction: (() -> Void)?

    var body: some View {
        VStack{
            SectionHeader(image: Image(.newnxtsessionicon),title: "subscription_nextSessions"){
                //                            go to last mes package
            }
            
            //            ZStack(alignment: .center){
            //                HStack {
            //                    Image(.nextsessionbg)
            //                    .resizable()
            //                    Spacer()
            //                }.padding(8)
            
            VStack(spacing: 20){
                HStack(alignment:.top){
//                    if canJoin{
//                        Button(action: {
//                            
//                        }){
//                            HStack(alignment: .center){
//                                Image(.newjoinicon)
//                                    .resizable()
//                                    .frame(width: 15, height: 15)
//                                
//                                Text("Join_now".localized)
//                                    .font(.bold(size: 12))
//                                    .foregroundStyle(Color(.secondary))
//                                
//                            }
//                            .padding(.horizontal,13)
//                            .frame(height: 30)
//                            //                                            .padding(.vertical,15)
//                            .background{Color(.white)}
//                            .cardStyle( cornerRadius: 3)
//                        }
//                    }else{
                         NextSessionCountdownOrJoinView(session: upcomingSession)
                        
//                        HStack(alignment:.top,spacing:3) {
//                            VStack(){
//                                // Title
//                                Text("2")
//                                    .font(.medium(size: 14))
//                                    .foregroundStyle(Color.white)
//                                    .frame(width: 31, height: 31)
//                                    .background{Color(.secondaryMain)}
//                                    .cardStyle( cornerRadius: 3)
//                                
//                                // Title
//                                Text("Days".localized)
//                                    .font(.regular(size: 8))
//                                    .foregroundStyle(Color.white)
//                                    .minimumScaleFactor(0.5)
//                                    .lineLimit(1)
//                            }
//                            
//                            Text(":")
//                                .font(.regular(size: 12))
//                                .foregroundStyle(Color.white)
//                                .offset(y:10)
//                            
//                            VStack(){
//                                // Title
//                                Text("11")
//                                    .font(.medium(size: 14))
//                                    .foregroundStyle(Color.white)
//                                    .frame(width: 31, height: 31)
//                                    .background{Color(.secondaryMain)}
//                                    .cardStyle( cornerRadius: 3)
//                                
//                                // Title
//                                Text("Hours".localized)
//                                    .font(.regular(size: 8))
//                                    .foregroundStyle(Color.white)
//                                    .minimumScaleFactor(0.5)
//                                    .lineLimit(1)
//                            }
//                            
//                            Text(":")
//                                .font(.regular(size: 12))
//                                .foregroundStyle(Color.white)
//                                .offset(y:10)
//                            
//                            VStack(){
//                                // Title
//                                Text("31")
//                                    .font(.medium(size: 14))
//                                    .foregroundStyle(Color.white)
//                                    .frame(width: 31, height: 31)
//                                    .background{Color(.secondaryMain)}
//                                    .cardStyle( cornerRadius: 3)
//                                
//                                // Title
//                                Text("Minutes".localized)
//                                    .font(.regular(size: 8))
//                                    .foregroundStyle(Color.white)
//                                    .minimumScaleFactor(0.5)
//                                    .lineLimit(1)
//                            }
//                        }
//                    }
                    
                    Spacer()
                    
                    HStack(alignment:.top) {
                        
                        VStack(){
                            // Title
                            Text(upcomingSession?.sessionDate ?? "12-05-2025")
                                .font(.regular(size: 12))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.bottom,1)
                            
                            // Title
                            Text(upcomingSession?.formattedSessionTime ?? "")
                                .font(.regular(size: 12))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Image(.newcal)
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                }
                
                HStack(alignment:.bottom,spacing:3) {
                    
                    Button(action: {
                        detailsAction?()

                    }){
                        HStack(alignment: .center){
                            Image(.newmoreicon)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(Color.white)
                            
                            Text("more_detail".localized)
                                .font(.bold(size: 12))
                                .foregroundStyle(Color.white)
                        }
                        
                        //                            .padding(.horizontal,30)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background{Color(.secondaryMain)}
                        .cardStyle( cornerRadius: 3)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        rescheduleAction?()

                    }){
                        HStack(alignment: .bottom){
                            Image(.newreschedual)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 15, height: 15)
                            
                                .foregroundStyle(Color.white)
                            
                            Text("reSchedual".localized)
                                .underline()
                                .font(.regular(size: 12))
                                .foregroundStyle(Color.white)
                        }
                        .padding(.horizontal,10)
                        .padding(.bottom,5)
                        .frame(alignment:.bottom)
                    }
                }
            }
            //            }
            .frame(maxWidth: .infinity, maxHeight: 124)
            .padding(10)
            .background(
                ZStack{
                    Color.mainBlue
                    Image(.nextsessionbg)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 124)
                    
                }
            )
            .cardStyle(cornerRadius: 4,shadowOpacity: 0.4)
            //            .padding(.vertical,5)
            
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
        
    }
}


struct SubcripedSessionsList: View {
    var sessions: [SubcripedSessionsListItemM]?
    var canJoin = true
    var loadMore: (() -> Void)?

    var body: some View {
        VStack{
//            SectionHeader(image: Image(.newnxtsessionicon),title: "subscription_nextSessions"){
//                //                            go to last mes package
//            }
            List{
                ForEach(sessions ?? [],id: \.self){session in
                VStack(spacing: 20){
                    HStack(alignment:.top){
                        
                        HStack(alignment:.top) {
                            // Title
                            Text(session.dayName ?? "Monday")
                                .font(.bold(size: 16))
                                .foregroundStyle(Color(.main))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom,1)
                            
                            // Title
                            HStack {
                                Image(.timeIcon)
                                //                                .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                
                                ( Text("\(session.timeFrom ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")) + Text(" - ") + Text("\(session.timeTo ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")))
                                    .font(.medium(size: 12))
                                    .foregroundStyle(Color(.main))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                    
                    HStack() {
                        // Title
                        HStack(alignment: .center) {
                            Image(.dateicon1)
                            //                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 16, height: 16)
                            
                            Text(session.date ?? "12-05-2025")
                                .font(.medium(size: 12))
                                .foregroundStyle(Color(.main))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom,1)
                        }
                        
                        Spacer()
                        
                        Button(action: {

                        }){
                            HStack(alignment: .bottom){
                                Image(.newreschedual)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                
                                Text("reSchedual".localized)
                                    .underline()
                                    .font(.regular(size: 12))
                            }
                            .foregroundStyle(Color(.secondary))
                            .padding(.horizontal,10)
                            .padding(.bottom,5)
                            .frame(alignment:.bottom)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 124)
                .padding(10)
                .cardStyle(cornerRadius: 3)
                .onAppear {
                    // Detect when the last item appears
                    guard session == sessions?.last else {return}
                        loadMore?()
                }
                    
            }
        }
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
        
    }
}
