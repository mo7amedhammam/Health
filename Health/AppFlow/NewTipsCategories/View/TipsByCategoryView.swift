//
//  RecentTipCardView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/07/2025.
//
import SwiftUI



// MARK: - Sample Data
extension TipDetailsM {
    static let sampleTips = [
        
        TipDetailsM(
            id: 1,
            title: "أمراض القلب",
            description: "نصائح مهمة للحفاظ على صحة القلب والأوعية الدموية",
            date: "2023-07-29",
            tipCategoryID: 1,
            image: "heart_disease",
            tipCategoryTitle: "أمراض القلب",
            views: 7,
            drugGroups: []
        ),
        TipDetailsM(
            id: 2,
            title: "مرض السكري",
            description: "كيفية التعامل مع مرض السكري والسيطرة عليه",
            date: "2023-07-28",
            tipCategoryID: 2,
            image: "diabetes",
            tipCategoryTitle: "مرض السكري",
            views: 5,
            drugGroups: []
        ),
        TipDetailsM(
            id: 3,
            title: "صحة العيون",
            description: "نصائح للحفاظ على صحة العيون والرؤية",
            date: "2023-07-27",
            tipCategoryID: 3,
            image: "eye_health",
            tipCategoryTitle: "صحة العيون",
            views: 12,
            drugGroups: []
        ),
        TipDetailsM(
            id: 4,
            title: "ضغط الدم",
            description: "كيفية التحكم في ضغط الدم المرتفع",
            date: "2023-07-26",
            tipCategoryID: 4,
            image: "blood_pressure",
            tipCategoryTitle: "ضغط الدم",
            views: 10,
            drugGroups: []
        ),
        TipDetailsM(
            id: 5,
            title: "الجهاز المناعي",
            description: "طرق تقوية جهاز المناعة الطبيعي",
            date: "2023-07-25",
            tipCategoryID: 5,
            image: "immune_system",
            tipCategoryTitle: "الجهاز المناعي",
            views: 15,
            drugGroups: []
        ),
        TipDetailsM(
            id: 6,
            title: "أمراض الجلد",
            description: "العناية بالبشرة والوقاية من الأمراض الجلدية",
            date: "2023-07-24",
            tipCategoryID: 6,
            image: "skin_diseases",
            tipCategoryTitle: "أمراض الجلد",
            views: 2,
            drugGroups: []
        ),
        TipDetailsM(
            id: 7,
            title: "العناية بالأسنان",
            description: "نصائح للحفاظ على صحة الأسنان واللثة",
            date: "2023-07-23",
            tipCategoryID: 7,
            image: "dental_care",
            tipCategoryTitle: "العناية بالأسنان",
            views: 12,
            drugGroups: []
        ),
        TipDetailsM(
            id: 8,
            title: "الجهاز الهضمي",
            description: "نصائح لتحسين عملية الهضم وصحة المعدة",
            date: "2023-07-22",
            tipCategoryID: 8,
            image: "digestive_system",
            tipCategoryTitle: "الجهاز الهضمي",
            views: 8,
            drugGroups: []
        )
    ]
}



struct TipDisplayItem: Identifiable, Hashable {
    var id: Int?
    var image: String?
    var title: String?
    var subtitle: String?
}
extension TipsAllItem {
    func toDisplayItem() -> TipDisplayItem? {
        guard let id = id,
              let title = title,
              let image = image else { return nil }
        
        let subtitle = "\(subjectsCount ?? 0) " + "subjects_".localized // or customize

        return TipDisplayItem(
            id: id,
            image: image,
            title: title,
            subtitle: subtitle
        )
    }
}
extension TipsNewestM {
    func toDisplayItem() -> TipDisplayItem? {
        guard let id = id,
              let title = title,
              let image = image else { return nil }

        let subtitle = tipCategoryTitle ?? "—"
        
        return TipDisplayItem(
            id: id,
            image: image,
            title: title,
            subtitle: subtitle
        )
    }
}

// MARK: - Main View
struct TipsByCategoryView: View {
    @StateObject var router = NavigationRouter()
    let TipsCategoriesCase : enumTipsCategories
    @EnvironmentObject var viewModel : TipsViewModel
    @StateObject private var detailsViewModel = TipDetailsViewModel.shared

//    @State private var tips: [TipDetailsM] = TipDetailsM.sampleTips
//    @State private var isLoading = false
//    @State private var currentPage = 0
//    @State private var hasMoreData = true
    
//    private let itemsPerPage = 10
    
    var title: String{
        switch TipsCategoriesCase{
        case .All:
            return  "tips_adv".localized
            
        case .Newest:
            return  "tips_newest".localized

        case .Interesting:
            return  "tips_interesting".localized

        case .MostViewed:
            return  "tips_mostviewed".localized

        }
    }
    
    var tips:[TipDisplayItem]?{
        switch TipsCategoriesCase{
        case .All:
//            return  sampleCategories.compactMap{ $0.toDisplayItem() }
            return viewModel.allTips?.items?.compactMap{ $0.toDisplayItem() }
        case .Newest:
//            return  sampleRecentTips.compactMap{ $0.toDisplayItem() }

            return viewModel.newestTipsArr?.compactMap{ $0.toDisplayItem() } ?? []
        case .Interesting:
            return viewModel.interestingTipsArr?.compactMap{ $0.toDisplayItem() } ?? []
        case .MostViewed:
            return viewModel.mostViewedTipsArr?.compactMap{ $0.toDisplayItem() } ?? []
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                // Header
                TitleBar(title:title,hasbackBtn: true)
                
                if let tips = tips{
                    // Content
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 2), spacing: 4) {
                            ForEach(tips.indices, id: \.self) { tip in
                                
                                TipCategoryCardView(tip: tips[tip] ){
//                                    MARK:  --- action ---
                                    router.push(TipDetailsView(tipId: tips[tip].id ?? 0).environmentObject(detailsViewModel))

                                }
                                .onAppear {
                                    // Load more when reaching near the end
                                    if tip >= tips.count - 2 && !(viewModel.isLoadingMore ?? false) {
                                        loadMoreCategories()
                                    }
                                }
                            }
                            
                            // Loading indicator
                            if (viewModel.isLoadingMore ?? false) {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .scaleEffect(1.2)
                                        .frame(height: 60)
                                    Spacer()
                                }

                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                    }
                }
                
                Spacer()
            }
            .background(Color(.bgPink))
            .localizeView()
            .withNavigation(router: router)
            .showHud(isShowing:  $viewModel.isLoading)
            .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)


    }
    
    // MARK: - Load More Categories
    private func loadMoreCategories() {
        Task {
            await viewModel.loadMoreIfNeeded()
        }
    }
}


// MARK: - Tip Category Card View
struct TipCategoryCardView: View {
//    let image:String?
//    let title:String?
//    let subtitle:String?
    let tip:TipDisplayItem?
    let action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        },label:  {
            VStack(alignment:.leading, spacing: 10) {
                if let imageName = tip?.image {
                    KFImageLoader(url:URL(string:Constants.imagesURL + (imageName.validateSlashs())),placeholder: Image("sehatylogobg"), isOpenable: false,shouldRefetch: false)
                    //                            .resizable()
                    //                        .clipShape(Circle())
                        .frame( height: 160)
                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 160, height: 160)
                        .cardStyle(cornerRadius: 3)
                }
                
                Text(tip?.title ?? "")
                    .font(.semiBold(size: 18) )
                    .foregroundStyle(Color(.main))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                
                HStack {
                    Image(.tipscounticon)
                    
                    Text(tip?.subtitle ?? "")
                        .font(.semiBold(size: 12) )
                        .foregroundStyle(Color(.main))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
            }
            .padding(4)
            .padding(.vertical,8)
        })
                
    }
    
}

// MARK: - Preview
struct TipsByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        TipsByCategoryView(TipsCategoriesCase: .All)
            .environmentObject(TipsViewModel.shared)
    }
}

// MARK: - Recent Tip Card View
//struct TipListCardView: View {
//    let item: TipsAllItem
//    var isSelected: Bool = false
//
//    var body: some View {
//        HStack(spacing: 12) {
//            VStack(alignment: .trailing, spacing: 4) {
//                Text(item.title ?? "")
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                    .multilineTextAlignment(.trailing)
//                    .lineLimit(2)
//                
//                HStack {
//                    Text("29/7/2023")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    
//                    Spacer()
//                    
//                    Text("أمراض الجلد")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//            }
//            
//            ZStack {
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(width: 80, height: 80)
//                
//                if isSelected {
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.blue, lineWidth: 2)
//                        .frame(width: 80, height: 80)
//                }
//                
//                Image(systemName: "person.fill")
//                    .font(.title2)
//                    .foregroundColor(.orange)
//            }
//        }
//        .padding(12)
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
//    }
//}
