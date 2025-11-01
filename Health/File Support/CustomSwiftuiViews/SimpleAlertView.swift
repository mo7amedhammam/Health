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
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    if let title = title {
                        Text(title.localized)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }

                    if let message = message {
                        Text(message.localized)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }

                    Button("OK".localized) {
                        isPresented = false
                        action?()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal, 40)
                .shadow(radius: 10)
                .transition(.scale)
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

extension View {
    func errorAlert(
        isPresented: Binding<Bool>,
        message: String?,
        title: String? = nil,
        action: (() -> Void)? = nil
    ) -> some View {
        self.modifier(ErrorAlertModifier(isPresented: isPresented, message: message, title: title, action: action))
    }
}
