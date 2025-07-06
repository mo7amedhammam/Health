//
//  BiometricLoginButton.swift
//  Sehaty
//
//  Created by mohamed hammam on 06/07/2025.
//


import SwiftUI
import LocalAuthentication

struct BiometricLoginButton: View {
    var onSuccess: () -> Void
    @State private var authError: String?

    var body: some View {
        VStack {
            Button(action: {
                authenticateUser()
            }) {
                Image(.touchidicon)
                    .resizable()
                    .frame(width: 68, height: 68)
                    .foregroundColor(.pink)
                    .padding(.top, 8)
            }

            if let error = authError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }

    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        // تحقق من أن الجهاز يدعم Face ID / Touch ID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "قم بالمصادقة باستخدام Touch ID أو Face ID"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        onSuccess()
                    } else {
                        self.authError = authError?.localizedDescription ?? "فشل التحقق"
                    }
                }
            }
        } else {
            self.authError = "Face ID / Touch ID غير متاح على هذا الجهاز"
        }
    }
}


import Security

class KeychainHelper {
    static func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    static func get(_ key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }

    static func delete(_ key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        SecItemDelete(query)
    }
}
