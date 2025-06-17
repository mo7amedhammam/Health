//
//  SimpleAlertView.swift
//  Sehaty
//
//  Created by mohamed hammam on 15/06/2025.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String?
    let title: String?

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text(title?.localized ?? ""),
                    message: Text(message?.localized ?? ""),
                    dismissButton: .default(Text("OK".localized))
                )
            }
    }
}

extension View {
    func errorAlert(isPresented: Binding<Bool>, message: String? , title: String? = nil) -> some View {
        self.modifier(ErrorAlertModifier(isPresented: isPresented, message: message, title: title))
    }
}
