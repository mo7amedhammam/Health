//
//  MostViewedBooked.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//

import SwiftUI

struct MostViewedBooked: View {
//    @EnvironmentObject var viewModel : NewHomeViewModel
    
    enum mostcases {
        case mostviewed
        case mostbooked
    }

    // Lifted to parent to avoid dual sources of truth
    @Binding var currentcase: mostcases

    // Keep as input; parent should pass the current dataset for the active tab.
    var packaces: [FeaturedPackageItemM] = []

    @Binding var selectedPackage : FeaturedPackageItemM?
    var likeAction : ((Int, mostcases) -> Void)?
    var onChangeTab : ((mostcases) -> Void)? // callback to parent

    var body: some View {
        HStack{
            HStack(alignment:.top, spacing:20){
                Button(action: {
                    currentcase = .mostbooked
                    onChangeTab?(.mostbooked)
                }){
                    VStack {
                        Text("Most_Booked".localized)
                            .foregroundStyle(currentcase == .mostbooked ? Color(.secondary) : Color(.btnDisabledTxt))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .fixedSize()
                        Circle().fill(currentcase == .mostbooked ? Color(.secondary) : .clear)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Button(action: {
                    currentcase = .mostviewed
                    onChangeTab?(.mostviewed)
                }){
                    VStack {
                        Text("Most_Viewed".localized)
                            .foregroundStyle(currentcase == .mostviewed ? Color(.secondary) : Color(.btnDisabledTxt))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .fixedSize()
                        
                        Circle().fill(currentcase == .mostviewed ? Color(.secondary) : .clear)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .rotationEffect(.degrees(-90))
            .frame(width: 30)
            .font(.bold(size: 22))
            .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    let models = modelize(packaces)
                    ForEach(models) { model in
                        cell(for: model.item)
                    }
                }
                // Force a subtree refresh when the dataset (by stable IDs) changes,
                // which commonly happens when switching tabs.
                .id(listIdentity(for: packaces))
                .padding(.horizontal)
                .padding(.vertical,5)
            }
        }
        .frame(height:356)
        .padding(.vertical,10)
        .padding(.bottom,5)
    }

    // MARK: - Cell builder keeps closures small and stable
    @ViewBuilder
    private func cell(for item: FeaturedPackageItemM) -> some View {
        VipPackageCellView(
            item: item,
            action: { selectedPackage = item },
            likeAction: {
                // Prefer appCountryPackageId, fall back to id if needed
                guard let pid = item.appCountryPackageId ?? item.id else { return }
                likeAction?(pid, currentcase)
            }
        )
        .equatable()
    }
}

// MARK: - Identity helpers
private extension MostViewedBooked {
    struct PackageRowModel: Identifiable, Equatable {
        let id: String
        let item: FeaturedPackageItemM
    }

    // Build a base ID using valid positive IDs; otherwise use a composite fallback.
    func baseID(for item: FeaturedPackageItemM, fallbackIndex: Int) -> String {
        if let pid = item.appCountryPackageId, pid > 0 {
            return "app:\(pid)"
        }
        if let id = item.id, id > 0 {
            return "id:\(id)"
        }
        // Deterministic fallback using index + a couple of stable fields to avoid collisions
        let name = item.name ?? ""
        let cat = item.categoryName ?? ""
        return "ix:\(fallbackIndex):\(name)#\(cat)"
    }

    // Ensure uniqueness even if the base ID repeats (e.g., "app:0" or duplicate items).
    func modelize(_ items: [FeaturedPackageItemM]) -> [PackageRowModel] {
        var occurrences: [String: Int] = [:]
        return items.enumerated().map { (idx, it) in
            let base = baseID(for: it, fallbackIndex: idx)
            let count = (occurrences[base] ?? 0) + 1
            occurrences[base] = count
            let unique = count == 1 ? base : "\(base)#\(count)"
            return PackageRowModel(id: unique, item: it)
        }
    }

    // A combined identity for the whole list; when it changes, the LazyHStack subtree is rebuilt.
    func listIdentity(for items: [FeaturedPackageItemM]) -> String {
        modelize(items).map(\.id).joined(separator: "|")
    }
}

#Preview(body: {
    MostViewedBooked(
        currentcase: .constant(.mostviewed),
        packaces: [],
        selectedPackage: .constant(nil)
    )
})
