//
//  DocPackagesScreen.swift
//  Sehaty
//
//  Created by mohamed hammam on 24/08/2025.
//


import SwiftUI

struct DocPackagesScreen: View {
    @StateObject private var viewModel = DocPackagesViewModel.shared

    @State private var packages: [String] = ["okkkkkk","done"] // Empty initially
    @State private var showFilter: Bool = false
    var hasbackBtn:Bool?
    
    var docpacks = [SubcripedPackageItemM(customerPackageID: 2, docotrID: 2, status: "active", subscriptionDate: "", lastSessionDate: "", packageName: "nameeee", categoryName: "cateeee", mainCategoryName: "main cateee", doctorName: "doc doc", sessionCount: 4, attendedSessionCount: 2, packageImage: "", doctorSpeciality: "special", doctorNationality: "egegege", doctorImage: "", canCancel: true, canRenew: true )]
    
//    var appointments: [AppointmentsItemM]? = [AppointmentsItemM(
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
    
//    var packages1: FeaturedPackagesM? = .init(items: [FeaturedPackageItemM.init()],totalCount: 5)
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
                    DocPackagesListView(packages: viewModel.ActivePackages?.items,action: {package in
//                        pushTo(destination: PackageDetailsView(package: package))
                    },loadMore: {
                        Task {
                            await viewModel.loadMoreIfNeeded()
                        }
                    })
                    .padding()
                    .refreshable {
                        await viewModel.refresh()
                    }
                }
                
                CustomButton(title: "doc_package_request",isdisabled: false,backgroundView:AnyView(Color.clear.horizontalGradientBackground())){
                    showFilter.toggle()
                    Task{
                        async let main: () = viewModel.getMainCategories()
                        _ = await (main)
                    }
                }

            }
            .localizeView()
            //            .withNavigation(router: router)
//            .showHud(isShowing:  $viewModel.isLoading)
//            .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)

            .padding(.bottom,88)
            .sheet(isPresented: $showFilter) {
                DocPackagesFilterView(viewmodel: viewModel)
            }
            .task {
               await viewModel.getActivePackages()
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
    @ObservedObject var viewmodel: DocPackagesViewModel
    
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
                    //                            go to last mes package
                }
                .padding()
                
                Menu {
                    ForEach(viewmodel.MainCategories ?? [],id: \.id) { cat in
                        Button(action: {
                            viewmodel.selectedMainCategory = cat
                        }, label: {
                            Text(cat.title ?? "")
                                .font(.semiBold(size: 12))
                        })
                        
                    }
                } label: {
                    CustomDropListInputFieldUI(title: "MainCategory_title", placeholder: "MainCategory_placeholder",text: .constant(viewmodel.selectedMainCategory?.title ?? ""), isDisabled: true, showDropdownIndicator:true, trailingView:
                                                AnyView( Image("maincaticon")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .foregroundStyle(Color(.secondary))
                                                    .frame(width: 14,height: 14)
                                                ))
                }
                
                Menu {
                    ForEach(viewmodel.SubCategories ?? [],id: \.id) { cat in
                        Button(action: {
                            viewmodel.selectedSubCategory = cat
                        }, label: {
                            Text(cat.title ?? "")
                                .font(.semiBold(size: 12))
                        })
                        
                    }
                } label: {
                    CustomDropListInputFieldUI(title: "SubCategory_title", placeholder: "SubCategory_placeholder",text: .constant(viewmodel.selectedSubCategory?.title ?? ""), isDisabled: true, showDropdownIndicator:true, trailingView:
                                                AnyView( Image("subcaticon")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .foregroundStyle(Color(.secondary))
                                                    .frame(width: 14,height: 14)
                                                ))
                }
                
                Menu {
                    ForEach(viewmodel.PackagesList ?? [],id: \.id) { cat in
                        Button(action: {
                            viewmodel.SelectedPackage = cat

                        }, label: {
                            Text(cat.title ?? "")
                                .font(.semiBold(size: 12))
                        })
                        
                    }
                } label: {
                    CustomDropListInputFieldUI(title: "Package_title", placeholder: "Package_placeholder",text: .constant(viewmodel.SelectedPackage?.title ?? ""), isDisabled: true, showDropdownIndicator:true, trailingView:
                                                AnyView( Image("newvippackicon")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .foregroundStyle(Color(.secondary))
                                                    .frame(width: 14,height: 14)
                                                ))
                }
            }
            
            Spacer()
            
            // MARK: Footer Buttons
            HStack(spacing: 4) {
                CustomButton(title: "new_send_btn",backgroundcolor: Color(.mainBlue)){
//                    print("Selected Slots:", viewModel.selectedSlots)
//                    showDialog = true
                    Task{await viewmodel.CreatePackageRequest()}
                }
                CustomButton(title: "remove_all_btn",backgroundView : AnyView(Color(.secondary))){
                    viewmodel.removeSelections()
                }
            }
        }
        .localizeView()
        .padding()
//        .onAppear{
//            Task{
//                async let sub: () = viewmodel.getSubCategories()
//                _ = await (sub)
//            }
//        }
        .fullScreenCover(isPresented: $viewmodel.showSuccess, onDismiss: {}, content: {
           AnyView( DocPackageRequestSuccessView() )
        })
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
                // Navigate to home or login
//                let login = UIHostingController(rootView: LoginView())
//                Helper.shared.changeRootVC(newroot: login, transitionFrom: .fromLeft)
                
                viewmodel.showSuccess = false
            }
        )
//        let newVC = UIHostingController(rootView: successView)
//        Helper.shared.changeRootVC(newroot: newVC, transitionFrom: .fromLeft)
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
    var action: ((DocPackageItemM) -> Void)?
//    var likeAction : ((Int) -> Void)?
    var loadMore: (() -> Void)?

    var body: some View {
        VStack{
            
                        SectionHeader(image: Image(.newvippackicon),title: "doc_your_packages",MoreBtnimage: nil){
            //                //                            go to last mes package
                        }
            
            //            ScrollView(.horizontal,showsIndicators:false){
            
            ScrollView{
                ForEach(packages ?? [], id: \.self){ item in
                    Button(action: {
                        action?(item)
                    }, label: {
                        ZStack(alignment: .bottom){
                            KFImageLoader(url:URL(string:Constants.imagesURL + (item.packageIamge?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
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
                                    Text(item.packageName ?? "pack_Name".localized)
                                        .font(.bold(size: 22))
                                        .foregroundStyle(Color.white)
                                    //                                                .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    HStack(alignment: .bottom){
                                        VStack(alignment:.leading) {
                                            
                                            HStack(alignment: .center,spacing: 5){
                                                
                                                ( Text(" \(item.participantCount ?? 0) ") + Text("subscribtions_".localized))
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
                                                
                                               (Text(item.price ?? 0,format:.number.precision(.fractionLength(1))) + Text(" "+"EGP".localized)).strikethrough().foregroundStyle(Color(.secondary))
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
                    .onAppear {
                        if item == packages?.last {
                            loadMore?()
                        }
                    }
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



