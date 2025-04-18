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
    @Published var currentLanguage: String? = ""  // Default language
    
    private init() {}
    
    func setLanguage(_ language: String, completion: @escaping (Bool) -> Void) {
        print("setLanguage",language)

        currentLanguage = language
//        UIView.appearance().semanticContentAttribute = language == "ar" ? .forceRightToLeft:.forceLeftToRight
        Helper.shared.setLanguage(currentLanguage: language)
        Helper.shared.languageSelected(opened: true)
        fetchTranslations { success in
            completion(success)
        }

    }
    
    func localizedString(forKey key: String) -> String {
        queue.sync {
            
            return translations[key] ?? NSLocalizedString(key, comment: "")
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
    
//    private func loadDefaultTranslations() -> [String: String] {
//        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "strings"),
//              let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] else {
//            return [:]
//        }
//        return dictionary
//    }
    
    private func loadDefaultTranslations(for language: String) -> [String: String] {
//        UserDefaults.standard.removeObject(forKey: "cachedTranslations_\(language)")
        if let cachedTranslations = loadCachedTranslations(for: language){
            self.updateTranslations(cachedTranslations)
//            completion(true)
            return cachedTranslations
        }else{
            
            // 1. Try to load the specific language file first
            if let path = Bundle.main.path(forResource: "ar", ofType: "lproj"),
               let bundle = Bundle(path: path),
               let path = bundle.path(forResource: "Localizable", ofType: "strings"),
               let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] {
                return dictionary
            }
            
            // 2. Fall back to base localization (English)
            guard let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
                  let bundle = Bundle(path: path),
                  let path = bundle.path(forResource: "Localizable", ofType: "strings"),
                  let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] else {
                return [:] // Final fallback
            }
            
            return dictionary
        }
    }
    
     func fetchTranslations(completion: @escaping (Bool) -> Void) {

        let urlString = "https://alnada-devmrsapi.azurewebsites.net/api/\(currentLanguage ?? "ar")/Translations/GetTranslationFile/ios 66"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            self.updateTranslations(self.loadDefaultTranslations(for: currentLanguage ?? "ar"))

            completion(false)
            return
        }
        
         URLSession.shared.dataTask(with: url) { [self] data, response, error in
            if let error = error {
                print("Error fetching translations: \(error.localizedDescription)")
                self.updateTranslations(self.loadDefaultTranslations(for: currentLanguage ?? "ar"))

                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                self.updateTranslations(self.loadDefaultTranslations(for: currentLanguage ?? "ar"))

                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                    print("Localization updated for : \(self.currentLanguage ?? "ar")")
//                    self.updateTranslations(json)
//                    self.cacheTranslations(json, for: self.currentLanguage ?? "ar")
                    completion(true)
                } else {
                    print("Invalid JSON format")
                    self.updateTranslations(self.loadDefaultTranslations(for: currentLanguage ?? "ar"))

                    completion(false)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
//                self.updateTranslations(self.loadDefaultTranslations())
                self.updateTranslations(self.loadDefaultTranslations(for: currentLanguage ?? "ar"))

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
    
//    func ReloadRootForRTL() {
//        // Reload the root view controller
//           let storyboard = UIStoryboard(name: "Main", bundle: nil)
//           let newRootVC = storyboard.instantiateInitialViewController()
//           UIApplication.shared.windows.first?.rootViewController = newRootVC
//    }
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
