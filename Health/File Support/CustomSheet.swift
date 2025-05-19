//
//  CustomHeightSheetModifier.swift
//  Sehaty
//
//  Created by mohamed hammam on 20/05/2025.
//

import SwiftUI

struct CustomHeightSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var height: CGFloat?
    var radius: CGFloat?

    let sheetContent: () -> SheetContent

    @ViewBuilder
    func sheetBody() -> some View {
        if #available(iOS 16.4, *) {
            sheetContent()
                .presentationDetents([.height(height ?? 300)])
                .presentationCornerRadius(radius ?? 12)
        } else {
            sheetContent()
                .frame(height: height)
                .cornerRadius(radius ?? 12)
        }
    }

    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            sheetBody()
        }
        .background(Color(.systemBackground))

    }
}

extension View {
    func customSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat? = nil,
        radius: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(CustomHeightSheetModifier(isPresented: isPresented, height: height,radius: radius, sheetContent: content))
    }
}
