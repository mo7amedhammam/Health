//
//  LastMesurmentsSection.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//

import SwiftUI

struct LastMesurmentsSection: View {
    var measurements: [MyMeasurementsStatsM]?

    // Use a static constant so the grid description isn't reallocated on every new instance.
    private static let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    let action: ((MyMeasurementsStatsM?) -> Void)?

    var body: some View {
        VStack{
            SectionHeader(image: Image(.newlastmesicon), title: "home_lastMes") {
                // go to last mes package
            }
            .padding(.horizontal)

            LazyVGrid(columns: Self.columns, spacing: 5) {
                let items = measurements ?? []

                if items.allSatisfy({ $0.medicalMeasurementID != nil }) {
                    ForEach(items, id: \.medicalMeasurementID) { item in
                        cell(for: item)
                    }
                } else {
                    // Fallback to index-based identity if IDs are missing
                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        cell(for: item)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .padding(.vertical, 5)
        .padding(.bottom, 5)
    }

    // MARK: - Cell builder keeps closures small and stable
    @ViewBuilder
    private func cell(for item: MyMeasurementsStatsM) -> some View {
        MeasurementCell(
            item: item,
            action: { action?(item) }
        )
        .equatable()
    }
}

private struct MeasurementCell: View, Equatable {
    static func == (lhs: MeasurementCell, rhs: MeasurementCell) -> Bool {
        lhs.item == rhs.item
    }

    let item: MyMeasurementsStatsM
    let action: (() -> Void)?

    var body: some View {
        Button(action: { action?() }) {
            VStack {
                Text(item.title ?? "")
                    .font(.bold(size: 16))
                    .foregroundStyle(Color.mainBlue)
                    .frame(maxWidth: .infinity)

                KFImageLoader(
                    url: URL(string: Constants.imagesURL + (item.image?.validateSlashs() ?? "")),
                    placeholder: Image("logo"),
                    shouldRefetch: true
                )
                .frame(width: 32, height: 32)

                Text(item.lastMeasurementValue ?? "")
                    .font(.bold(size: 16))
                    .foregroundStyle(Color(.secondaryMain))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 0)

                Text(item.formatteddate ?? "")
                    .font(.medium(size: 11))
                    .foregroundStyle(Color.mainBlue)
                    .frame(maxWidth: .infinity)
            }
            // Let the grid size the width; only constrain height.
            .frame(height: 112)
            .cardStyle(cornerRadius: 3, shadowOpacity: 0.08)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LastMesurmentsSection(action: { _ in })
}
