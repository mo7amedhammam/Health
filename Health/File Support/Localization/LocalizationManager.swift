////
////  LocalizationManager.swift
////  Sehaty
////
////  Created by mohamed hammam on 13/03/2025.
////
//
//import Foundation
//
//class LocalizationManager : ObservableObject{
//    static let shared = LocalizationManager()
//    
//    private let queue = DispatchQueue(label: "com.yourapp.localization", attributes: .concurrent)
//    private var translations: [String: String] = [:]
//    @Published var currentLanguage: String? = ""  // Default language
//    
//    private init() {}
//    
//    func setLanguage(_ language: String, completion: @escaping (Bool) -> Void) {
//        print("setLanguage",language.lowercased())
//            currentLanguage = language.lowercased()
//            //        UIView.appearance().semanticContentAttribute = language == "ar" ? .forceRightToLeft:.forceLeftToRight
//            Helper.shared.setLanguage(currentLanguage: language.lowercased())
//            Helper.shared.languageSelected(opened: true)
////            fetchTranslations { success in
////                completion(success)
////            }
//    }
//    
//    func localizedString(forKey key: String) -> String {
//        queue.sync {
//            return translations[key.lowercased()] ?? NSLocalizedString(key.lowercased(), comment: "")
//        }
//    }
//    
//    private func cacheTranslations(_ translations: [String: String], for language: String) {
//        queue.async(flags: .barrier) {
//            UserDefaults.standard.set(translations, forKey: "cachedTranslations_\(language.lowercased())")
//        }
//    }
//
//    private func loadCachedTranslations(for language: String) -> [String: String]? {
//        queue.sync {
//            return UserDefaults.standard.dictionary(forKey: "cachedTranslations_\(language.lowercased())") as? [String: String]
//        }
//    }
//    
////    private func loadDefaultTranslations() -> [String: String] {
////        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "strings"),
////              let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] else {
////            return [:]
////        }
////        return dictionary
////    }
//    
//    private func loadDefaultTranslations(for language: String) -> [String: String] {
////        UserDefaults.standard.removeObject(forKey: "cachedTranslations_\(language)")
//        if let cachedTranslations = loadCachedTranslations(for: language.lowercased()){
//            self.updateTranslations(cachedTranslations)
////            completion(true)
//            return cachedTranslations
//        }else{
//            
//            // 1. Try to load the specific language file first
//            if let path = Bundle.main.path(forResource: "ar", ofType: "lproj"),
//               let bundle = Bundle(path: path),
//               let path = bundle.path(forResource: "Localizable", ofType: "strings"),
//               let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] {
//                return dictionary
//            }
//            
//            // 2. Fall back to base localization (English)
//            guard let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
//                  let bundle = Bundle(path: path),
//                  let path = bundle.path(forResource: "Localizable", ofType: "strings"),
//                  let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] else {
//                return [:] // Final fallback
//            }
//            
//            return dictionary
//        }
//    }
//    
//     func fetchTranslations(completion: @escaping (Bool) -> Void) {
//
//        let urlString = "https://alnada-devmrsapi.azurewebsites.net/api/\(currentLanguage ?? "ar")/Translations/GetTranslationFile/ios 66"
//        
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            self.updateTranslations(self.loadDefaultTranslations(for: currentLanguage ?? "ar"))
//
//            completion(false)
//            return
//        }
//        
//         URLSession.shared.dataTask(with: url) { [self] data, response, error in
//            if let error = error {
//                print("Error fetching translations: \(error.localizedDescription)")
//                self.updateTranslations(self.loadDefaultTranslations(for: currentLanguage ?? "ar"))
//
//                completion(false)
//                return
//            }
//            
//            guard let data = data else {
//                print("No data received")
//                self.updateTranslations(self.loadDefaultTranslations(for: currentLanguage ?? "ar"))
//
//                completion(false)
//                return
//            }
//            
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
//                    print("Localization updated for : \(self.currentLanguage ?? "ar")")
////                    self.updateTranslations(json)
////                    self.cacheTranslations(json, for: self.currentLanguage ?? "ar")
//                    completion(true)
//                } else {
//                    print("Invalid JSON format")
//                    self.updateTranslations(self.loadDefaultTranslations(for: currentLanguage ?? "ar"))
//
//                    completion(false)
//                }
//            } catch {
//                print("JSON parsing error: \(error.localizedDescription)")
////                self.updateTranslations(self.loadDefaultTranslations())
//                self.updateTranslations(self.loadDefaultTranslations(for: currentLanguage ?? "ar"))
//
//                completion(false)
//            }
//        }.resume()
//    }
//    
//    private func updateTranslations(_ newTranslations: [String: String]) {
//        queue.async(flags: .barrier) {
//            print("newTranslations",newTranslations)
//            self.translations = newTranslations
//        }
//    }
//    
////    func ReloadRootForRTL() {
////        // Reload the root view controller
////           let storyboard = UIStoryboard(name: "Main", bundle: nil)
////           let newRootVC = storyboard.instantiateInitialViewController()
////           UIApplication.shared.windows.first?.rootViewController = newRootVC
////    }
//}
//
//import Foundation
//
//extension String {
//    var localized: String {
//        return LocalizationManager.shared.localizedString(forKey: self)
//    }
//    
//    func localized(with arguments: CVarArg...) -> String {
//        return String(format: self.localized, arguments: arguments)
//    }
//}
//
////
////import SwiftUI
//////MARK:  --- ViewModifier to update layout Direction RTL ---
////struct LocalizationViewModifier: ViewModifier {
////    @ObservedObject var localizeHelper = LocalizationManager.shared
////    public func body(content: Content) -> some View {
////        content
////            .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage?.lowercased() ?? "ar"))
////            .environment(\.layoutDirection, localizeHelper.currentLanguage?.lowercased() == "ar" ? .rightToLeft : .leftToRight)
////    }
////}
//////MARK:  --- ViewModifier to update layout Direction RTL ---
////struct ReversedLocalizationViewModifier: ViewModifier {
////    @ObservedObject var localizeHelper = LocalizationManager.shared
////    public func body(content: Content) -> some View {
////        content
////            .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage?.lowercased() ?? "ar"))
////            .environment(\.layoutDirection, localizeHelper.currentLanguage?.lowercased() == "en" ? .leftToRight : .rightToLeft)
////    }
////}
////
////// --- View Extension to apply the modifier ---
////extension View {
////    public func localizeView() -> some View {
////        modifier(LocalizationViewModifier())
////    }
////    public func reversLocalizeView() -> some View {
////        modifier(ReversedLocalizationViewModifier())
////    }
////}
//
//
//import SwiftUI
//
//// MARK: --- Unified ViewModifier for Layout Direction and Locale ---
//struct AppLocalizationViewModifier: ViewModifier {
//    @ObservedObject var localizeHelper = LocalizationManager.shared
//    var reverse: Bool = false
//    
//    public func body(content: Content) -> some View {
//        let lang = localizeHelper.currentLanguage?.lowercased() ?? "ar"
//        let direction: LayoutDirection = (lang == "ar") != reverse ? .rightToLeft : .leftToRight
//        
//        return content
//            .environment(\.locale, Locale(identifier: lang))
//            .environment(\.layoutDirection, direction)
//    }
//}
//
//// --- View Extension to apply the modifier ---
//extension View {
//    public func localizeView(reverse: Bool = false) -> some View {
//        modifier(AppLocalizationViewModifier(reverse: reverse))
//    }
//}





import Foundation
import SwiftUI

final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @Published var currentLanguage: String {
        didSet {
            saveLanguage()
            updateUIKitDirection()
        }
    }

    private let languageKey = "AppLanguage"
    private let cacheKeyPrefix = "cachedTranslations_"

    private var remoteTranslations: [String: String] = [:]

    var layoutDirection: LayoutDirection {
        currentLanguage == "ar" ? .rightToLeft : .leftToRight
    }

    var locale: Locale {
        Locale(identifier: currentLanguage)
    }

    private init() {
        let saved = UserDefaults.standard.string(forKey: languageKey)
        self.currentLanguage = saved ?? Locale.current.languageCode ?? "en"
        loadCachedTranslations()
    }

    func changeLanguage(to language: String, completion: (() -> Void)? = nil) {
        guard language != currentLanguage else {
            completion?()
            return
        }
        Helper.shared.setLanguage(currentLanguage: language)
        currentLanguage = language.lowercased()
        fetchTranslationsFromServer { [weak self ]_ in
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    func localizedString(for key: String) -> String {
        if let remote = remoteTranslations[key] {
            return remote
        }

        if let cached = loadTranslationsFromCache()[key] {
            return cached
        }

        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: bundle, comment: "")
        }

        return NSLocalizedString(key, comment: "")
    }

    // MARK: - Private

    private func saveLanguage() {
        UserDefaults.standard.set(currentLanguage, forKey: languageKey)
    }

    private func cacheTranslations(_ translations: [String: String]) {
        UserDefaults.standard.set(translations, forKey: cacheKeyPrefix + currentLanguage)
    }

    private func loadTranslationsFromCache() -> [String: String] {
        UserDefaults.standard.dictionary(forKey: cacheKeyPrefix + currentLanguage) as? [String: String] ?? [:]
    }

    private func loadCachedTranslations() {
        remoteTranslations = loadTranslationsFromCache()
    }

    private func fetchTranslationsFromServer(completion: @escaping (Bool) -> Void) {
        let urlStr = "https://alnada-devmrsapi.azurewebsites.net/api/\(currentLanguage)/Translations/GetTranslationFile/ios"
        guard let url = URL(string: urlStr) else {
            print("❌ Invalid translation URL")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Fetch translation error: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
                print("❌ Invalid translation JSON or empty")
                completion(false)
                return
            }

            DispatchQueue.main.async {
                self.remoteTranslations = json
                self.cacheTranslations(json)
                completion(true)
            }

        }.resume()
    }

    private func updateUIKitDirection() {
        let semantic: UISemanticContentAttribute = currentLanguage == "ar" ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = semantic
    }
}


extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }

    func localized(with args: CVarArg...) -> String {
        return String(format: self.localized, arguments: args)
    }
}

struct LocalizedEnvironmentModifier: ViewModifier {
    @ObservedObject var manager = LocalizationManager.shared
    var reverse: Bool = false

    func body(content: Content) -> some View {
        let direction: LayoutDirection = (manager.currentLanguage == "ar") != reverse ? .rightToLeft : .leftToRight
        content
            .environment(\.locale, manager.locale)
            .environment(\.layoutDirection, direction)
    }
}

extension View {
    func localizeView(reverse: Bool = false) -> some View {
        self.modifier(LocalizedEnvironmentModifier(reverse: reverse))
    }
}

//func updateUIKitDirection() {
//    let semantic: UISemanticContentAttribute = LocalizationManager.shared.currentLanguage == "ar" ? .forceRightToLeft : .forceLeftToRight
//    UIView.appearance().semanticContentAttribute = semantic
//}

//func changeLanguage(to lang: String) {
//    LocalizationManager.shared.toggleLanguage(to: lang)
//    Helper.shared.setLanguage(currentLanguage: lang)
//    updateUIKitDirection()
//
//    // Restart root view to apply immediately
////    guard let window = UIApplication.shared.windows.first else { return }
////    window.rootViewController = UIHostingController(rootView: RootView().localizeView())
////    window.makeKeyAndVisible()
//}
