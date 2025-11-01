//
//  TipsCategoriesListView.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/07/2025.
//

import SwiftUI

struct TipsCategoriesListView: View {
    @StateObject var router = NavigationRouter()
    @EnvironmentObject var viewModel : TipDetailsViewModel

    let category:TipsAllItem?
    var body: some View {
        VStack {

            TitleBar(title: category?.title ?? "",hasbackBtn: true)

            ScrollView {
                VStack(spacing: 20) {
                    // Categories Section
                    categoriesSection
                                     
                }
//                .padding(.horizontal, 16)
            }
            .padding(.top)
            .background(Color(.bgPink))
//            .navigationBarHidden(true)
        }
        .task {
            viewModel.tipId = category?.id 
            
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
    
    
    // MARK: - Categories Section
    private var categoriesSection: some View {
        VStack(alignment: .trailing, spacing: 0) {
            if let categories = viewModel.tipsByCategory?.items , categories.count > 0 {
            
//                ScrollView(.vertical, showsIndicators: false) {
//                    LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 2), count: 1), spacing: 2) {
                ScrollView{
                    LazyVStack{
                        ForEach(categories.indices, id: \.self) { index in
                            TipListCardView(item: categories[index]){
                                //                                MARK: --- action ---
                                router.push(TipDetailsView(tipId: categories[index].id ?? 0).environmentObject(viewModel))
                            }
                            .padding(.horizontal, 10)
                            
                            .onAppear {
                                // Load more when reaching near the end
                                if index >= categories.count - 2 && !(viewModel.isLoadingMore ?? false) {
                                    loadMoreCategories()
                                }
                            }
                        }
                        
                    }
                    .listStyle(.plain)
                    .padding(.vertical,10)
                }
                        // Loading indicator
                        if viewModel.isLoadingMore ?? false {
                            ProgressView()
                                .frame(width: 120, height: 80)
                                .scaleEffect(0.8)
                        }
//                    }
//                    .padding(.leading, 4)
                }
//                .padding(.leading, 4)
            
        }
    }
    
    
    // MARK: - Load More Categories
    private func loadMoreCategories() {
        Task {
            await viewModel.loadMoreIfNeeded()
        }
    }
}

#Preview {
    TipsCategoriesListView(category: TipsAllItem(title: "مرض السكري", order: 4, id: 4, image: "diabetes2", subjectsCount: 12)).environmentObject(TipDetailsViewModel.shared)
}

// MARK: - Recent Tip Card View
struct TipListCardView: View {
    let item: TipDetailsM?
    var action: (() -> Void)?

    var body: some View {
        Button(action: action ?? { }) {
            
            HStack(spacing: 12) {
                
                if let imageName = item?.image {
                    KFImageLoader(url:URL(string:Constants.imagesURL + (imageName.validateSlashs())),placeholder: Image("sehatylogobg"), isOpenable: false,shouldRefetch: false)
                    //                            .resizable()
                    //                        .clipShape(Circle())
                        .frame( width:71,height: 71)
                        .aspectRatio(contentMode: .fill)
                        .cardStyle(cornerRadius: 6,shadowOpacity: 0.079)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(item?.title ?? "")
                        .font(.bold(size: 16))
                        .foregroundStyle(Color(.mainBlue))
                        .multilineTextAlignment(.trailing)
                        .lineLimit(2)
                    
                    HStack {
                        Text(item?.formattedDate ?? "")
                            .font(.medium(size: 10))
                            .foregroundStyle(Color(.secondary))
                        
                        Spacer()
                        
                    }
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cardStyle(cornerRadius: 6,shadowOpacity: 0.079)
            
    }
}

#Preview {
    TipListCardView(item:  TipDetailsM(
        id: 1,
        title: "أمراض القلب",
        description: "نصائح مهمة للحفاظ على صحة القلب والأوعية الدموية",
        date: "2023-12-23T23:55:00",
        tipCategoryID: 1,
        image: "heart_disease",
        tipCategoryTitle: "أمراض القلب",
        views: 7,
        drugGroups: []
    ))
}
