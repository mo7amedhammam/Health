//
//  MeasurementsChartView.swift
//  Sehaty
//
//  Created by mohamed hammam on 30/03/2026.
//

import SwiftUI

struct MeasurementsBarChart: View {

    let items: [Double]
    let inNormalRange: [Bool] // same count as items

    private var maxValue: Double {
        items.max() ?? 1
    }

    private let barWidth: CGFloat = 40
    private let barSpacing: CGFloat = 16
    private let chartHeight: CGFloat = 200

    var body: some View {
        VStack(spacing: 0) {

            // Y-axis + scrollable bars
            HStack(alignment: .bottom, spacing: 0) {

                // Y-axis labels
                VStack(alignment: .trailing, spacing: 0) {
                    ForEach(yAxisValues().reversed(), id: \.self) { val in
                        Text("\(Int(val))")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .frame(height: chartHeight / CGFloat(yAxisValues().count - 1),
                                   alignment: .top)
                    }
                }
                .frame(width: 36)
                .padding(.bottom, 24) // align with x-axis labels height

                // Scrollable bars
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: barSpacing) {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, value in
                            VStack(spacing: 4) {
                                // Value label
                                Text("\(Int(value))")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .fixedSize()

                                // Bar
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(inNormalRange[index]
                                          ? Color(hex: "#3266AD")
                                          : Color(hex: "#D4537E"))
                                    .frame(
                                        width: barWidth,
                                        height: max(4, (value / (maxValue * 1.25)) * chartHeight)
                                    )

                                // X label
                                Text("قياس \(index + 1)")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                    .fixedSize()
                                    .frame(width: barWidth)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .frame(height: chartHeight + 50) // bars + labels
                }
            }

            // Bottom divider line
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.leading, 36)
        }
    }

    private func yAxisValues() -> [Double] {
        let top = maxValue * 1.25
        let step = top / 4
        return (0...4).map { Double($0) * step }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview
#Preview {
    let values = [100, 180, 200, 222, 300, 400, 500].compactMap { Double($0) }
    let normalRange = [true, false, true, false, true, true, false].map { $0 }
    
    MeasurementsBarChart(items: values, inNormalRange: normalRange)
}

// MARK: - Usage
// From API response:
//
// let values = response.data.measurementsValues.compactMap { Double($0) }
// let normalRange = response.data.measurements.items.map { $0.inNormalRang }
//
// MeasurementsBarChart(items: values, inNormalRange: normalRange)


