//
//  customModifiers.swift
//  Sehaty
//
//  Created by mohamed hammam on 03/04/2025.
//

import SwiftUI

struct CardStyleModifier: ViewModifier {
    var backgroundColor: Color = .white
    var cornerRadius: CGFloat = 15
    var shadowColor: Color = Color.black.opacity(0.2)
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: 7, x: 0, y: 2)
    }
}

extension View {
    func cardStyle(backgroundColor: Color = .white,
                   cornerRadius: CGFloat = 15,
                   shadowOpacity: Double = 0.2) -> some View {
        self.modifier(CardStyleModifier(backgroundColor: backgroundColor,
                                        cornerRadius: cornerRadius,
                                        shadowColor: Color.black.opacity(shadowOpacity)))
    }
}
