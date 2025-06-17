//
//  SkeletonView.swift
//  Sehaty
//
//  Created by mohamed hammam on 15/06/2025.
//

import SwiftUI


// MARK: - Skeleton Package Card
struct SkeletonPackageCard: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.15))
                .frame(height: 180)
                .shimmering(active: isAnimating)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 36, height: 36)
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 120, height: 12)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 80, height: 10)
                    }
                    Spacer()
                }

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 12)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 12)
            }
            .padding()
            .shimmering(active: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Simple Shimmer Modifier
struct ShimmerViewModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    var active: Bool

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.6), Color.clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(30))
                        .offset(x: active ? phase : -geometry.size.width)
                        .animation(active ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: phase)
                        .onAppear {
                            phase = geometry.size.width * 2
                        }
                }
            )
            .mask(content)
    }
}

extension View {
    func shimmering(active: Bool = true) -> some View {
        self.modifier(ShimmerViewModifier(active: active))
    }
}


