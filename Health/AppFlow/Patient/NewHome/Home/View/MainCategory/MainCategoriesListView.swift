import SwiftUI

struct MainCategoriesListView: View {
    @StateObject var router = NavigationRouter()

    @EnvironmentObject var viewModel: NewHomeViewModel
//    var onSelect: (() -> Void)?

    // 2-column grid
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 8) {
            TitleBar(title: "home_maincat",hasbackBtn: true)
            Spacer()
            
            ScrollView{
            LazyVGrid(columns: columns, spacing: 12) {
                let items = viewModel.homeCategories?.items ?? []
                ForEach(items, id: \.stableID){ item in
                    // Reuse the card from MainCategoriesSection to keep a single source of truth
                    MainCategoryCardView(item: item, action: {_ in
                        //                        onSelect?()
                        router.push(PackagesView(mainCategory: item))
                        
                    })
                    .buttonStyle(.plain)
                    .cardStyle(cornerRadius: 3)
                    .onAppear {
                        if item == items.last {
                            //                            loadMore?()
                            Task {
                                await viewModel.loadMoreCategoriesIfNeeded()
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowSpacing(0)
                }
                .listStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.top,5)
        }
        }
        .padding(.vertical, 5)
        .padding(.bottom, 5)
        .localizeView()
        .withNavigation(router: router)
        .showHud(isShowing: $viewModel.isLoading )
        // Two-way binding so dismissing the alert clears the error
        .errorAlert(
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            ),
            message: viewModel.errorMessage
        )
        .task {
            await viewModel.loadMoreCategoriesIfNeeded()
        }
        .refreshable {
            await viewModel.refreshMoreCategories()
        }
    }
}

#Preview {
    MainCategoriesListView()
        .environmentObject(NewHomeViewModel.shared)
}
