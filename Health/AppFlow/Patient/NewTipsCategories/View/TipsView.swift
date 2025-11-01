//
//  TipsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/07/2025.
//


import SwiftUI

// MARK: - Sample Data
     let sampleCategories = [
        TipsAllItem(title: "مرض السكري", order: 1, id: 1, image: "diabetes", subjectsCount: 15),
        TipsAllItem(title: "ضغط الدم", order: 2, id: 2, image: "blood_pressure", subjectsCount: 22),
        TipsAllItem(title: "أمراض القلب", order: 3, id: 3, image: "heart_disease", subjectsCount: 18),
        TipsAllItem(title: "مرض السكري", order: 4, id: 4, image: "diabetes2", subjectsCount: 12)
    ]
    
     let sampleRecentTips = [
        TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 2, drugGroupIDS: [21], id: 5, image: "", tipCategoryTitle: "مرض السكري", views: 3) ,
        TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 1, drugGroupIDS: [2], id: 1, image: "", tipCategoryTitle: "مرض السكري", views: 5)
    ]


// MARK: - Main View
struct TipsView: View {
    @StateObject var viewModel = TipsViewModel.shared
    @StateObject var router = NavigationRouter()

    @State private var searchText = ""
    
    var body: some View {
        VStack {

            TitleBar(title: "profile_tips",hasbackBtn: true)

            ScrollView {
                VStack(spacing: 20) {
                    
                    // Search Bar
//                    searchBar
                    
                    // Categories Section
                    categoriesSection
                    
                    // Recent Tips Section
                    recentTipsSection
                    
                    // Your Tips Section
                    yourTipsSection
                    
                    // Most Viewed Tips Section
                    mostViewedSection
                }
                .environmentObject(viewModel)
//                .padding(.horizontal, 16)
            }
            .padding(.top)
            .background(Color(.bgPink))
//            .navigationBarHidden(true)
        }
        .task {
//            viewModel.allTips = nil
            await viewModel.refresh()
        }
        .refreshable {
            await viewModel.refresh()
        }
        .localizeView()
        .withNavigation(router: router)
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("البحث...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Categories Section
    private var categoriesSection: some View {
        VStack(alignment: .trailing, spacing: 0) {
            if let categories = viewModel.allTips?.items , categories.count > 0 {
            
            SectionHeader(image: Image("tipscaticon"), title: "tips_adv", trailingView: AnyView(
                Button(action: {
                    router.push(TipsByCategoryView(TipsCategoriesCase: .All).environmentObject(viewModel))
                }, label: {
                    Image("newmoredots")
                })
            ))
            .padding(.horizontal, 20)
            .padding(.bottom, -8)
            
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 2), count: 1), spacing: 2) {
                        ForEach(categories.indices, id: \.self) { index in
                            CategoryCardView(item: categories[index]){
//                                MARK: -- action ---
                                router.push( TipsCategoriesListView(category:categories[index])
                                    .environmentObject(TipDetailsViewModel.shared) )
                            }
                                .onAppear {
                                    // Load more when reaching near the end
                                    if index >= categories.count - 2 && !(viewModel.isLoadingMore ?? false) {
                                        loadMoreCategories()
                                    }
                                }
                        }
                        // Loading indicator
                        if viewModel.isLoadingMore ?? false {
                            ProgressView()
                                .frame(width: 120, height: 80)
                                .scaleEffect(0.8)
                        }
                    }
                    .padding(.leading, 4)
                }
                .padding(.leading, 4)
            }
        }
    }
    
    // MARK: - Recent Tips Section
       private var recentTipsSection: some View {
           VStack(alignment: .trailing, spacing: 12) {
               if let recentTips = viewModel.newestTipsArr, recentTips.count > 0 {
                   SectionHeader(image: Image("newadvicon"), title: "tips_newest", trailingView: AnyView(
                Button(action: {
                    router.push(TipsByCategoryView(TipsCategoriesCase: .Newest).environmentObject(viewModel))
                }, label: {
                    Image("newmoredots")
                })
               ))
               .padding(.horizontal, 20)
               .padding(.vertical,-8)
               
                   ScrollView(.horizontal, showsIndicators: false) {
                       LazyHStack(spacing: 12) {
                           ForEach(recentTips, id: \.self) { tip in
                               RecentTipCardView(item: tip){
                                   //                                MARK: -- action ---
                                   router.push(TipDetailsView(tipId: tip.id ?? 0).environmentObject(TipDetailsViewModel.shared))
                               }
                           }
                       }
                       .padding(.leading, 4)
                   }
                   
                   .padding(.leading, 4)
               }
           }
       }
    
    // MARK: - Your Tips Section
    private var yourTipsSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            if let interestingTips = viewModel.interestingTipsArr, interestingTips.count > 0{
            SectionHeader(image: Image("interestuicon") , title: "tips_interesting",trailingView:AnyView(
                Button(action: {
                    router.push(TipsByCategoryView(TipsCategoriesCase: .Interesting).environmentObject(viewModel))
                }, label: {
                    Image("newmoredots")
                })
            ))
            .padding(.horizontal, 20)
            .padding(.vertical,-8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(interestingTips, id: \.self) { tip in
                        RecentTipCardView(item: tip){
                            //                                MARK: -- action ---
                            router.push(TipDetailsView(tipId: tip.id ?? 0).environmentObject(TipDetailsViewModel.shared))
                        }
                    }
                }
                .padding(.leading, 4)
            }
            .padding(.leading, 4)
        }
        }
    }
    
    // MARK: - Most Viewed Section
    private var mostViewedSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            if let mostViewedTips = viewModel.mostViewedTipsArr,mostViewedTips.count > 0{
            SectionHeader(image: Image("mostviewedicon") , title: "tips_mostviewed",trailingView:AnyView(
                Button(action: {
                    router.push(TipsByCategoryView(TipsCategoriesCase: .MostViewed).environmentObject(viewModel))
                }, label: {
                    Image("newmoredots")
                })
            ))
            .padding(.horizontal, 20)
            .padding(.vertical,-8)

                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack(spacing: 12) {
                        ForEach(mostViewedTips, id: \.self) { tip in
                            RecentTipCardView(item: tip){
                                //                                MARK: -- action ---
                                router.push(TipDetailsView(tipId: tip.id ?? 0).environmentObject(TipDetailsViewModel.shared))
                            }
                        }
                    }
                    .padding(.leading, 4)
                }
                .padding(.leading, 4)
            }
        }
    }
}

// MARK: - Category Card View
struct CategoryCardView: View {
    let item: TipsAllItem
    var action: (() -> Void)?

    var body: some View {
        Button(action: {
            action?()
        },label:  {
            VStack(spacing: 8) {
                if let imageName = item.image {
                    KFImageLoader(url:URL(string:Constants.imagesURL + (imageName.validateSlashs())),placeholder: Image("sehatylogobg"), isOpenable: false,shouldRefetch: false)
                    //                            .resizable()
                    //                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cardStyle(cornerRadius: 3)
                }
                
                Text(item.title ?? "")
                    .font(.bold(size: 12) )
                    .foregroundStyle(Color(.main))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(4)
            .padding(.vertical,8)
        })
    }
}

// MARK: - Recent Tip Card View
struct RecentTipCardView: View {
    let item: TipsNewestM
    var action: (() -> Void)?
    var body: some View {
        Button(action:{
            action?()
        },label:  {
            ZStack(alignment: .bottom){
                if let imageName = item.image {
                    KFImageLoader(url:URL(string:Constants.imagesURL + (imageName.validateSlashs())),placeholder: Image("onboarding2"), isOpenable: false,shouldRefetch: false)
                    //                            .resizable()
                    //                        .clipShape(Circle())
                    //                .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 153)
                    //                .cardStyle(cornerRadius: 3)
                        .cardStyle(cornerRadius: 6,shadowOpacity: 0.189)
                    
                }
                
                VStack{
                    HStack (spacing: 4){
                        Text(item.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd/MM/yyyy") ?? "")
                            .font(.regular(size: 8))
                        
                        Circle().fill(Color(.white))
                            .frame(width: 4, height: 4)
                        
                        Text(item.tipCategoryTitle ?? "")
                            .font(.regular(size: 10))
                    }
                    
                    Text(item.title ?? "")
                        .font(.bold(size: 14))
                        .multilineTextAlignment(.leading)
                    
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity,alignment: .leading)
                
                .padding( 5)
                //            .padding(.horizontal, 5)
            }
            .frame(width: 180, height: 153)
            .padding(.bottom)
        })

    }
}

// MARK: - Preview
struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
    }
}


extension TipsView{
    
    // MARK: - Load More Categories
    private func loadMoreCategories() {
        Task {
            await viewModel.loadMoreIfNeeded()
        }
    }
    
    // MARK: - Load More Recent Tips
//    private func loadMoreRecentTips() {
//        guard !isLoadingMoreRecent else { return }
//        
//        isLoadingMoreRecent = true
//        
//        // Simulate API call
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            let newTips = [
//            TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 10, drugGroupIDS: [2], id: 1, image: "", tipCategoryTitle: "مرض السكري", views: 5),
//            TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 11, drugGroupIDS: [2], id: 1, image: "", tipCategoryTitle: "مرض السكري", views: 5),
//            TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 12, drugGroupIDS: [2], id: 1, image: "", tipCategoryTitle: "مرض السكري", views: 5)
//            ]
//            
//            recentTips.append(contentsOf: newTips)
//            isLoadingMoreRecent = false
//        }
//    }
    
    // MARK: - Load More Your Tips
//    private func loadMoreYourTips() {
//        guard !isLoadingMoreYours else { return }
//        
//        isLoadingMoreYours = true
//        
//        // Simulate API call
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            let newTips = [
//                TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 10, drugGroupIDS: [2], id: 1, image: "", tipCategoryTitle: "مرض السكري", views: 5),
//                TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 11, drugGroupIDS: [2], id: 1, image: "", tipCategoryTitle: "مرض السكري", views: 5),
//                TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 12, drugGroupIDS: [2], id: 1, image: "", tipCategoryTitle: "مرض السكري", views: 5)
//                ]
//            
//            yourTips.append(contentsOf: newTips)
//            isLoadingMoreYours = false
//        }
//    }
    
    // MARK: - Load More Most Viewed Tips
//    private func loadMoreMostViewedTips() {
//        guard !isLoadingMoreMostViewed else { return }
//        
//        isLoadingMoreMostViewed = true
//        
//        // Simulate API call
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            let newTips = [
//                TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 10, drugGroupIDS: [2], id: 1, image: "", tipCategoryTitle: "مرض السكري", views: 5),
//                TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 11, drugGroupIDS: [2], id: 1, image: "", tipCategoryTitle: "مرض السكري", views: 5),
//                TipsNewestM(title: "10 نصائح للتحسين صحة الكبد", description: "10 نصائح للتحسين صحة الكبد", date: "2024-01-01T17:00:00", tipCategoryID: 12, drugGroupIDS: [2], id: 1, image: "", tipCategoryTitle: "مرض السكري", views: 5)
//                ]
//            
//            mostViewedTips.append(contentsOf: newTips)
//            isLoadingMoreMostViewed = false
//        }
//    }
}

