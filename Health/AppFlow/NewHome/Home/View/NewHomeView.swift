//
//  NewHomeView.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/04/2025.
//

import SwiftUI

struct NewHomeView: View {
    @StateObject private var viewModel = NewHomeViewModel.shared
    @State private var refreshTask: Task<Void, Never>?
    @StateObject var wishlistviewModel: WishListManagerViewModel = WishListManagerViewModel.shared

    @State var selectedPackage : FeaturedPackageItemM?

    init() {
    }
    
    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    
    var body: some View {
//        NavigationView(){
            VStack{
                TitleBar(title: "home_navtitle")
                
                ScrollView(showsIndicators: false){
                    HeaderView()
                        .padding(.horizontal)

                    VStack(alignment:.leading){
//                        Group{
                            if let nextsession = viewModel.upcomingSession{
                                NextSessionSection(upcomingSession: nextsession)
                                    .padding(.horizontal)
                            }
//                        }
//                        .task {
//                            await viewModel.getUpcomingSession()
//                        }
                        MainCategoriesSection(categories: viewModel.homeCategories){category in
                            pushTo(destination: PackagesView(mainCategory: category))
                        }
//                            .task {
//                                await viewModel.getHomeCategories()
//                            }
                        
                        Image(.adsbg)
                            .resizable()
                            .frame(height: 137)
                            .padding(.horizontal)

                        LastMesurmentsSection(measurements: viewModel.myMeasurements)
//                            .task {
//                                await viewModel.getMyMeasurements()
//                            }
//                            .onAppear(perform: {
//                                Task{
//                                    await viewModel.getMyMeasurements()
//                                }
//                            })
                        
                        VipPackagesSection(packages: viewModel.featuredPackages?.items,selectedPackage: $selectedPackage){packageId in
//                            add to wishlist
                            // Update the source-of-truth array in viewModel
                             if let index = viewModel.featuredPackages?.items?.firstIndex(where: { $0.id == packageId }) {
                                 viewModel.featuredPackages?.items?[index].isWishlist?.toggle()
                             }
                            
                            Task{
                                await wishlistviewModel.addOrRemovePackageToWishList(packageId: packageId)
                            }
                        }
//                        .environmentObject(wishlistviewModel)
//                        .task {
//                            await viewModel.getFeaturedPackages()
//
//                        }
//                        .onAppear(perform: {
//                            Task{
//                                await viewModel.getFeaturedPackages()
//                            }
//                        })
                        
                        Image(.adsbg2)
                            .resizable()
                            .frame(height: 229)
                            .padding(.horizontal)
                        
                        MostViewedBooked(selectedPackage: $selectedPackage){packageId in
                            //                            add to wishlist
                        }
                            .environmentObject(viewModel)
//                            .onAppear(perform: {
//                                Task{
//                                    await viewModel.getFeaturedPackages()
//                                }
//                            })
//                            .task {
//                                await viewModel.getFeaturedPackages()
//                            }
                    }
                    
                    Spacer()
                    
                    Spacer().frame(height: 77)
                    
                }
                //                .padding(.horizontal)
            }
            .reversLocalizeView()
            .showHud(isShowing:  $viewModel.isLoading)
            .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)

            .onAppear{
                selectedPackage = nil
            }
//            .task {
//                await viewModel.refresh()
//            }
            .task(id: selectedPackage){
                guard let selectedPackage = selectedPackage else { return }
                pushTo(destination: PackageDetailsView(package: selectedPackage))
            }
            .refreshable {
                await viewModel.refresh()
            }
            .onDisappear {
                refreshTask?.cancel()
            }
        
        NavigationLink( "", destination: destination, isActive: $isactive)
        
    }
    
}

#Preview {
    //    NewHomeView()
    NewTabView()
}

struct TitleBar: View {
    @Environment(\.dismiss) private var dismiss
    
    var title: String = ""
    var titlecolor: Color? 
    var hasbackBtn:Bool = false
    var onBack: (() -> Void)? = nil  // << Add this

    var rightImage: Image?
    var rightBtnAction: (() -> Void)?
    
    var body: some View {
        HStack {
            // Left Button
            if hasbackBtn {
                Button(action:{
                    if let onBack = onBack {
                                           onBack()
                                       } else {
                                           dismiss()
                                       }
                }) {
                    Image(.backLeft)
                        .resizable()
                        .flipsForRightToLeftLayoutDirection(true)

                    //                        .foregroundStyle(Color.mainBlue)
                    
                }
                .frame(width: 31,height: 31)
            } else {
                Spacer().frame(width: 31) // Reserve space if needed
            }
            
            // Title
            Text(title.localized)
                .font(.bold(size: 18))
                .foregroundStyle(titlecolor ?? .mainBlue)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Right Button
            if let rightImage {
                Button(action: rightBtnAction ?? {}) {
                    rightImage
                        .resizable()
                    //                        .foregroundStyle(Color.mainBlue)
                }
                .frame(width: 31,height: 31)
                
            } else {
                Spacer().frame(width: 31) // Reserve space if needed
            }
        }
        .padding(.horizontal)
//        .reversLocalizeView()
    }
}


/// A View in which content reflects all behind it
struct BackdropView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect()
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
    
}

/// A transparent View that blurs its background
struct BlurView: View {
    
    let radius: CGFloat
    
    @ViewBuilder
    var body: some View {
        BackdropView()
        //            .blur(radius: radius)
            .blur(radius: radius, opaque: true)
    }
}

struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack{
                HStack{
                    Image(.logo)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                    
                    (Text("home_Welcome".localized)
                        .font(.medium(size: 24))

                     + Text(" \("بلال")"))
                        .font(.bold(size: 24))
                        .foregroundStyle(Color.mainBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack{
                    Text("home_subtitle1".localized)
                        .font(.semiBold(size: 18))
                        .foregroundStyle(Color.mainBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("home_subtitle2".localized)
                        .font(.medium(size: 14))
                        .foregroundStyle(Color(.secondaryMain))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical,4)
                }
                .padding(.vertical)
            }
            
            Image(.sehatylogobg)
        }
    }
}

struct SectionHeader: View {
    var image: Image?
    var imageForground: Color?
    var title: String = ""
    var subTitle: (any View)?

    var hasMoreBtn: Bool = true
    var MoreBtnimage: ImageResource? = .newmoreicon
    var MoreBtnAction: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            if let image = image{
                image
                    .renderingMode(imageForground != nil ? .template:.original)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .scaledToFill()
                    .foregroundStyle(imageForground ?? .white)
            }
            VStack{
                Text(title.localized)
                    .font(.bold(size: 22))
                    .foregroundStyle(Color(.mainBlue))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical,4)
                
                if let subTitle = subTitle {
                    AnyView(subTitle)
                }
            }
            if let image = MoreBtnimage{
                Button(action: MoreBtnAction ?? {}){
                    
//                    Image(MoreBtnimage ?? .newmoreicon)
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 18, height: 18)
                }
            }
        }
    }
}
#Preview{
    SectionHeader( title: "welcome",MoreBtnimage: .newfilter)
}

struct NextSessionSection: View {
    var upcomingSession: UpcomingSessionM?
    var canJoin = true
    
    var body: some View {
        VStack{
            SectionHeader(image: Image(.newnxtsessionicon),title: "home_nextSession"){
                //                            go to last mes package
            }
            
            ZStack(alignment: .bottomTrailing){
                HStack {
                    Image(.nextsessionbg)
                    Spacer()
                }.padding(8)
                
                VStack{
                    HStack{
                        VStack{
                            // Title
                            Text("pack_name".localized)
                                .font(.semiBold(size: 14))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom,1)
                            // Title
                            Text(upcomingSession?.packageName ?? "")
                                .font(.medium(size: 10))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer()
                        
                        HStack(alignment:.top) {
                            
                            VStack(){
                                // Title
                                Text(upcomingSession?.sessionDate ?? "")
                                    .font(.regular(size: 12))
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.bottom,1)
                                
                                // Title
                                Text("03:15 PM")
                                    .font(.regular(size: 12))
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            Image(.newcal)
                                .resizable()
                                .frame(width: 15, height: 15)
                        }
                    }
                    Spacer()
                    
                    HStack{
                        VStack{
                            // Title
                            Text("Doctor".localized)
                                .font(.regular(size: 12))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom,1)
                            // Title
                            Text(upcomingSession?.doctorName ?? "")
                                .font(.semiBold(size: 16))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer()
                        
                        if canJoin{
                            Button(action: {
                                
                            }){
                                HStack(alignment: .center){
                                    Image(.newjoinicon)
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    
                                    Text("Join_now".localized)
                                        .font(.bold(size: 12))
                                        .foregroundStyle(Color(.secondary))
                                    
                                }
                                .padding(.horizontal,13)
                                .frame(height: 30)
                                //                                            .padding(.vertical,15)
                                .background{Color(.white)}
                                .cardStyle( cornerRadius: 3)
                            }
                        }else{
                            HStack(alignment:.top,spacing:3) {
                                VStack(){
                                    // Title
                                    Text("2")
                                        .font(.medium(size: 14))
                                        .foregroundStyle(Color.white)
                                        .frame(width: 31, height: 31)
                                        .background{Color(.secondaryMain)}
                                        .cardStyle( cornerRadius: 3)
                                    
                                    // Title
                                    Text("Days".localized)
                                        .font(.regular(size: 8))
                                        .foregroundStyle(Color.white)
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                }
                                
                                Text(":")
                                    .font(.regular(size: 12))
                                    .foregroundStyle(Color.white)
                                    .offset(y:10)
                                
                                VStack(){
                                    // Title
                                    Text("11")
                                        .font(.medium(size: 14))
                                        .foregroundStyle(Color.white)
                                        .frame(width: 31, height: 31)
                                        .background{Color(.secondaryMain)}
                                        .cardStyle( cornerRadius: 3)
                                    
                                    // Title
                                    Text("Hours".localized)
                                        .font(.regular(size: 8))
                                        .foregroundStyle(Color.white)
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                }
                                
                                Text(":")
                                    .font(.regular(size: 12))
                                    .foregroundStyle(Color.white)
                                    .offset(y:10)
                                
                                VStack(){
                                    // Title
                                    Text("31")
                                        .font(.medium(size: 14))
                                        .foregroundStyle(Color.white)
                                        .frame(width: 31, height: 31)
                                        .background{Color(.secondaryMain)}
                                        .cardStyle( cornerRadius: 3)
                                    
                                    // Title
                                    Text("Minutes".localized)
                                        .font(.regular(size: 8))
                                        .foregroundStyle(Color.white)
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                }
                            }
                        }
                        Spacer()
                        
                    }
                    
                    Spacer()
                    
                    HStack(alignment:.bottom,spacing:3) {
                        
                        Button(action: {
                            
                        }){
                            HStack(alignment: .center){
                                Image( .newmoreicon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(Color.white)
                                
                                Text("more_detail".localized)
                                    .font(.bold(size: 12))
                                    .foregroundStyle(Color.white)
                            }
                            //                                        .padding(.horizontal,30)
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                            .background{Color(.secondaryMain)}
                            .cardStyle( cornerRadius: 3)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            
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
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
//            .background(Color.mainBlue)
            .horizontalGradientBackground()
            .cardStyle(cornerRadius: 4,shadowOpacity: 0.4)
            .padding(.bottom,5)
            
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
        
    }
}

struct MainCategoriesSection: View {
    var categories: HomeCategoryM?
    var action: ((HomeCategoryItemM) -> Void)?
    
    var body: some View {
        VStack(spacing:5){
            SectionHeader(image: Image(.newcategicon),title: "home_maincat"){
                //                            go to last mes package
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal,showsIndicators:false){
                HStack(spacing:12){
                    let categories = categories?.items ?? []
                    
                    ForEach(categories, id: \.self) { item in
                        Button(action: {
                            action?(item)
                        }, label: {
                            ZStack(alignment: .bottom){
                                //                                Image(.onboarding2)
                                //                                    .resizable()
                                //                                    .frame(width: 166, height: 221)
                                
//                                KFImageLoader(url:URL(string:Constants.imagesURL + (item.homeImage?.validateSlashs() ?? "")),placeholder: Image("logo"),placeholderSize: CGSize(width: 166, height: 221), shouldRefetch: true)
                                KFImageLoader(url:URL(string:Constants.imagesURL + (item.homeImage?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)

                                    .frame(width: 166, height: 221)
                                
                                VStack(alignment: .leading){
                                    Text(item.title ?? "")
                                        .font(.semiBold(size: 18))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    HStack{
                                        HStack(spacing:2){
                                            Image(.newsubmaincaticon)
                                                .resizable()
                                                .frame(width: 9,height:9)
                                                .scaledToFit()
                                            
                                            ( Text(" \(item.subCategoryCount ?? 0) ") + Text("sub_category".localized))
                                                .font(.medium(size: 12))
                                            
                                        }
                                        .foregroundStyle(Color.white)
                                        
                                        Spacer()
                                        
                                        HStack(spacing:2){
                                            
                                            Image("newvippackicon")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 8,height:9)
                                                .scaledToFit()
                                                .foregroundStyle(.white)
                                            
                                            ( Text(" \(item.packageCount ?? 0) ") + Text("package_".localized))
                                                .font(.medium(size: 12))
                                        }
                                        .foregroundStyle(Color.white)
                                    }
                                }
                                .padding([.vertical,.horizontal],10)
                                .background{
                                    BlurView(radius: 5)
                                        .horizontalGradientBackground().opacity(0.89)
                                }
                            }
                        })
                        .buttonStyle(.plain)
                        .cardStyle(cornerRadius: 3)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical,5)
            }
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
    }
}

struct LastMesurmentsSection: View {
    var measurements : [MyMeasurementsStatsM]?
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
//        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack{
            SectionHeader(image: Image(.newlastmesicon),title: "home_lastMes"){
                //                            go to last mes package
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(measurements ?? [], id: \.self) { item in
                    VStack{
                        Text(item.title ?? "")
                            .font(.bold(size: 16))
                            .foregroundStyle(Color.mainBlue)
                            .frame(maxWidth: .infinity)
                        
                        //                        Image(.sugarMeasurement1)
                        //                            .resizable()
                        //                            .frame(width: 30, height: 30)
                        //                            .aspectRatio(contentMode: .fit)
                        
                        KFImageLoader(url:URL(string:Constants.imagesURL + (item.image?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                            .frame(width: 30, height: 30)
                        
                        Text(item.lastMeasurementValue ?? "")
                            .font(.bold(size: 16))
                            .foregroundStyle(Color(.secondaryMain))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,0)
                        
                        let date = (item.lastMeasurementDate ?? "").ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd MMM yyyy")
                        
//                        (Text("mes_inDate".localized).font(.semiBold(size: 6))
//                         +
                         Text( date )
//                        Text("27/6/2022" )

//                        )
                        .font(.medium(size: 10))
                        .foregroundStyle(Color.mainBlue)
                        .frame(maxWidth: .infinity)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width/3.3, height: 112)
                    .cardStyle(cornerRadius: 3,shadowOpacity:0.08)
                }
            }
            .padding(.horizontal)
            .padding(.vertical,5)
            
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
    }
}

struct VipPackagesSection: View {
    var packages: [FeaturedPackageItemM]?
      @Binding var selectedPackage : FeaturedPackageItemM?

//    var action : ((FeaturedPackageItemM) -> Void)?
    var likeAction : ((Int) -> Void)?
//    @EnvironmentObject var wishlistviewModel: WishListManagerViewModel

    var body: some View {
        VStack{
            SectionHeader(image: Image(.newvippackicon),title: "home_vippackages"){
                //                            go to last mes package
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal,showsIndicators:false){
                HStack{
                    ForEach(packages ?? [], id: \.self) { item in
                        VipPackageCellView(item: item,action:{
                            selectedPackage = item
                        },likeAction:{
                            //                            likeAction?(item.id ?? 0)
                            guard let packageId = item.appCountryPackageId else { return }
//                            Task{
//                                await wishlistviewModel.addOrRemovePackageToWishList(packageId: packageId)
                                likeAction?(packageId)
//                            }

                        })
                    }
                }
                .padding(.horizontal)
                .padding(.vertical,5)
                
            }
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
    }
}


//#Preview(body: {
//    MostViewedBooked( selectedPackage: .constant(nil))
//})

struct VipPackageCellView: View {
    var item : FeaturedPackageItemM
    var action : (() -> Void)?
    var likeAction : (() -> Void)?
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            ZStack(alignment: .bottom){
                //                                Image(.onboarding1)
                //                                    .resizable()
                //                                    .aspectRatio(contentMode: .fill)
                //                                //                                    .frame(width: 166, height: 221)
                //                                    .frame(width: 200, height: 356)
                
                KFImageLoader(url:URL(string:Constants.imagesURL + (item.homeImage?.validateSlashs() ?? "")),placeholder: Image("logo"),placeholderSize: CGSize(width: 200, height: 356), shouldRefetch: true)
                    .frame(width: 200, height: 356)
                
                VStack {
                    HStack(alignment:.top){
                        // Title
                        HStack (spacing:3){
                            Image(.newconversationicon)
                                .resizable()
                                .frame(width: 16, height: 8)
                            
                            Text("\(item.sessionCount ?? 0) ").font(.semiBold(size: 18))
                            
                            Text("sessions".localized)
                                .font(.regular(size: 12))

                        }
                        .foregroundStyle(Color.white)
                        .frame(height:32)
                        .padding(.horizontal,10)
                        .background{Color(.secondaryMain)}
                        .cardStyle( cornerRadius: 3)
                        
                        Spacer()
                        Button(action: {
                            likeAction?()
                        }, label: {
                            Image( item.isWishlist ?? false ? .newlikeicon : .newunlikeicon)
                                .resizable()
                                .frame(width: 20, height: 20)
                        })
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity,alignment:.leading)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5),.clear]), startPoint: .top, endPoint: .bottom)
                    )
                    
                    Spacer()
                    
                    VStack(alignment: .leading,spacing: 10){
                        Text(item.name ?? "pack_Name".localized)
                            .font(.semiBold(size: 20))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity,alignment:.leading)
                        
//                        HStack(alignment: .center,spacing: 5){
                        VStack{
                            Text( item.categoryName ?? "")
                            Text( item.mainCategoryName ?? "")

//                            Circle().fill(Color(.white))
//                                .frame(width: 4, height: 4)
//                            Text("23 / 7 / 2023")
                        }
                        .font(.medium(size: 12))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity,alignment:.leading)
                        
                        Text("\(item.priceAfterDiscount ?? 0) " + "EGP".localized)
                            .font(.semiBold(size: 16))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity,alignment:.leading)
                        
                        HStack{
                            Text("\(item.priceBeforeDiscount ?? 0) " + "EGP".localized).strikethrough().foregroundStyle(Color(.secondary))
                                .font(.medium(size: 12))
                            
                            (Text("(".localized + "Discount".localized ) + Text( " \(item.discount ?? 0)" + "%".localized + ")".localized))
                                .font(.semiBold(size: 12))
                                .foregroundStyle(Color.white)
                        }
                        .frame(maxWidth: .infinity,alignment:.leading)
                        
                    }
                    .padding(.top,5)
                    .padding([.bottom,.horizontal],10)
                    .background{
                        BlurView(radius: 5)
                            .horizontalGradientBackground().opacity(0.89)
                    }
                }
            }
            
        })
        .cardStyle(cornerRadius: 3)
        .frame(width: 200, height: 356)
    }
}

//#Preview {
//    VipPackageCellView(item: .init())
//}

struct MostViewedBooked: View {
    @EnvironmentObject var viewModel : NewHomeViewModel
    
    private enum mostcases {
        case mostviewed
        case mostbooked
    }
    @State private var currentcase:mostcases = .mostviewed
    @State var packaces: [FeaturedPackageItemM]?
    @Binding var selectedPackage : FeaturedPackageItemM?
    var likeAction : ((Int) -> Void)?

    var body: some View {
        
        HStack{
            HStack(alignment:.top, spacing:20){
                Button(action: {
                    currentcase = .mostbooked
                    getFeaturedPackages()
                }){
                    VStack {
                        Text("Most_Booked".localized)
                            .foregroundStyle(currentcase == .mostbooked ? Color(.secondary) : Color(.btnDisabledTxt))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .fixedSize() // Prevents layout issues after rotation
                        Circle().fill(currentcase == .mostbooked ? Color(.secondary) : .clear)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Button(action: {
                    currentcase = .mostviewed
                    getFeaturedPackages()
                }){
                    VStack {
                        Text("Most_Viewed".localized)
                            .foregroundStyle(currentcase == .mostviewed ? Color(.secondary) : Color(.btnDisabledTxt))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .fixedSize() // Prevents layout issues after rotation
                        
                        Circle().fill(currentcase == .mostviewed ? Color(.secondary) : .clear)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .rotationEffect(.degrees(-90))
            .frame(width: 30)
            .font(.bold(size: 22))
            .padding(.leading)
            
            ScrollView(.horizontal,showsIndicators:false){
                HStack{
                    ForEach(packaces ?? [], id: \.self) { item in
                        VipPackageCellView(item: item,action:{
                            selectedPackage = item
                        },likeAction:{
                            likeAction?(item.id ?? 0)})
                    }
                }
                .padding(.horizontal)
                .padding(.vertical,5)
                
            }
        }
        .frame(height:356)
        .padding(.vertical,10)
        .padding(.bottom,5)
//        .task {
//            getFeaturedPackages()
//        }
    }
    func getFeaturedPackages() {
        Task() {
            switch currentcase {
            case .mostviewed:
                await viewModel.getMostBookedOrViewedPackages(forcase: .MostViewed)
            case .mostbooked:
                await viewModel.getMostBookedOrViewedPackages(forcase: .MostBooked)
            }
            packaces = currentcase == .mostbooked ? viewModel.mostBookedPackages : viewModel.mostViewedPackages
        }
    }
}
