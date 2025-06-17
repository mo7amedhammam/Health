//
//  LinearGradientView.swift
//  Sehaty
//
//  Created by mohamed hammam on 15/06/2025.
//

import SwiftUI

struct HorizontalGradientBackground: ViewModifier {
    var colors: [Color] = [.mainBlue, Color(.secondary)]
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .reversLocalizeView()
    }
}
extension View {
    func horizontalGradientBackground(colors: [Color] = [.mainBlue, Color(.secondary)]) -> some View {
        self.modifier(HorizontalGradientBackground(colors: colors))
    }
}

