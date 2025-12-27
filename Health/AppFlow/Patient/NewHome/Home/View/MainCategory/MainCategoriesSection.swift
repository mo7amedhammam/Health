//
//  MainCategoriesSection.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//

import SwiftUI

struct MainCategoriesSection: View {
    let categories: HomeCategoryM?
    let action: ((HomeCategoryItemM) -> Void)?
    let loadMore: (() -> Void)?
    let moreBtnAction: (() -> Void)?
    var body: some View {
        VStack(spacing: 5) {
            SectionHeader(image: Image(.newcategicon), title: "home_maincat") {
                // go to last mes package
                moreBtnAction?()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    let items = categories?.items ?? []
                    
                    ForEach(items, id: \.stableID) { item in
                        MainCategoryCardView(item: item, action: action)
                            .buttonStyle(.plain)
                            .cardStyle(cornerRadius: 3)
                            .onAppear {
                                if item == items.last {
                                    loadMore?()
                                }
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
        }
        .padding(.vertical, 5)
        .padding(.bottom, 5)
    }
}
// --- PAGINATED MAIN CATEGORIES SECTION VIEW ---
//struct MainCategoriesPaginatedSection: View {
//    let categories: HomeCategoryM?
//    let isLoadingMore: Bool
//    let loadMoreAction: () -> Void
//    let onSelectCategory: (HomeCategoryItemM) -> Void
//
//    var body: some View {
//        VStack(spacing: 5) {
//            SectionHeader(image: Image(.newcategicon), title: "home_maincat") { }
//                .padding(.horizontal)
//
//            ScrollView(.horizontal, showsIndicators: false) {
//                LazyHStack(spacing: 12) {
//                    let items = categories?.items ?? []
//                    ForEach(Array(items.enumerated()), id: \.element.id) { idx, item in
//                        MainCategoryCardView(item: item, action: { _ in onSelectCategory(item) })
//                            .buttonStyle(.plain)
//                            .cardStyle(cornerRadius: 3)
//                            .onAppear {
//                                // If last item appears: trigger pagination
//                                if idx == items.count - 1,
//                                   let total = categories?.totalCount,
//                                   items.count < total {
//                                    loadMoreAction()
//                                }
//                            }
//                    }
//                    // Show a loading indicator if more pages exist
//                    if let total = categories?.totalCount,
//                       let items = categories?.items,
//                       items.count < total,
//                       isLoadingMore {
//                        HStack {
//                            ProgressView()
//                                .tint(.gray)
//                            Text("loading_more".localized)
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.vertical, 5)
//            }
//        }
//        .padding(.vertical, 5)
//        .padding(.bottom, 5)
//    }
//}
 
struct MainCategoryCardView: View, Equatable {
    let item: HomeCategoryItemM
    let action: ((HomeCategoryItemM) -> Void)?
    
    static func == (lhs: MainCategoryCardView, rhs: MainCategoryCardView) -> Bool {
        // Only re-render when the item payload actually changes.
        lhs.item == rhs.item
    }
    
    var body: some View {
        Button(action: {
            action?(item)
        }) {
            ZStack(alignment: .bottom) {
                KFImageLoader(
                    url: URL(string: Constants.imagesURL + (item.homeImage?.validateSlashs() ?? "")),
                    placeholder: Image("logo"),
                    shouldRefetch: false // keep cache; avoid timestamped URL on every recompute
                )
                .frame(width: 166, height: 221)
                
                VStack(alignment: .leading) {
                    Text(item.title ?? "")
                        .font(.semiBold(size: 18))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        HStack(spacing: 2) {
                            Image(.newsubmaincaticon)
                                .resizable()
                                .frame(width: 9, height: 9)
                                .scaledToFit()
                            
                            (Text(" \(item.subCategoryCount ?? 0) ") + Text("sub_category".localized))
                                .font(.medium(size: 12))
                        }
                        .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Image("newvippackicon")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 8, height: 9)
                                .scaledToFit()
                                .foregroundStyle(.white)
                            
                            (Text(" \(item.packageCount ?? 0) ") + Text("package_".localized))
                                .font(.medium(size: 12))
                        }
                        .foregroundStyle(Color.white)
                    }
                }
                .padding([.vertical, .horizontal], 10)
                .background {
                    BlurView(radius: 5)
                        .horizontalGradientBackground()
                        .opacity(0.89)
                }
            }
        }
    }
}

// Stable identity for diffing in ForEach

extension HomeCategoryItemM {
    var stableID: Int {
        if let id { return id }
        // Fallback: combine several fields to reduce collision risk
        var hasher = Hasher()
        hasher.combine(title)
        hasher.combine(homeImage)
        hasher.combine(imagePath)
        hasher.combine(subCategoryCount)
        hasher.combine(packageCount)
        return hasher.finalize()
    }
}

#Preview {
    MainCategoriesSection(categories: nil, action: nil, loadMore: {}, moreBtnAction: {})
}
