//
//  SubcripedPackagesView.swift
//  Sehaty
//
//  Created by mohamed hammam on 26/05/2025.
//

import SwiftUI

struct SubcripedPackagesView: View {
    //    var mainCategory:HomeCategoryItemM
    @EnvironmentObject var profileViewModel: EditProfileViewModel
    @StateObject var router = NavigationRouter.shared
    @StateObject private var viewModel = SubcripedPackagesViewModel.shared
    var hasbackBtn : Bool? = true
    //    var onBack: (() -> Void)? // for uikit dismissal
    
    @State var showCancel: Bool = false
    @State var idToCancel: Int?
    
    @State var destination = AnyView(EmptyView())
    @State var mustLogin: Bool = false
    //    @State var isactive: Bool = false
    //    func pushTo(destination: any View) {
    //        self.destination = AnyView(destination)
    //        self.isactive = true
    //    }
    
    init(hasbackBtn : Bool? = true) {
        self.hasbackBtn = hasbackBtn
        //        self.onBack = onBack
    }
    
    var body: some View {
        //        NavigationView(){
        VStack(spacing:0){
            VStack(){
                TitleBar(title: "subscriped_title",titlecolor: .white,hasbackBtn: hasbackBtn ?? true)
                    .padding(.top,55)
                
                VStack(spacing:5){
                    //                    if isLogedin{
                    //                        KFImageLoader(url:URL(string:Constants.imagesURL + (viewModel.imageURL?.validateSlashs() ?? "")),placeholder: Image(.user), isOpenable: true,shouldRefetch: false)
                    //
                    ////                            Image(systemName: "person.circle.fill")
                    ////                            .resizable()
                    //                            .clipShape(Circle())
                    //                        .scaledToFill()
                    //                        .frame(width: 50, height: 50)
                    //                    }
                    if let imageURL = profileViewModel.imageURL{
                        KFImageLoader(url:URL(string:Constants.imagesURL + (imageURL.validateSlashs())),placeholder: Image(.onboarding1), isOpenable:true, shouldRefetch: false)
                            .clipShape(Circle())
                            .background(Circle()
                                .stroke(.white, lineWidth: 5).padding(-2))
                            .frame(width: 91,height:91)
                        if profileViewModel.Name.count > 0{
                            Text(profileViewModel.Name)
                                .font(.semiBold(size: 14))
                                .foregroundStyle(Color.white)
                        }else{
                            Text("home_Welcome".localized)
                                .font(.semiBold(size: 14))
                                .foregroundStyle(Color.white)
                        }
                    }else{
                        Spacer()
                    }
                }
                .background{
                    Image(.logoWaterMarkIcon)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(.white)
                        .allowsHitTesting(false)
                        .frame(width: UIScreen.main.bounds.width)
                }
                .padding(.vertical,10)
            }
            .frame(height: 232)
            .horizontalGradientBackground()
            
            //            if viewModel.isLoading ?? false && viewModel.subscripedPackages?.items == nil {
            //                VStack{
            //                    ForEach(0..<3) { _ in
            //                        SkeletonPackageCard()
            //                            .padding(.horizontal)
            //                            .padding(.vertical, 4)
            //                    }
            //                 Spacer()
            //                }
            //            } else {
            

                SubcripedPackagesListView(packages: viewModel.subscripedPackages?.items,selectAction: {package in
                    router.push(SubcripedPackageDetailsView(package: nil, CustomerPackageId: package.customerPackageID))
                },buttonAction:{item in
                    
                    if item.canRenew ?? false{
                        // renew subscription
                        guard let doctorId = item.docotrID else { return }
                        router.push(PackageMoreDetailsView( doctorPackageId: doctorId,currentcase:.renew) )
                    }else if item.canCancel ?? false{
                        // sheet for cancel subscription
                        guard let doctorPackageId = item.customerPackageID else { return }
                        idToCancel = doctorPackageId
                        showCancel = true
                    }
                },loadMore: {
                    Task {
                        await viewModel.loadMoreIfNeeded()
                    }
                })
                .refreshable {
                    await viewModel.refresh()
                }
            
                
            //            }
            
            //            Group {
            //                if let packages = viewModel.subscripedPackages?.items {
            //                    SubcripedPackagesListView(packaces: packages, selectAction: { package in
            //                        pushTo(destination: SubcripedPackageDetailsView(package: package))
            //                    }, buttonAction: { item in
            //                        if item.canRenew ?? false {
            //                            // renew subscription
            //                            guard let doctorPackageId = item.customerPackageID else { return }
            //                            pushTo(destination: PackageMoreDetailsView( doctorPackageId: doctorPackageId,currentcase:.renew))
            //                        } else if item.canCancel ?? false {
            //                            // sheet for cancel subscription
            //                            showCancel = true
            //                        }
            //                    }, loadMore: {
            //                        Task {
            //                            await viewModel.loadMoreIfNeeded()
            //                        }
            //                    })
            //                    .refreshable {
            //                        await viewModel.refresh()
            //                    }
            //                }else{
            //                    Spacer()
            //                }
            
            //            }
            Spacer().frame(height: hasbackBtn ?? true ? 0 : 80)
            
        }
        .onAppear {
            Task{
                if (Helper.shared.CheckIfLoggedIn()) {
                    async let Profile:() = profileViewModel.getProfile()
                    async let Packages:() = viewModel.refresh()
//                    await viewModel.getSubscripedPackages()
                     _ = await (Profile,Packages)
                    
                    print("Items count:", viewModel.subscripedPackages?.items?.count ?? -1)
                       print("Items:", viewModel.subscripedPackages?.items ?? [])
                } else {
                    profileViewModel.cleanup()
                    viewModel.clear()
                    mustLogin = true
                }
            }
        }
        .localizeView()
        .withNavigation(router: router)
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
        .edgesIgnoringSafeArea([.top,.horizontal])
//        .onAppear {
//            Task{
//                if (Helper.shared.CheckIfLoggedIn()) {
//                    async let Profile:() = profileViewModel.getProfile()
////                    async let Packages:() = viewModel.refresh()
//                    await viewModel.getSubscripedPackages()
//                     _ = await (Profile)
//                    
//                    print("Items count:", viewModel.subscripedPackages?.items?.count ?? -1)
//                       print("Items:", viewModel.subscripedPackages?.items ?? [])
//                } else {
//                    profileViewModel.cleanup()
//                    viewModel.clear()
//                    mustLogin = true
//                }
//            }
//        }
        //        NavigationLink( "", destination: destination, isActive: $isactive)
        
        .customSheet(isPresented: $mustLogin ,height: 350){
            LoginSheetView()
        }
        
        if showCancel{
            CancelSubscriptionView(isPresent: $showCancel, customerPackageId: idToCancel ?? 0,onCancelSuccess: {
                if let index = viewModel.subscripedPackages?.items?.firstIndex(where: { $0.customerPackageID == idToCancel }) {
                    viewModel.subscripedPackages?.items?[index].canCancel?.toggle()
                }
            })
        }
        
    }
}

#Preview {
    SubcripedPackagesView().environmentObject(EditProfileViewModel.shared)
}

struct SubcripedPackagesListView: View {
    var packages: [SubcripedPackageItemM]?
    var selectAction: ((SubcripedPackageItemM) -> Void)?
    var buttonAction: ((SubcripedPackageItemM) -> Void)?
    var loadMore: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            SectionHeader(image: Image(.newvippackicon), title: "subscriped_packages")
                .padding([.horizontal, .top])

            if let packages = packages{
//                if let packages = packaces, packages.count > 0 {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(packages, id: \.self) { item in
                            SubscribedPackageCardView(item: item, selectAction: {
                                selectAction?(item)
                            }, buttonAction: {
                                buttonAction?(item)
                            })
                            .onAppear {
                                if item == packages.last {
                                    loadMore?()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                SubscribedPackageEmptyView()
            }
        }
    }
}

struct SubscribedPackageCardView: View {
    let item: SubcripedPackageItemM
    var selectAction: () -> Void
    var buttonAction: () -> Void

    var body: some View {
        Button(action: selectAction) {
            ZStack(alignment: .bottom) {
                KFImageLoader(url: URL(string: Constants.imagesURL + (item.packageImage?.validateSlashs() ?? "")), placeholder: Image("logo"), shouldRefetch: true)
                    .frame(height: 180)

                VStack {
                    // Top info
                    HStack(alignment: .top) {
                        Image("dateicon 1")
                            .resizable()
                            .frame(width: 11, height: 11)

                        VStack(alignment: .leading) {
                            Text("subscription_Date".localized + "  \(item.subscriptionDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd") ?? "")")
                                .font(.semiBold(size: 12))
                                .foregroundStyle(.white)

                            Text("last_session_Date".localized + "  \(item.lastSessionDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd") ?? "")")
                                .font(.medium(size: 10))
                                .foregroundStyle(.white)
                        }

                        Spacer()

                        HStack(spacing: 3) {
                            Circle().frame(width: 5, height: 5)
                            Text(item.status ?? "Active_".localized)
                        }
                        .font(.medium(size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .frame(height: 22)
                        .background(Color(item.canCancel ?? false ? .active : .notActive))
                        .cardStyle(cornerRadius: 3)
                    }
                    .padding(8)
                    .background(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .clear]), startPoint: .top, endPoint: .bottom))

                    Spacer()

                    // Bottom info
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(item.packageName ?? "")
                                .font(.semiBold(size: 20))
                                .foregroundStyle(.white)

                            Spacer()

                            Button(action: buttonAction) {
                                HStack(spacing: 3) {
                                    Image(item.canRenew ?? false ? "newreschedual" : "cancelsubscription")
                                        .resizable()
                                        .frame(width: 10, height: 8.5)

                                    Text(item.canRenew ?? false ? "renew_subscription".localized : "cancel_subscription".localized)
                                        .underline()
                                }
                                .font(.regular(size: 12))
                                .foregroundStyle(.white)
                            }
                        }

                        Text(item.categoryName ?? "")
                            .font(.medium(size: 14))
                            .foregroundStyle(.white)

                        HStack {
                            Text(item.mainCategoryName ?? "")
                                .foregroundStyle(.white)

                            Spacer()

                            Image(.newdocicon)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 10, height: 12)
                                .foregroundStyle(Color(.secondary))

                            Text("doc_".localized + " / " + (item.doctorName ?? "Doctor"))
                                .font(.semiBold(size: 16))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(8)
                    .background(
                        BlurView(radius: 5)
                            .horizontalGradientBackground()
                            .opacity(0.89)
                    )
                }
            }
        }
        .buttonStyle(.plain)
        .cardStyle(cornerRadius: 3)
    }
}

struct SubscribedPackageEmptyView: View {
    var body: some View {
        VStack {
            Image(.nosubscription)
                .resizable()
                .frame(width: 162, height: 162)

            Text("subscriped_no_packages".localized)
                .font(.semiBold(size: 22))
                .foregroundStyle(Color(.btnDisabledTxt))
                .padding()
                .multilineTextAlignment(.center)
                .lineSpacing(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
