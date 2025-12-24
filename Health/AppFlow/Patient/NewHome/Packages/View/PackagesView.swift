//
//  PackagesView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/05/2025.
//

import SwiftUI

struct PackagesView: View {
    var mainCategory:HomeCategoryItemM
    @StateObject private var viewModel = PackagesViewModel()
//    @StateObject var wishlistviewModel: WishListManagerViewModel = WishListManagerViewModel.shared

    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    private func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    
    init(mainCategory:HomeCategoryItemM) {
        self.mainCategory = mainCategory
    }
    
    // Scroll anchor for jumping to top of packages on subcategory change
    private let packagesTopAnchor = "packagesTopAnchor"
    
    var body: some View {
        VStack(spacing:0){
            VStack(){
                TitleBar(title: "",hasbackBtn: true)
                    .padding(.top,50)
                
                Spacer()
                
                HStack{
                    VStack(alignment:.leading,spacing: 3){
                        Text(mainCategory.title ?? "")
                            .font(.semiBold(size: 22))
                            .foregroundStyle(.white)
                        
                        HStack(spacing:0){
                            Image(.newsubmaincaticon)
                                .resizable()
                                .frame(width: 11,height:11)
                                .scaledToFit()
                            
                            (Text(" \(mainCategory.subCategoryCount ?? 0) ") + Text("sub_category".localized))
                                .font(.medium(size: 18))
                        }
                        .foregroundStyle(Color.white)
                    }
                    Spacer()
                    
                    VStack(){
                        Image("newvippackicon")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 13,height:15)
                            .scaledToFit()
                            .foregroundStyle(.white)
                        
                        ( Text(" \(mainCategory.packageCount ?? 0) ") + Text("package_".localized))
                            .font(.medium(size: 18))
                    }
                    .foregroundStyle(Color.white)
                }
                .padding(10)
                .background{
                    BlurView(radius: 5)
                        .horizontalGradientBackground( reverse: Helper.shared.getLanguage().localized == "ar").opacity(0.89)
                }
            }
            .frame(height: 195)
            .background{
                KFImageLoader(url:URL(string:Constants.imagesURL + (mainCategory.imagePath?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                    .frame( height: 195)
            }
            
            ScrollViewReader { proxy in
                // Single vertical scroll; internal lists use Lazy* stacks
                ScrollView(showsIndicators: false){
                    VStack(alignment:.leading){
                        
                        // Subcategories
                        if viewModel.isLoadingSubcategories && (viewModel.subCategories?.items?.isEmpty ?? true) {
                            // Simple skeleton chips
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(0..<5, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.white.opacity(0.15))
                                            .frame(width: 140, height: 60)
                                            .redacted(reason: .placeholder)
                                    }
                                }
                            }
                            .padding(.vertical,5)
                            .padding(.bottom,5)
                        } else {
                            SubCategoriesSection(
                                categories: viewModel.subCategories,
                                selectedSubCategory: $viewModel.selectedSubCategory
                            ){ subCategoryId in
                                // Update selection; loading is driven by .task(id:)
                                if let selected = viewModel.subCategories?.items?.first(where: { $0.id == subCategoryId }) {
                                    withAnimation(.easeInOut) {
                                        viewModel.selectedSubCategory = selected
                                    }
                                }
                            } loadMore :{
                                Task {
                                    guard let mainCategoryId = self.mainCategory.id else { return }

                                    await viewModel.loadMoreSubcategoriesIfNeeded(mainCategoryId: mainCategoryId)
                                }
                            }
                        }
                        
                        // Anchor to scroll back to when subcategory changes
                        Color.clear.frame(height: 0).id(packagesTopAnchor)
                        
                        // Packages states
                        Group {
                            if viewModel.isLoadingPackages && (viewModel.packages?.items?.isEmpty ?? true) {
                                // Grid-like skeletons
                                LazyVStack(spacing: 12) {
                                    ForEach(0..<3, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.white.opacity(0.15))
                                            .frame(height: 180)
                                            .redacted(reason: .placeholder)
                                            .cardStyle(cornerRadius: 3,shadowOpacity:0.28)
                                    }
                                }
                                .padding(.vertical,5)
                                .padding(.bottom,5)
                            } else if let items = viewModel.packages?.items, !items.isEmpty {
                                PackagesListView(
                                    packaces: items,
                                    inFlightWishlist: viewModel.inFlightWishlist,
                                    isLoadingMore: viewModel.isLoadingMore,
                                    action: { package in
                                        guard Helper.shared.getSelectedUserType() != .Doctor else { return }
                                        pushTo(destination: PackageDetailsView(package: package))
                                    },
                                    likeAction: { packageId in
                                        Task {
                                            await viewModel.toggleWishlist(for: packageId)
                                        }
                                    },
                                    onItemAppear: { item in
                                        Task {
                                            await viewModel.loadMorePAckagesIfNeeded(currentItem: item)
                                        }
                                    }
                                )
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                            } else {
                                // Old empty design: show nothing (global error alert still handles errors)
                                EmptyView()
                            }
                        }
                    }
                    .padding([.horizontal,.top],10)
                    
                    Spacer().frame(height: 55)
                }
                .refreshable {
                    if let mainCategoryId = self.mainCategory.id {
                        await viewModel.refresh(mainCategoryId: mainCategoryId)
                    }
                }
                // Scroll to top of packages when switching subcategory
                .onChange(of: viewModel.selectedSubCategory?.id) { _ in
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(packagesTopAnchor, anchor: .bottom)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea([.top,.horizontal])
        .localizeView()
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
        .task {
            // Initial load
            guard let mainCategoryId = self.mainCategory.id else { return }
            await viewModel.loadInitial(mainCategoryId: mainCategoryId)
        }
        .task(id: viewModel.selectedSubCategory?.id) {
            // Auto-load packages when selection changes
            guard let subId = viewModel.selectedSubCategory?.id else { return }
            await viewModel.getPackages(categoryId: subId, reset: true)
        }
        
        NavigationLink( "", destination: destination, isActive: $isactive)
        
    }
}

#Preview {
    PackagesView(mainCategory: .init())
}

struct SubCategoriesSection: View {
    var categories: SubCategoriesM?
    @Binding var selectedSubCategory : SubCategoryItemM?
    var action: ((Int) -> Void)?
    let loadMore: (() -> Void)?

    var body: some View {
        VStack(spacing:5){
            SectionHeader(image: Image(.newcategicon),title: "pack_subcat"){
                // go to last mes package
            }
            
            ScrollView(.horizontal,showsIndicators:false){
                HStack(spacing:12){
                    let categories = categories?.items ?? []
                    
                    ForEach(categories, id: \.self) { item in
                        Button(action: {
                            selectedSubCategory = item
                            guard let id = item.id else { return }
                            action?(id)
                        }, label: {
                            HStack(spacing:0){
                                KFImageLoader(url:URL(string:Constants.imagesURL + (item.image?.validateSlashs() ?? "")),placeholder: Image("logo"),placeholderSize: CGSize(width: 48, height: 38), shouldRefetch: true)
                                    .frame(width: 48, height: 38)
                                
                                VStack(alignment: .leading){
                                    Text(item.name ?? "")
                                        .font(.semiBold(size: 14))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    Spacer()
                                    
                                    HStack{
                                        HStack(spacing:0){
                                            
                                            Image("newvippackicon")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 8,height:9)
                                                .scaledToFit()
                                                .foregroundStyle(.white)
                                            
                                            ( Text(" \(item.packageCount ?? 0) ") + Text("package_".localized))
                                                .font(.medium(size: 10))
                                                .frame(maxWidth: .infinity,alignment:.leading)
                                            
                                            Image(systemName: "chevron.forward")
                                                .foregroundStyle(Color.white)
                                                .padding(4)
                                                .font(.system(size: 8))
                                                .background(Color.white.opacity(0.2).cornerRadius(1))
                                        }
                                        .foregroundStyle(Color.white)
                                    }
                                    .padding(.leading,4)
                                }
                                .padding(.vertical,5)
                            }
                            .padding([.vertical,.horizontal],5)
                            .frame(width: 140, height: 60)
                            .background{
                                item == selectedSubCategory ? LinearGradient(gradient: Gradient(colors: [.mainBlue, Color(.secondary)]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color(.btnDisabledTxt).opacity(0.5), Color(.btnDisabledTxt).opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
                            }
                            .animation(.easeInOut(duration: 0.2), value: selectedSubCategory)
                            
                        })
                        .cardStyle(cornerRadius: 6)
                        .onAppear {
                            if item == categories.last {
                                loadMore?()
                            }
                        }
                        
                    }
                }
            }
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
        
    }
}


struct PackagesListView: View {
    var packaces: [FeaturedPackageItemM]?
    var inFlightWishlist: Set<Int> = []
    var isLoadingMore: Bool = false
    var action: ((FeaturedPackageItemM) -> Void)?
    var likeAction : ((Int) -> Void)?
    var onItemAppear: ((FeaturedPackageItemM) -> Void)?

    var body: some View {
        VStack{
            LazyVStack(spacing: 12) {
                ForEach(packaces ?? [], id: \.self){ item in
                    Button(action: {
                        action?(item)
                    }, label: {
                        ZStack(alignment: .bottom){
                            KFImageLoader(url:URL(string:Constants.imagesURL + (item.imagePath?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                                .frame( height: 180)
                            
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
                                    Button(action: {
                                        likeAction?(item.appCountryPackageId ?? 0)
                                    }, label: {
                                        Image( item.isWishlist ?? false ? .newlikeicon : .newunlikeicon)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    })
                                    .disabled(inFlightWishlist.contains(item.appCountryPackageId ?? -1))
                                    
                                }
                                .frame(maxWidth: .infinity,alignment:.leading)
                                .padding(10)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .clear]), startPoint: .top, endPoint: .bottom)
                                )
                                
                                Spacer()
                                
                                VStack {
                                    Text(item.name ?? "pack_Name".localized)
                                        .font(.bold(size: 22))
                                        .foregroundStyle(Color.white)
                                    
                                    HStack(alignment: .bottom){
                                        
                                        if Helper.shared.getSelectedUserType() != .Doctor{
                                            VStack(alignment:.leading) {
                                                
                                                HStack(alignment: .center,spacing: 5){
                                                    Image(.newdocicon)
                                                        .renderingMode(.template)
                                                        .resizable()
                                                        .frame(width: 8,height:9)
                                                        .scaledToFit()
                                                        .foregroundStyle(.white)
                                                        .padding(3)
                                                        .background(Color(.secondary))
                                                    
                                                    ( Text(" \(item.doctorCount ?? 0) ") + Text("available_doc".localized))
                                                        .font(.medium(size: 12))
                                                        .frame(maxWidth: .infinity,alignment:.leading)
                                                }
                                                .font(.medium(size: 12))
                                                .foregroundStyle(Color.white)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing){
                                            (Text(item.priceAfterDiscount ?? 0,format:.number.precision(.fractionLength(1))) + Text(" "+"EGP".localized))
                                                .font(.semiBold(size: 16))
                                                .foregroundStyle(Color.white)
                                            
                                            HStack{
                                                (Text(item.priceBeforeDiscount ?? 0,format:.number.precision(.fractionLength(1))) + Text(" "+"EGP".localized))
                                                    .strikethrough()
                                                    .foregroundStyle(Color(.secondary))
                                                    .font(.semiBold(size: 12))
                                                
                                                DiscountLine(discount: item.discount)
                                            }
                                            .padding(.top,2)
                                        }
                                    }
                                }
                                .padding(.top,5)
                                .padding([.bottom,.horizontal],10)
                                .background{
                                    BlurView(radius: 5)
                                        .horizontalGradientBackground( reverse: Helper.shared.getLanguage().localized == "ar").opacity(0.89)
                                }
                            }
                        }
                    })
                    .cardStyle(cornerRadius: 3)
//                    .horizontalGradientBackground()
                    .onAppear {
                        onItemAppear?(item)
                    }
                }
                .buttonStyle(.plain)
                
                // Pagination footer
                if isLoadingMore {
                    HStack {
                        ProgressView()
                            .tint(.white)
                        Text("loading_more".localized)
                            .foregroundStyle(.white)
                            .font(.medium(size: 14))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
            .cardStyle(cornerRadius: 3,shadowOpacity:0.28)
            .padding(.vertical,5)
            .padding(.bottom,5)
        }
    }
}
