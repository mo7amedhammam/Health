//
//  ConfirmationDialogView.swift
//  Sehaty
//
//  Created by mohamed hammam on 24/08/2025.
//


import SwiftUI

struct ConfirmationDialogView: View {
    var iconName: String
    var message: String
    var confirmTitle: String
    var cancelTitle: String
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            Text(message.localized)
                .font(.medium(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.mainBlue)
                .padding(.horizontal)

            HStack(spacing: 15) {
                Button(action: onCancel) {
                    Text(cancelTitle.localized)
                        .font(.bold(size: 24))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(.secondary))
                        .cornerRadius(3)
                }

                Button(action: onConfirm) {
                    Text(confirmTitle.localized)
                        .font(.bold(size: 24))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(.mainBlue))
                        .cornerRadius(3)
                }
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(3)
        .shadow(radius: 5)
        .frame(maxWidth: 300)
    }
}
#Preview {
    ConfirmationDialogView(
        iconName: "calendar_icon", // your asset
        message: "هل أنت متأكد من تحديد المواعيد المتاحة إليك؟",
        confirmTitle: "تأكيد",
        cancelTitle: "إلغاء",
        onConfirm: {
            print("Confirmed")
//            showDialog = false
        },
        onCancel: {
            print("Cancelled")
//            showDialog = false
        }
    )
}
