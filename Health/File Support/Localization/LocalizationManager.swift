//
//  LocalizationManager.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/03/2025.
//

import Foundation

class LocalizationManager : ObservableObject{
    static let shared = LocalizationManager()
    
    private let queue = DispatchQueue(label: "com.yourapp.localization", attributes: .concurrent)
    private var translations: [String: String] = [:]
    @Published var currentLanguage: String? = nil // Default language
    
    private init() {}
    
    func setLanguage(_ language: String, completion: @escaping (Bool) -> Void) {
        currentLanguage = language
        fetchTranslations { success in
            completion(success)
        }
    }
    
    func localizedString(forKey key: String) -> String {
        queue.sync {
            return translations[key] ?? key
        }
    }
    
    private func cacheTranslations(_ translations: [String: String], for language: String) {
        queue.async(flags: .barrier) {
            UserDefaults.standard.set(translations, forKey: "cachedTranslations_\(language)")
        }
    }

    private func loadCachedTranslations(for language: String) -> [String: String]? {
        queue.sync {
            return UserDefaults.standard.dictionary(forKey: "cachedTranslations_\(language)") as? [String: String]
        }
    }
    
    private func loadDefaultTranslations() -> [String: String] {
        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "strings"),
              let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] else {
            return [:]
        }
        return dictionary
    }
    
    private func fetchTranslations(completion: @escaping (Bool) -> Void) {
//        if let cachedTranslations = loadCachedTranslations(for: currentLanguage){
//            self.updateTranslations(cachedTranslations)
//            completion(true)
//            return
//        }
        
        let urlString = "https://alnada-devmrsapi.azurewebsites.net/api/\(currentLanguage ?? "ar")/Translations/GetTranslationFile/ios"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            self.updateTranslations(self.loadDefaultTranslations())
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching translations: \(error.localizedDescription)")
                self.updateTranslations(self.loadDefaultTranslations())
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                self.updateTranslations(self.loadDefaultTranslations())
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                    print("Localization updated for : \(self.currentLanguage ?? "ar")")
                    self.updateTranslations(json)
                    self.cacheTranslations(json, for: self.currentLanguage ?? "ar")
                    completion(true)
                } else {
                    print("Invalid JSON format")
                    self.updateTranslations(self.loadDefaultTranslations())
                    completion(false)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                self.updateTranslations(self.loadDefaultTranslations())
                completion(false)
            }
        }.resume()
    }
    
    private func updateTranslations(_ newTranslations: [String: String]) {
        queue.async(flags: .barrier) {
            print("newTranslations",newTranslations)
            self.translations = newTranslations
        }
    }
}

import Foundation

extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(forKey: self)
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}


import SwiftUI
//MARK:  --- ViewModifier to update layout Direction RTL ---
struct LocalizationViewModifier: ViewModifier {
    @ObservedObject var localizeHelper = LocalizationManager.shared
    public func body(content: Content) -> some View {
        content
            .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage ?? "ar"))
            .environment(\.layoutDirection, localizeHelper.currentLanguage == "en" ? .rightToLeft : .leftToRight)
    }
}
//MARK:  --- ViewModifier to update layout Direction RTL ---
struct ReversedLocalizationViewModifier: ViewModifier {
    @ObservedObject var localizeHelper = LocalizationManager.shared
    public func body(content: Content) -> some View {
        content
            .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage ?? "ar"))
            .environment(\.layoutDirection, localizeHelper.currentLanguage == "en" ? .leftToRight : .rightToLeft)
    }
}

// --- View Extension to apply the modifier ---
extension View {
    public func localizeView() -> some View {
        modifier(LocalizationViewModifier())
    }
    public func reversLocalizeView() -> some View {
        modifier(ReversedLocalizationViewModifier())
    }
}
