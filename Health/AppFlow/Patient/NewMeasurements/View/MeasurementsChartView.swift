//
//  MeasurementsChartView.swift
//  Sehaty
//
//  Created by mohamed hammam on 30/03/2026.
//

import SwiftUI

struct MeasurementsBarChart: View {

    let items: [Item]

    private var values: [Double] {
        items.compactMap { Double($0.value ?? "") }
    }

    private var maxValue: Double {
        values.max() ?? 1
    }

    private var minNormalValue: Double {
        (items.compactMap { $0.inNormalRang == true ? Double($0.value ?? "") : nil }.min() ?? 0) - 30
    }

    private var maxNormalValue: Double {
        (items.compactMap { $0.inNormalRang == true ? Double($0.value ?? "") : nil }.max() ?? maxValue)
        + 30
    }

    private let barWidth: CGFloat = 30
    private let barSpacing: CGFloat = 16
    private let chartHeight: CGFloat = 300

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
                        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                            let value = Double(item.value ?? "") ?? 0
                            let isNormal = item.inNormalRang ?? false
                            VStack(spacing: 4) {
                                // Value label
                                Text("\(Int(value))")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .fixedSize()

                                // Bar
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(isNormal
                                          ? Color(.main)
                                          : Color(.secondary))
                                    .frame(
                                        width: barWidth,
                                        height: max(4, (value / (maxValue * 1.25)) * chartHeight)
                                    )

                                // X label
                                Text(item.formattedchartdate ?? "—")
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                                    .fixedSize()
                                    .frame(width: barWidth)
                                    .rotationEffect(.degrees(-45))
                                    .frame(height: 40)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .frame(height: chartHeight + 50) // bars + labels
                }
                .overlay(
                    GeometryReader { geo in
                        let height = chartHeight
                        let minY = height - CGFloat(minNormalValue / (maxValue * 1.25)) * height
                        let maxY = height - CGFloat(maxNormalValue / (maxValue * 1.25)) * height

                        ZStack(alignment: .topLeading) {
                            Rectangle()
                                .fill(Color.green.opacity(0.1))
                                .frame(height: maxY - minY)
                                .offset(y: minY)

                            Path { path in
                                path.move(to: CGPoint(x: 0, y: minY))
                                path.addLine(to: CGPoint(x: geo.size.width, y: minY))
                            }
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 1, dash: [4]))

                            Path { path in
                                path.move(to: CGPoint(x: 0, y: maxY))
                                path.addLine(to: CGPoint(x: geo.size.width, y: maxY))
                            }
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 1, dash: [4]))
                        }
                    }
                )
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
    let mockItems: [Item] = [
        Item(inNormalRang: true, id: 1, date: "2026-03-28T00:00:00", medicalMeasurementTitle: nil, medicalMeasurementImage: nil, createdBy: nil, createdByName: nil, customerID: nil, medicalMeasurementID: nil, value: "100", comment: nil),
        Item(inNormalRang: false, id: 2, date: "2026-03-29T00:00:00", medicalMeasurementTitle: nil, medicalMeasurementImage: nil, createdBy: nil, createdByName: nil, customerID: nil, medicalMeasurementID: nil, value: "200", comment: nil)
    ]

    MeasurementsBarChart(items: mockItems)
}

// MARK: - Usage
// From API response:
//
// let values = response.data.measurementsValues.compactMap { Double($0) }
// let normalRange = response.data.measurements.items.map { $0.inNormalRang }
//
// MeasurementsBarChart(items: values, inNormalRange: normalRange)


