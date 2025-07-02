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
    
    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    
    init(mainCategory:HomeCategoryItemM) {
        self.mainCategory = mainCategory
    }
    
    var body: some View {
        //        NavigationView(){
        VStack(spacing:0){
            VStack(){
                TitleBar(title: "",hasbackBtn: true)
                    .padding(.top,50)
                
                Spacer()
                
                HStack{
                    VStack(alignment:.leading){
                        Text(mainCategory.title ?? "main category")
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
                        .horizontalGradientBackground().opacity(0.89)
                }
            }
            .frame(height: 195)
            .background{
                KFImageLoader(url:URL(string:Constants.imagesURL + (mainCategory.imagePath?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                    .frame( height: 195)
                //                    Image(.adsbg2)
                //                        .resizable()
            }
            
            ScrollView(showsIndicators: false){
                VStack(alignment:.leading){
                    SubCategoriesSection(categories:viewModel.subCategories,selectedSubCategory:$viewModel.selectedSubCategory){subCategoryId in
                        Task{
                            await viewModel.getPackages(categoryId: subCategoryId)
                        }
                    }
                    .task {
                        guard let mainCategoryId = self.mainCategory.id else { return }
                        await viewModel.getSubCategories(mainCategoryId: mainCategoryId)
                        //                                await viewModel.getPackages(categoryId: mainCategoryId)
                        viewModel.selectedSubCategory = viewModel.subCategories?.items?.first
                        
                        guard let subCategory =  viewModel.selectedSubCategory ,let subCategoryId = subCategory.id else { return }
                        
                        await viewModel.getPackages(categoryId: subCategoryId)
                        
                    }
                    
                    PackagesListView(packaces: viewModel.packages?.items){package in
                        pushTo(destination: PackageDetailsView(package: package))
                    }
                    //                        .task {
                    //                            guard let subCategoryId = viewModel.subCategories?.items?.first?.id else { return }
                    //                            await viewModel.getPackages(categoryId: subCategoryId)
                    //                        }
                    
                }
                .padding([.horizontal,.top],10)
                
                //                    Spacer()
                
                Spacer().frame(height: 55)
            }
        }
        .edgesIgnoringSafeArea([.top,.horizontal])
        //            .reversLocalizeView()
        .localizeView()
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
        
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
    var body: some View {
        VStack(spacing:5){
            SectionHeader(image: Image(.newcategicon),title: "pack_subcat"){
                //                            go to last mes package
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
                            //                            ZStack(){
                            //                                Image(.onboarding2)
                            //                                    .resizable()
                            //                                    .frame(width: 166, height: 221)
                            
                            HStack(spacing:0){
                                
                                //                                    Image(.packsubcat)
                                //                                        .resizable()
                                //                                        .frame(width: 48, height: 38)
                                
                                KFImageLoader(url:URL(string:Constants.imagesURL + (item.image?.validateSlashs() ?? "")),placeholder: Image("logo"),placeholderSize: CGSize(width: 48, height: 38), shouldRefetch: true)
                                    .frame(width: 48, height: 38)
                                
                                VStack(alignment: .leading){
                                    Text(item.name ?? "")
                                        .font(.semiBold(size: 14))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    //                                            .minimumScaleFactor(0.5)
                                    
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
                                            
                                            //                                                Spacer()
                                            
                                            //                                                Button(action:{
                                            //                                                }) {
                                            
                                            Image(systemName: "chevron.forward")
                                                .foregroundStyle(Color.white)
                                                .padding(4)
                                                .font(.system(size: 8))
                                                .background(Color.white.opacity(0.2).cornerRadius(1))
                                            //                                                }
                                        }
                                        .foregroundStyle(Color.white)
                                    }
                                    .padding(.leading,4)
                                }
                                .padding(.vertical,5)
                            }
                            .padding([.vertical,.horizontal],5)
                            //                                .padding(.horizontal,5)
                            
                            //                                    .padding(.horizontal,5)
                            
                            .frame(width: 140, height: 60)
                            .background{
                                
                                item == selectedSubCategory ? LinearGradient(gradient: Gradient(colors: [.mainBlue, Color(.secondary)]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color(.btnDisabledTxt).opacity(0.5), Color(.btnDisabledTxt).opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
                            }
                            
                        })
                        .cardStyle(cornerRadius: 6)
                        
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
    var action: ((FeaturedPackageItemM) -> Void)?
    
    var body: some View {
        VStack{
            
            //            SectionHeader(image: Image(.newvippackicon),title: "pack_packages"){
            //                //                            go to last mes package
            //            }
            
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
                                    Button(action: {
                                        
                                    }, label: {
                                        Image(.newlikeicon)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        
                                    })
                                    
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
                                                Image(.newdocicon)
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .frame(width: 8,height:9)
                                                    .scaledToFit()
                                                    .foregroundStyle(.white)
                                                    .padding(3)
                                                    .background(Color(.secondary))
                                                
                                                ( Text(" \(item.doctorCount ?? 0) ") + Text("avilable_doc".localized))
                                                    .font(.regular(size: 10))
                                                    .frame(maxWidth: .infinity,alignment:.leading)
                                            }
                                            .font(.medium(size: 12))
                                            .foregroundStyle(Color.white)
                                            //                                            .frame(maxWidth: .infinity,alignment:.leading)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing){
                                            Text("\(item.priceAfterDiscount ?? 0) " + "EGP".localized)
                                                .font(.semiBold(size: 16))
                                                .foregroundStyle(Color.white)
                                            
                                            HStack{
                                                Text("\(item.priceBeforeDiscount ?? 0) " + "EGP".localized).strikethrough().foregroundStyle(Color(.secondary))
                                                    .font(.semiBold(size: 12))
                                                
                                                (Text("(".localized + "Discount".localized ) + Text( " \(item.discount ?? 0)" + "%".localized + ")".localized))
                                                    .font(.semiBold(size: 12))
                                                    .foregroundStyle(Color.white)
                                            }
                                            .padding(.top,2)
                                        }
                                        
                                    }
                                }
                                .padding(.top,5)
                                .padding([.bottom,.horizontal],10)
                                .background{
                                    BlurView(radius: 5)
                                        .horizontalGradientBackground(reverse: true).opacity(0.89)
                                    //                                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                                }
                                
                            }
                        }
                        
                    })
                    .cardStyle(cornerRadius: 3)
                    .horizontalGradientBackground()
                    //                        .frame(width: 200, height: 356)
                }
                .buttonStyle(.plain)
                //                    .listRowSpacing(0)
                //                    .listRowSeparator(.hidden)
                //                    .listRowBackground(Color.clear)
                
            }
            //            .listStyle(.plain)
            
            .cardStyle(cornerRadius: 3,shadowOpacity:0.28)
            .padding(.vertical,5)
            .padding(.bottom,5)
        }
        
    }
}

