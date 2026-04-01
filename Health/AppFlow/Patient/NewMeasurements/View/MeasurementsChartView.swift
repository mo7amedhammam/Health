//
//  MeasurementsChartView.swift
//  Sehaty
//
//  Created by mohamed hammam on 30/03/2026.
//

import SwiftUI

struct MeasurementsBarChart: View {

    let items: [Item]
    let normalRange: ModelMeasurementsNormalRange?
    
    private struct BPValue { let systolic: Double; let diastolic: Double }
    private struct NormalBand {
        let lower: Double
        let upper: Double
    }
    
    private func parseBP(_ text: String?) -> BPValue? {
        guard let text = text, text.contains("/") else { return nil }
        let parts = text.split(separator: "/", maxSplits: 1).map { String($0) }
        guard parts.count == 2,
              let sys = Double(parts[0].trimmingCharacters(in: .whitespaces)),
              let dia = Double(parts[1].trimmingCharacters(in: .whitespaces)) else { return nil }
        return BPValue(systolic: sys, diastolic: dia)
    }
    
    private var hasBloodPressure: Bool {
        items.contains { parseBP($0.value) != nil }
    }

    private var values: [Double] {
        var result: [Double] = []
        for it in items {
            if let bp = parseBP(it.value) {
                result.append(bp.systolic)
                result.append(bp.diastolic)
            } else if let v = Double(it.value ?? "") {
                result.append(v)
            }
        }
        return result
    }

    private var maxValue: Double {
        (values + normalRangeValues).max() ?? 1
    }

    private var normalRangeValues: [Double] {
        guard let band = resolvedNormalBand else { return [] }
        return [band.lower, band.upper]
    }

    private var resolvedNormalBand: NormalBand? {
        if let normalRange {
            if let fromBP = parseBP(normalRange.fromValue),
               let toBP = parseBP(normalRange.toValue) {
                return NormalBand(
                    lower: min(fromBP.diastolic, toBP.diastolic),
                    upper: max(fromBP.systolic, toBP.systolic)
                )
            }

            if let fromValue = Double(normalRange.fromValue ?? ""),
               let toValue = Double(normalRange.toValue ?? "") {
                return NormalBand(
                    lower: min(fromValue, toValue),
                    upper: max(fromValue, toValue)
                )
            }
        }

        let normals: [Double] = items.flatMap { item -> [Double] in
            guard item.inNormalRang == true else { return [] }
            if let bp = parseBP(item.value) {
                return [bp.diastolic, bp.systolic]
            }
            if let value = Double(item.value ?? "") {
                return [value]
            }
            return []
        }

        guard let minValue = normals.min(), let maxValue = normals.max() else {
            return nil
        }

        return NormalBand(lower: minValue, upper: maxValue)
    }

    private let barWidth: CGFloat = 35
    private let barSpacing: CGFloat = 16
    private let chartHeight: CGFloat = 220

    private var chartUpperBound: Double {
        niceAxisCeiling(for: max(maxValue, 1))
    }

    var body: some View {
        let ticks = yAxisValues()

        VStack(spacing: 0) {

            // Y-axis + scrollable bars
            HStack(alignment: .bottom, spacing: 0) {

                // Y-axis labels ( numbers )
                GeometryReader { axisGeo in
                    ForEach(Array(ticks.enumerated()), id: \.offset) { _, value in
                        Text(axisLabel(for: value))
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .frame(width: axisGeo.size.width, alignment: .trailing)
                            .position(
                                x: axisGeo.size.width / 2,
                                y: yPosition(for: value)
                            )
                    }
                }
                .frame(width: 36, height: chartHeight)
                
                Rectangle()
                    .fill(Color(.main))
                    .frame(width: 2, height: chartHeight)

                // Scrollable bars
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: barSpacing) {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                            let value = Double(item.value ?? "") ?? 0
                            let isNormal = item.inNormalRang ?? false
                            VStack(spacing: 4) {

                                Spacer()
                                
                                if let bp = parseBP(item.value) {
                                    // BP label stacked as "sys/dia"
                                    Text("\(Int(bp.systolic))/\(Int(bp.diastolic))")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .fixedSize()

                                    // Two side-by-side bars: left = systolic, right = diastolic
                                    let sysHeight = max(2, height(for: bp.systolic))
                                    let diaHeight = max(2, height(for: bp.diastolic))

                                    HStack(alignment: .bottom, spacing: 4) {
                                        RoundedRectangle(cornerRadius: 1)
                                            .fill(isNormal ? Color(.main) : Color(.secondary))
                                            .frame(width: max(2, (barWidth - 4) / 2), height: sysHeight)
                                        RoundedRectangle(cornerRadius: 1)
                                            .fill((isNormal ? Color(.main) : Color(.secondary)).opacity(0.6))
                                            .frame(width: max(2, (barWidth - 4) / 2), height: diaHeight)
                                    }
                                    .frame(width: barWidth)
                                } else {
                                    // Value label
                                    Text("\(Int(value))")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .fixedSize()

                                    // Single bar
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(isNormal
                                              ? Color(.main)
                                              : Color(.secondary))
                                        .frame(
                                            width: barWidth,
                                            height: max(4, height(for: value))
                                        )
                                }

                            }
                            .frame(height: chartHeight)
                        }
                    }
                    .padding(.horizontal, 12)
                    .frame(height: chartHeight)
                    .offset(y:-2)
                }
                .overlay(
                    GeometryReader { geo in
                        ZStack(alignment: .topLeading) {
                            ForEach(Array(ticks.enumerated()), id: \.offset) { _, value in
                                Path { path in
                                    let y = yPosition(for: value)
                                    path.move(to: CGPoint(x: 0, y: y))
                                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                                }
                                .stroke(Color(.secondary).opacity(0.12), lineWidth: 0.75)
                            }

                            if let band = resolvedNormalBand {
                                let lowerY = yPosition(for: band.lower)
                                let upperY = yPosition(for: band.upper)
                                let bandTop = min(lowerY, upperY)
                                let bandBottom = max(lowerY, upperY)
                                let bandHeight = max(0, bandBottom - bandTop)

                                Rectangle()
                                    .fill(Color.green.opacity(0.1))
                                    .frame(height: bandHeight)
                                    .offset(y: bandTop)

                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: lowerY))
                                    path.addLine(to: CGPoint(x: geo.size.width, y: lowerY))
                                }
                                .stroke(Color.green, style: StrokeStyle(lineWidth: 1, dash: [4]))

                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: upperY))
                                    path.addLine(to: CGPoint(x: geo.size.width, y: upperY))
                                }
                                .stroke(Color.green, style: StrokeStyle(lineWidth: 1, dash: [4]))
                            }
                        }
                    }
                )
            }

            // X-axis line
            Rectangle()
                .fill(Color(.main))
                .frame(height: 2)
                .padding(.leading, 38)
                .offset(y:-2)

            // Dates under X-axis
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: barSpacing) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        Text(item.formattedchartdate ?? "—")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .fixedSize()
                            .frame(width: barWidth)
                            .rotationEffect(.degrees(-45))
                            .frame(height: 40)
                    }
                }
                .padding(.leading, 50) // align with bars start after Y-axis
                .padding(.vertical, 4)
            }
            
        }
        .cardStyle()
    }

    private func yAxisValues() -> [Double] {
        let step = chartUpperBound / 8
        return (0...8).map { Double($0) * step }
    }

    private func yPosition(for value: Double) -> CGFloat {
        chartHeight - height(for: value)
    }

    private func height(for value: Double) -> CGFloat {
        let upperBound = max(chartUpperBound, 1)
        let normalizedValue = min(max(value, 0), upperBound) / upperBound
        return CGFloat(normalizedValue) * chartHeight
    }

    private func axisLabel(for value: Double) -> String {
        if abs(value.rounded() - value) < 0.001 {
            return "\(Int(value.rounded()))"
        }
        return String(format: "%.1f", value)
    }

    private func niceAxisCeiling(for value: Double) -> Double {
        guard value > 0 else { return 1 }

        let magnitude = pow(10, floor(log10(value)))
        let normalized = value / magnitude
        let factor: Double

        switch normalized {
        case ...1:
            factor = 1
        case ...2:
            factor = 2
        case ...5:
            factor = 5
        default:
            factor = 10
        }

        return factor * magnitude
    }
}

// MARK: - Preview
#Preview {
    let mockItems: [Item] = [
        Item(inNormalRang: true, id: 1, date: "2026-03-28T00:00:00", medicalMeasurementTitle: nil, medicalMeasurementImage: nil, createdBy: nil, createdByName: nil, customerID: nil, medicalMeasurementID: nil, value: "120/80", comment: nil),
        Item(inNormalRang: false, id: 2, date: "2026-03-29T00:00:00", medicalMeasurementTitle: nil, medicalMeasurementImage: nil, createdBy: nil, createdByName: nil, customerID: nil, medicalMeasurementID: nil, value: "110/60", comment: nil),
        Item(inNormalRang: false, id: 2, date: "2026-03-29T00:00:00", medicalMeasurementTitle: nil, medicalMeasurementImage: nil, createdBy: nil, createdByName: nil, customerID: nil, medicalMeasurementID: nil, value: "130/70", comment: nil)
    ]

    MeasurementsBarChart(
        items: mockItems,
        normalRange: ModelMeasurementsNormalRange(id: 1, fromValue: "80/60", toValue: "120/80")
    )
}

// MARK: - Usage
// From API response:
//
// let values = response.data.measurementsValues.compactMap { Double($0) }
// let normalRange = response.data.measurements.items.map { $0.inNormalRang }
//
// MeasurementsBarChart(items: values, inNormalRange: normalRange)
