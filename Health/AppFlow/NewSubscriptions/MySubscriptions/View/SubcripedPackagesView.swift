//
//  SubcripedPackagesView.swift
//  Sehaty
//
//  Created by mohamed hammam on 26/05/2025.
//

import SwiftUI

struct SubcripedPackagesView: View {
    //    var mainCategory:HomeCategoryItemM
    @StateObject private var viewModel = SubcripedPackagesViewModel.shared
    var onBack: (() -> Void)? // for uikit dismissal
    
    @State var showCancel: Bool = false

    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    
    init(onBack: (() -> Void)?) {
        self.onBack = onBack
    }
    
    var body: some View {
        //        NavigationView(){
        VStack(spacing:0){
            VStack(){
                TitleBar(title: "subscriped_title",titlecolor: .white,hasbackBtn: true,onBack: onBack)
                    .padding(.top,55)
                
                VStack(spacing:5){
                    
                    KFImageLoader(url:URL(string:Constants.imagesURL + ("imagepath".validateSlashs() ?? "")),placeholder: Image(.onboarding1), shouldRefetch: true)
                        .clipShape(Circle())
                        .background(Circle()
                            .stroke(.white, lineWidth: 5).padding(-2))
                        .frame(width: 91,height:91)
                    //                        if let name = Helper.shared.getUser()?.name{
                    Text(Helper.shared.getUser()?.name ?? "user name")
                        .font(.semiBold(size: 14))
                        .foregroundStyle(Color.white)
                    //                        }
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
            
            SubcripedPackagesListView(packaces: viewModel.subscripedPackages?.items,selectAction: {package in
                pushTo(destination: SubcripedPackageDetailsView(package: package))
            },buttonAction:{item in
                if item.canRenew ?? false{
                    // renew subscription
                    guard let doctorPackageId = item.customerPackageID else { return }
                    pushTo(destination: PackageMoreDetailsView( doctorPackageId: doctorPackageId,currentcase:.renew))
                }else if item.canCancel ?? false{
                    // sheet for cancel subscription
                    showCancel = true
                }
            },loadMore: {
//                guard viewModel.canLoadMore else { return }
                
                Task {
                    await viewModel.loadMoreIfNeeded()
                }
                
            })
            .refreshable {
                await viewModel.refresh()
            }
            
//            Spacer().frame(height: 55)
            
        }
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
        .edgesIgnoringSafeArea([.top,.horizontal])
        .task {
            await viewModel.getSubscripedPackages()
        }
        NavigationLink( "", destination: destination, isActive: $isactive)
        
        if showCancel{
            CancelSubscriptionView().onDisappear(perform: {
                showCancel = false
                print("cancelled dismiss")
            })
        }

        
    }
}

#Preview {
    SubcripedPackagesView(onBack: {})
}

struct SubcripedPackagesListView: View {
    var packaces: [SubcripedPackageItemM]?
    var selectAction: ((SubcripedPackageItemM) -> Void)?
    var buttonAction: ((SubcripedPackageItemM) -> Void)?
    var loadMore: (() -> Void)?

    var body: some View {
        VStack(spacing:0){
            SectionHeader(image: Image(.newvippackicon),title: "subscriped_packages"){
                //                            go to last mes package
            }
            .padding([.horizontal,.top])
            
            //            ScrollView(.horizontal,showsIndicators:false){
            GeometryReader { gr in
                List{
                    
                    if let packages = packaces,packages.count > 0{
                        
                        ForEach(packages, id: \.self) { item in
                            Button(action: {
                                selectAction?(item)
                            }, label: {
                                ZStack(alignment: .bottom){
                                    KFImageLoader(url:URL(string:Constants.imagesURL + (item.packageImage?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                                        .frame( height: 180)
                                    
                                    VStack {
                                        HStack(alignment:.top){
                                            
                                            Image("dateicon 1")
                                                .resizable()
                                                .frame(width: 11, height: 11)
                                            VStack(alignment:.leading){
                                                (Text("subscription_Date".localized) + Text("  \(item.subscriptionDate ?? "2025-03-31")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd"))
                                                    .font(.regular(size: 10)))
                                                .font(.semiBold(size: 10))
                                                .foregroundStyle(Color.white)
                                                .frame(maxWidth:.infinity, alignment: .leading)
                                                
                                                (Text("last_session_Date".localized) + Text("  \(item.lastSessionDate ?? "2025-03-31")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd"))
                                                    .font(.regular(size: 10)))
                                                .font(.medium(size: 8))
                                                .foregroundStyle(Color.white)
                                            }
                                            
                                            
                                            // Title
                                            HStack (spacing:3){
                                                Circle()
                                                //                                                    .fill(Color(.white))
                                                    .frame(width: 5, height: 5)
                                                
                                                Text(item.status ?? "Active")
                                            }
                                            .font(.medium(size: 10))
                                            .foregroundStyle(Color.white)
                                            .frame(height:22)
                                            .padding(.horizontal,10)
                                            .background{Color(item.canCancel ?? false ? .active:.notActive)}
                                            .cardStyle( cornerRadius: 3)
                                        }
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                        .padding(8)
                                        .background{
                                            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5),.clear]), startPoint: .top, endPoint: .bottom)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(spacing:8){
                                            HStack{
                                                VStack{
                                                    Text(item.packageName ?? "pack_Name".localized)
                                                        .font(.semiBold(size: 16))
                                                        .foregroundStyle(Color.white)
                                                        .frame(maxWidth: .infinity,alignment:.leading)
                                                    
                                                    HStack{
                                                        Text(item.mainCategoryName ?? "main_category")
                                                        Circle()
                                                            .fill(Color(.secondary))
                                                            .frame(width: 5, height: 5)
                                                        
                                                        Text(item.categoryName ?? "sub_category")
                                                        
                                                    }
                                                    .font(.regular(size: 10))
                                                    .foregroundStyle(Color.white)
                                                    .frame(maxWidth: .infinity,alignment:.leading)
                                                    
                                                }
                                                
                                                HStack(alignment:.center,spacing:0){
                                                    Text( "remain_".localized)
                                                    
                                                    let reamin = (item.sessionCount ?? 0) - (item.attendedSessionCount ?? 0)
                                                    
                                                    (Text(" \(reamin) " + "from".localized + " \(item.sessionCount ?? 0) "))
                                                        .font(.bold(size: 12))
                                                    
                                                    Text( "sessions_ar".localized )
                                                }
                                                .font(.regular(size: 10))
                                                .minimumScaleFactor(0.5)
                                                .foregroundStyle(Color(.secondary))
                                                .padding(8)
                                                .cardStyle(backgroundColor: .white,cornerRadius: 3)
                                            }
                                            
                                            HStack{
                                                HStack(alignment: .center,spacing: 5){
                                                    Image(.newdocicon)
                                                        .renderingMode(.template)
                                                        .resizable()
                                                        .frame(width: 10,height:12)
                                                        .scaledToFit()
                                                        .foregroundStyle(Color(.secondary))
                                                        .padding(3)
                                                    
                                                    ( Text("doc".localized + " / ".localized) + Text(item.doctorName ?? "Doctor Name"))
                                                        .font(.semiBold(size: 12))
                                                        .frame(maxWidth: .infinity,alignment:.leading)
                                                    
                                                    Button(action: {
                                                        selectAction?(item)
                                                        
                                                        //                                                            if item.canRenew ?? false{
                                                        //
                                                        //                                                            }else if item.canCancel ?? false{
                                                        //
                                                        //                                                            }
                                                        
                                                    },label:{
                                                        HStack(spacing:3){
                                                            Image(item.canRenew ?? false ? "newreschedual" : "cancelsubscription")
                                                                .resizable()
                                                                .frame(width: 10, height: 8.5)
                                                            Text(item.canRenew ?? false ? "renew_subscription".localized: "cancel_subscription".localized)
                                                                .underline()
                                                        }
                                                        .foregroundStyle(Color.white)
                                                        .font(.regular(size: 10))
                                                        
                                                    })
                                                    .buttonStyle(.plain)
                                                    
                                                }
                                                .font(.regular(size: 10))
                                                .foregroundStyle(Color.white)
                                                //                                            .frame(maxWidth: .infinity,alignment:.leading)
                                            }
                                            
                                        }
                                        .padding(.horizontal,8)
                                        .padding(.vertical,2)
                                        .background{
                                            BlurView(radius: 5)
                                                .horizontalGradientBackground().opacity(0.89)
                                        }
                                    }
                                }
                            })
                            .buttonStyle(.plain)
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)

                            .cardStyle(cornerRadius: 3)
                            //                        .frame(width: 200, height: 356)
//                            .padding(.horizontal)
                            .padding(.top,8)
                            .onAppear {
                                // Detect when the last item appears
                                guard item == packages.last else {return}

//                                if item == packages.last {
                                    loadMore?()
//                                    Task {
//                                        
//                                        await viewModel.loadMoreIfNeeded()
//                                    }
//                                }
                            }
                        }
                        //                        .padding(.horizontal,10)
                        //                        .padding(.top,5)
                        
                    }else{
                        VStack{
                            Image(.nosubscription)
                                .resizable()
                                .frame(width: 162, height: 162)
                            
                            Text("subscriped_no_packages".localized)
                                .font(.semiBold(size: 22))
                                .foregroundStyle(Color(.btnDisabledTxt))
                                .padding()
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                                .lineSpacing(12)
                        }
                        .frame(width: gr.size.width,height:gr.size.height)
                        
                    }
                }
                .listStyle(.plain)

            }
        }
        
    }
}



struct HorizontalGradientBackground: ViewModifier {
    var colors: [Color] = [.mainBlue, Color(.secondary)]
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .reversLocalizeView()
    }
}
extension View {
    func horizontalGradientBackground(colors: [Color] = [.mainBlue, Color(.secondary)]) -> some View {
        self.modifier(HorizontalGradientBackground(colors: colors))
    }
}





struct ErrorAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String?
    let title: String?

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text(title?.localized ?? ""),
                    message: Text(message?.localized ?? ""),
                    dismissButton: .default(Text("OK".localized))
                )
            }
    }
}

extension View {
    func errorAlert(isPresented: Binding<Bool>, message: String? , title: String? = nil) -> some View {
        self.modifier(ErrorAlertModifier(isPresented: isPresented, message: message, title: title))
    }
}
