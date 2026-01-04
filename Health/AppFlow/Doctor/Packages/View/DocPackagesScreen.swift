//
//  DocPackagesScreen.swift
//  Sehaty
//
//  Created by mohamed hammam on 24/08/2025.
//


import SwiftUI

struct DocPackagesScreen: View {
    @StateObject var router: NavigationRouter = NavigationRouter()
    @StateObject private var viewModel = DocPackagesViewModel.shared
    //    @StateObject private var lookupsVM = LookupsViewModel.shared
    
    @State private var packages: [String] = ["okkkkkk","done"] // Empty initially
//    @State private var showFilter: Bool = false
    var hasbackBtn:Bool?
    
    var docpacks = [SubcripedPackageItemM(customerPackageID: 2, docotrID: 2, status: "active", subscriptionDate: "", lastSessionDate: "", packageName: "nameeee", categoryName: "cateeee", mainCategoryName: "main cateee", doctorName: "doc doc", sessionCount: 4, attendedSessionCount: 2, packageImage: "", doctorSpeciality: "special", doctorNationality: "egegege", doctorImage: "", canCancel: true, canRenew: true )]
    
    var body: some View {
        VStack {
            TitleBar(title: "doc_packages", hasbackBtn: hasbackBtn ?? true)
            
            if packages.isEmpty {
                Spacer()
                VStack(spacing: 20) {
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
                DocPackagesListView(
                    packages: viewModel.ActivePackages?.items,
                    isLoading: viewModel.isLoading ?? false,
                    canLoadMore: viewModel.canLoadMore ?? false,
                    action: { package in
                        // push to details if needed
//                        guard let customerPackageId = package. else { return }  //customerPackageId not exist
//                        pushTo(destination: ActiveCustomerPackagesView( doctorId: nextsession.doctorId,CustomerPackageId: customerPackageId))
                    },
                    loadMore: {
                        Task {
                            await viewModel.loadMoreIfNeeded()
                        }
                    }
                )
                .padding()
                .refreshable {
                    await viewModel.refresh()
                }
            }
            
            CustomButton(title: "doc_package_request",isdisabled: false,backgroundView:AnyView(Color.clear.horizontalGradientBackground())){
                viewModel.showAddSheet.toggle()
                Task{
                    async let main: () = viewModel.getMainCategories()
                    _ = await (main)
                }
            }
            
        }
        .localizeView()
        .withNavigation(router: router)
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil && !viewModel.showAddSheet },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
        .padding(.bottom,hasbackBtn == true ? 0 : 88)
        .sheet(isPresented: $viewModel.showAddSheet) {
            DocPackagesFilterView(viewmodel: viewModel)
        }
        .task {
            await viewModel.getActivePackages()
        }
//        .onChange(of: viewModel.showSuccess){ newval in
//            guard newval else { return }
//            RequestSent()
//        }
        
    }
    
//    func RequestSent() {
//            let successView = SuccessView(
//                image: Image("successicon"),
//                title: "docPackReq_title".localized,
//                subtitle1: "docPackReq_subtitle1".localized,
//                subtitle2: "docPackReq_subtitle2".localized,
//                buttonTitle: "docPackReq_btn".localized,
//                buttonAction: {
//                    // Navigate to home or login
//                    let root = UIHostingController(rootView: DocTabView())
//                    Helper.shared.changeRootVC(newroot: root, transitionFrom: .fromLeft)
//                }
//            )
//            let newVC = UIHostingController(rootView: successView)
//            Helper.shared.changeRootVC(newroot: newVC, transitionFrom: .fromLeft)
//            
//    }
}
#Preview {
    DocPackagesScreen()
}

struct DocPackagesFilterView: View {
    @State private var mainCategory: String = ""
    @State private var subCategory: String = ""
    @State private var package: String = ""
    @ObservedObject var viewmodel: DocPackagesViewModel
//    @StateObject private var lookupsVM = LookupsViewModel.shared

    // Bottom sheet controls and temp selections
    @State private var showMainCatSheet = false
    @State private var showSubCatSheet = false
    @State private var showPackageSheet = false
    @State private var showCountriesSheet = false

    @State private var tempMainCategory: CategoriyListItemM?
    @State private var tempSubCategory: CategoriyListItemM?
    @State private var tempPackage: SpecialityM?
    @State private var tempCountry: AppCountryByPackIdM? // used only for single add in countries list
    
    var body: some View {
        VStack(spacing: 20) {
            TitleBar(title: "doc_packages", hasbackBtn: true)
            
            VStack(spacing: 16) {
                SectionHeader(image: Image(.newreschedual),imageForground: Color(.secondary),title: "Package_selection".localized,subTitle:
                                Text("Package_selection_Hint".localized)
                    .foregroundStyle(Color(.secondary))
                    .font(.medium(size: 12))
                    .frame(maxWidth:.infinity,alignment: .leading), MoreBtnimage: nil
                ){
                }
                .padding()
                
                // Main Category - open sheet
                CustomDropListInputFieldUI(
                    title: "MainCategory_title",
                    placeholder: "MainCategory_placeholder",
                    text: .constant(viewmodel.selectedMainCategory?.title ?? ""),
                    isDisabled: true,
                    showDropdownIndicator: true,
                    trailingView: AnyView(
                        Image("maincaticon")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(Color(.secondary))
                            .frame(width: 14,height: 14)
                    )
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    tempMainCategory = viewmodel.selectedMainCategory
                    showMainCatSheet = true
                }
                
                // Sub Category - open sheet
                CustomDropListInputFieldUI(
                    title: "SubCategory_title",
                    placeholder: "SubCategory_placeholder",
                    text: .constant(viewmodel.selectedSubCategory?.title ?? ""),
                    isDisabled: true,
                    showDropdownIndicator: true,
                    trailingView: AnyView(
                        Image("subcaticon")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(Color(.secondary))
                            .frame(width: 14,height: 14)
                    )
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    tempSubCategory = viewmodel.selectedSubCategory
                    showSubCatSheet = true
                }
                
                // Package - open sheet
                CustomDropListInputFieldUI(
                    title: "Package_title",
                    placeholder: "Package_placeholder",
                    text: .constant(viewmodel.SelectedPackage?.name ?? ""),
                    isDisabled: true,
                    showDropdownIndicator: true,
                    trailingView: AnyView(
                        Image("newvippackicon")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(Color(.secondary))
                            .frame(width: 14,height: 14)
                    )
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    tempPackage = viewmodel.SelectedPackage
                    showPackageSheet = true
                }
                
                // MARK: Multi-select Countries
                VStack(spacing: 8) {
                    // Open countries sheet (allows tap to add/remove)
                    CustomDropListInputFieldUI(
                        title: "lang_Country_title",
                        placeholder: viewmodel.selectedCountries.isEmpty ? "lang_Country_subitle" : "lang_Country_title",
                        text: .constant( selectedCountriesTitle(viewmodel.selectedCountries) ),
                        isDisabled: true,
                        showDropdownIndicator: true
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showCountriesSheet = true
                    }

                    // Selected chips
                    if !viewmodel.selectedCountries.isEmpty {
//                        FlowLayout(alignment: .leading, spacing: 8) {
                            ForEach(viewmodel.selectedCountries, id: \.self) { country in
                                HStack(spacing: 6) {
                                    Text(country.name ?? "")
                                        .font(.medium(size: 14))
                                        .foregroundStyle(Color(.main))
                                    Button {
                                        // Remove selection
                                        viewmodel.selectedCountries.removeAll { $0.id == country.id }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundStyle(Color(.secondary))
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(.mainBlue), lineWidth: 1)
                                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                                )
                            }
//                        }
                        .padding(.top, 4)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                CustomButton(title: "new_send_btn",backgroundcolor: Color(.mainBlue)){
                    Task{await viewmodel.CreatePackageRequest()}
                }
                CustomButton(title: "remove_all_btn",backgroundView : AnyView(Color(.secondary))){
                    viewmodel.removeSelections()
                }
            }
        }
        .localizeView()
        .padding()
        .onDisappear{
            viewmodel.removeSelections()
        }
        .fullScreenCover(isPresented: $viewmodel.showSuccess, onDismiss: {}, content: {
            AnyView( DocPackageRequestSuccessView() )
        })
        .errorAlert(isPresented: Binding(
            get: { viewmodel.errorMessage != nil  },
            set: { if !$0 { viewmodel.errorMessage = nil } }
        ), message: viewmodel.errorMessage)

        // MARK: Sheets
        .customSheet(isPresented: $showMainCatSheet, height: 300) {
            BottomListSheet(
                title: "MainCategory_title".localized,
                selection: Binding<CategoriyListItemM?>(
                    get: { tempMainCategory },
                    set: { tempMainCategory = $0 }
                ),
                data: viewmodel.MainCategories ?? [],
                rowHeight: 55
            ) { item, isSelected in
                HStack {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(.secondaryMain))
                    }
                    Text(item.title ?? "")
                        .font(.semiBold(size: 16))
                        .foregroundStyle(isSelected ? Color(.mainBlue) : Color(.main))
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 55)
                .contentShape(Rectangle())
            } onTapRow: { tapped in
                tempMainCategory = tapped
            } onDone: {
                guard let picked = tempMainCategory else { showMainCatSheet = false; return }
                viewmodel.selectedMainCategory = picked
                viewmodel.selectedSubCategory = nil
                viewmodel.PackagesList = nil
                viewmodel.SelectedPackage = nil
                viewmodel.selectedCountry = nil
                viewmodel.selectedCountries.removeAll()
                showMainCatSheet = false
                Task { await viewmodel.getSubCategories() }
            } onCancel: {
                showMainCatSheet = false
            }
        }
        .customSheet(isPresented: $showSubCatSheet, height: 300) {
            BottomListSheet(
                title: "SubCategory_title".localized,
                selection: Binding<CategoriyListItemM?>(
                    get: { tempSubCategory },
                    set: { tempSubCategory = $0 }
                ),
                data: viewmodel.SubCategories ?? [],
                rowHeight: 55
            ) { item, isSelected in
                HStack {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(.secondaryMain))
                    }
                    Text(item.title ?? "")
                        .font(.semiBold(size: 16))
                        .foregroundStyle(isSelected ? Color(.mainBlue) : Color(.main))
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 55)
                .contentShape(Rectangle())
            } onTapRow: { tapped in
                tempSubCategory = tapped
            } onDone: {
                guard let picked = tempSubCategory else { showSubCatSheet = false; return }
                viewmodel.selectedSubCategory = picked
                viewmodel.PackagesList = nil
                viewmodel.SelectedPackage = nil
                viewmodel.selectedCountry = nil
                viewmodel.selectedCountries.removeAll()
                showSubCatSheet = false
                Task { await viewmodel.getPackagesList() }
            } onCancel: {
                showSubCatSheet = false
            }
        }
        .customSheet(isPresented: $showPackageSheet, height: 300) {
            BottomListSheet(
                title: "Package_title".localized,
                selection: Binding<SpecialityM?>(
                    get: { tempPackage },
                    set: { tempPackage = $0 }
                ),
                data: viewmodel.PackagesList ?? [],
                rowHeight: 60
            ) { item, isSelected in
                HStack {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(.secondaryMain))
                    }
                    Text(item.name ?? "")
                        .font(.semiBold(size: 16))
                        .foregroundStyle(isSelected ? Color(.mainBlue) : Color(.main))
                    Spacer()
//                    KFImageLoader(url: URL(string: Constants.imagesURL + (item.packageIamge?.validateSlashs() ?? "")), placeholder: Image("logo"), shouldRefetch: true)
//                        .frame(width: 50, height: 30)
                }
                .padding(.horizontal)
                .frame(height: 60)
                .contentShape(Rectangle())
            } onTapRow: { tapped in
                tempPackage = tapped
            } onDone: {
                guard let picked = tempPackage else { showPackageSheet = false; return }
                viewmodel.SelectedPackage = picked
                viewmodel.selectedCountry = nil
                viewmodel.selectedCountries.removeAll()
                showPackageSheet = false
                Task { await viewmodel.getCountryByPackageId() }
            } onCancel: {
                showPackageSheet = false
            }
        }
        .customSheet(isPresented: $showCountriesSheet, height: 350) {
            BottomListSheet(
                title: "lang_Country_title".localized,
                selection: Binding<AppCountryByPackIdM?>(
                    get: { tempCountry },
                    set: { tempCountry = $0 }
                ),
                data: viewmodel.CountriesList ?? [],
                rowHeight: 50
            ) { country, isSelected in
                let selected = viewmodel.selectedCountries.contains(where: { $0.id == country.id })
                HStack {
                    if selected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(.secondaryMain))
                    }
                    Text(country.name ?? "")
                        .font(.semiBold(size: 16))
                        .foregroundStyle(selected ? Color(.mainBlue) : Color(.main))
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 50)
                .contentShape(Rectangle())
            } onTapRow: { tapped in
                // Toggle in temp via committing directly to viewmodel list (multi-select)
                if let id = tapped.id,
                   let idx = viewmodel.selectedCountries.firstIndex(where: { $0.id == id }) {
                    viewmodel.selectedCountries.remove(at: idx)
                } else {
                    viewmodel.selectedCountries.append(tapped)
                }
            } onDone: {
                showCountriesSheet = false
            } onCancel: {
                showCountriesSheet = false
            }
        }
    }

    private func selectedCountriesTitle(_ countries: [AppCountryByPackIdM]) -> String {
        let names = countries.compactMap { $0.name }
        if names.isEmpty { return "" }
        // Show first 2 and count if many
        if names.count <= 2 { return names.joined(separator: ", ") }
        let prefix = names.prefix(2).joined(separator: ", ")
        return "\(prefix) +\(names.count - 2)"
    }
}

extension DocPackagesFilterView{
    private func DocPackageRequestSuccessView()->any View {
        let successView = SuccessView(
            image: Image("successicon"),
            title: "Package_success_title".localized,
            subtitle1: "Package_success_subtitle1".localized,
            subtitle2: "Package_success_subtitle2".localized,
            buttonTitle: "inbody_success_created_btn".localized,
            buttonAction: {
                viewmodel.showSuccess = false
            }
        )
        return successView
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
    var packages: [DocPackageItemM]?
    var isLoading: Bool
    var canLoadMore: Bool
    var action: ((DocPackageItemM) -> Void)?
    var loadMore: (() -> Void)?
    
    init(packages: [DocPackageItemM]?, isLoading: Bool, canLoadMore: Bool, action: ((DocPackageItemM) -> Void)? = nil, loadMore: (() -> Void)? = nil) {
        self.packages = packages
        self.isLoading = isLoading
        self.canLoadMore = canLoadMore
        self.action = action
        self.loadMore = loadMore
    }
    
    var body: some View {
        VStack{
            SectionHeader(image: Image(.newvippackicon),title: "doc_your_packages",MoreBtnimage: nil){
            }
            
            ScrollView{
                LazyVStack(spacing: 8) {
                    ForEach(packages ?? [], id: \.self){ item in
                        Button(action: {
                            action?(item)
                        }, label: {
                            ZStack(alignment: .bottom){
                                KFImageLoader(url:URL(string:Constants.imagesURL + (item.packageIamge?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                                    .frame( height: 180)
                                
                                VStack {
                                    HStack(alignment:.top){
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
                                    }
                                    .frame(maxWidth: .infinity,alignment:.leading)
                                    .padding(10)
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5),.clear]), startPoint: .top, endPoint: .bottom)
                                    )
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text(item.packageName ?? "pack_Name".localized)
                                            .font(.bold(size: 22))
                                            .foregroundStyle(Color.white)
                                        
                                        HStack(alignment: .bottom){
                                            VStack(alignment:.leading) {
                                                HStack(alignment: .center,spacing: 5){
                                                    ( Text(" \(item.participantCount ?? 0) ") + Text("subscribtions_".localized))
                                                        .font(.medium(size: 12))
                                                    Image(.greenPerson)
                                                        .resizable()
                                                        .frame(width: 12,height:12)
                                                        .scaledToFit()
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
                                                    (Text(item.price ?? 0,format:.number.precision(.fractionLength(1))) + Text(" "+"EGP".localized)).strikethrough().foregroundStyle(Color(.secondary))
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
                                            .horizontalGradientBackground( reverse: true).opacity(0.89)
                                    }
                                }
                            }
                        })
                        .cardStyle(cornerRadius: 3)
                        .horizontalGradientBackground()
                        .onAppear {
                            // Trigger only when last item becomes visible and we are allowed to load
                            guard item == packages?.last else { return }
                            guard canLoadMore, !isLoading else { return }
                            loadMore?()
                        }
                    }
                    
                    if isLoading && canLoadMore {
                        ProgressView()
                            .padding(.vertical, 12)
                    }
                }
                .padding(.vertical,5)
                .padding(.bottom,5)
            }
        }
    }
}


