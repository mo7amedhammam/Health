//
//  fontsenum.swift
//  Sehaty
//
//  Created by mohamed hammam on 03/04/2025.
//

import SwiftUI

enum fontsenum:String{
//    case extraThinEn = "LamaSans-ExtraLight"
//    case extraThinAr = "Sora-Bold"
//    case extraThinItalicEn = "LamaSans-ThinItalic"
//    case extraThinItalicAr = "ArbFONTS-LamaSans-ExtraLightItalic"

//    case thinEn = "LamaSans-Thin"
//    case thinAr = "ArbFONTS-LamaSans-Light"
//    case thinItalicEn = "LamaSans-ThinItalic"
//    case thinItalicAr = "ArbFONTS-LamaSans-LightItalic"
//
//    case regularEn = "LamaSans-Regular" // available
//    case regularAr = "ArbFONTS-LamaSans-Medium"
//    case regularItalicEn = "LamaSans-RegularItalic"
//    case regularItalicAr = "ArbFONTS-LamaSans-MediumItalic"
//
//    case medium = "LamaSans-Medium" // available
//    
////    case semiBoldEn = "Sora-Bold"
//    case semiBoldAr = "ArbFONTS-LamaSans-SemiBold"
////    case semiBoldItalicEn = "Sora-Bold"
//    case semiBoldItalicAr = "ArbFONTS-LamaSans-SemiBoldItalic"
//
//    case boldEn = "LamaSans-Bold" // availabel
//    case boldAr = "ArbFONTS-LamaSans-Black"
//    case boldItalicEn = "LamaSans-BoldItalic"
//    case boldItalicAr = "ArbFONTS-LamaSans-BlackItalic"
//    
////    case extrBoldEn = "LamaSans-Bold"
//    case extraBoldAr = "ArbFONTS-LamaSans-ExtraBold"
////    case extraBoldItalicEn = "LamaSans-BoldItalic"
//    case extraBoldItalicAr = "ArbFONTS-LamaSans-ExtraBoldItalic"
    
    
//    MARK: ==== available fonts are =======
    case lignt = "LamaSans-Light" // available
    case regular = "LamaSans-Regular" // available
    case medium = "LamaSans-Medium" // available
    case semiBold = "LamaSans-SemiBold" // availabel
    case bold = "LamaSans-Bold" // availabel

}

extension Font {
//    static func extraLight( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.extraThinEn.rawValue:fontsenum.extraThinEn.rawValue, size: size)
//    }
//    static func extraLightItalic( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.thinItalicEn.rawValue:fontsenum.thinItalicEn.rawValue, size: size)
//    }
//    
//    static func light( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.thinEn.rawValue:fontsenum.thinEn.rawValue, size: size)
//    }
//    static func lightItalic( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.thinItalicEn.rawValue:fontsenum.thinItalicEn.rawValue, size: size)
//    }
//    
//    static func regular( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.regularEn.rawValue:fontsenum.regularEn.rawValue, size: size)
//    }
//    static func regularItalic( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.regularItalicEn.rawValue:fontsenum.regularItalicEn.rawValue, size: size)
//    }
//    
//    static func semiBold( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.regularEn.rawValue:fontsenum.regularEn.rawValue, size: size)
//    }
//    static func semiBoldItalic( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.regularItalicEn.rawValue:fontsenum.regularItalicEn.rawValue, size: size)
//    }
//    
//    static func bold( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.boldEn.rawValue:fontsenum.boldEn.rawValue, size: size)
//    }
//    static func boldItalic( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.boldItalicEn.rawValue:fontsenum.boldItalicEn.rawValue, size: size)
//    }
//    
//    static func extraBold( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.boldEn.rawValue:fontsenum.boldEn.rawValue, size: size)
//    }
//    static func extraBoldItalic( size: CGFloat) -> Self {
//        @State var language = LocalizationManager.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.boldItalicEn.rawValue:fontsenum.boldItalicEn.rawValue, size: size)
//    }
    
    
    
//    MARK: --- available ---
    static func light( size: CGFloat) -> Self {
        @State var language = LocalizationManager.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.lignt.rawValue:fontsenum.lignt.rawValue, size: size)
    }
    static func regular( size: CGFloat) -> Self {
        @State var language = LocalizationManager.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.regular.rawValue:fontsenum.regular.rawValue, size: size)
    }
    static func medium( size: CGFloat) -> Self {
        @State var language = LocalizationManager.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.medium.rawValue:fontsenum.medium.rawValue, size: size)
    }
    static func semiBold( size: CGFloat) -> Self {
        @State var language = LocalizationManager.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.semiBold.rawValue:fontsenum.semiBold.rawValue, size: size)
    }
    static func bold( size: CGFloat) -> Self {
        @State var language = LocalizationManager.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.bold.rawValue:fontsenum.bold.rawValue, size: size)
    }
    
}
