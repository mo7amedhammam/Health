

//
//  CustomProgressView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI

struct HudView2: View {
    @Binding var isShowing: Bool?
    var text: String?
    var size: CGSize? = CGSize(width: 120,height: 120)

    var body: some View {
        ZStack {
            if isShowing ?? false{
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    ActivityIndicatorView1(style: .medium, color: .white, size: CGSize(width: 200, height: 200))
                        .scaleEffect(1.3, anchor: .center)
                    if let labelText = text {
                        Text(labelText)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: size?.width,height: size?.height)
                    .background(Color.black.opacity(0.9))
                    .cornerRadius(8)
            }
        }
    }
}

struct ActivityIndicatorView1: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style
    let color: UIColor
    let size: CGSize

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.color = color
        view.frame = CGRect(origin: .zero, size: size)
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}


//#Preview{
//    //    HudView(isShowing: .constant(true), text: "text",size: CGSize(width: 120, height: 120))
//    HudView(text: "text",size: CGSize(width: 120, height: 120))
//
//}

extension View {
    func showHud(isShowing: Binding<Bool?>, text: String? = nil) -> some View {
       return self.modifier(HUDModifier(isPresented: isShowing, text: text))
        
//        return self.overlay(HudView(isShowing: isShowing, text: text))
    }
    func showHud2(isShowing: Binding<Bool?>, text: String? = nil) -> some View {
        return self.overlay(HudView2(isShowing: isShowing, text: text))
    }
}



//struct HudView1: View {
//    @Binding var isShowing: Bool  // Changed from Bool? to Bool
//    var text: String?
//    var size: CGSize = CGSize(width: 120, height: 120)  // Made non-optional
//
//    var body: some View {
//        ZStack {
//            if isShowing {  // Removed optional unwrapping
//                Color.black.opacity(0.3)
//                    .edgesIgnoringSafeArea(.all)
//                    .zIndex(9999)  // Ensure it appears above everything
//
//                VStack {
//                    ActivityIndicatorView(style: .large, color: .white, size: CGSize(width: 200, height: 200))
//                        .scaleEffect(1.3, anchor: .center)
//                    
//                    if let labelText = text {
//                        Text(labelText)
//                            .font(.system(size: 14))
//                            .foregroundColor(.white)
//                    }
//                }
//                .frame(width: size.width, height: size.height)  // Removed optional chaining
//                .background(Color.black.opacity(0.9))
//                .cornerRadius(8)
//                .zIndex(10000)  // Higher than the background
//            }
//        }
//        .animation(.default, value: isShowing)  // Add smooth appearance
//    }
//}

//extension View {
//    func showHud1(isShowing: Binding<Bool>, text: String? = nil) -> some View {
//        return self.overlay(
//            HudView1(isShowing: isShowing, text: text)
//                .allowsHitTesting(isShowing.wrappedValue)  // Block interactions when visible
//        )
//    }
//}


//--------------
import UIKit

final class HUDWindowManager {
    static let shared = HUDWindowManager()
    
    private var hudWindow: UIWindow?
    
    func showHUD(text: String?) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return
        }
        
        // Create a new transparent window
        hudWindow = UIWindow(windowScene: windowScene)
        hudWindow?.windowLevel = .alert + 1  // Above everything
        hudWindow?.backgroundColor = .clear  // Critical: Makes window transparent
        hudWindow?.rootViewController = {
            let controller = UIHostingController(rootView: HudView(text: text))
            controller.view.backgroundColor = .clear  // Makes SwiftUI view transparent
            return controller
        }()
        hudWindow?.makeKeyAndVisible()
    }
    
    func hideHUD() {
        hudWindow?.isHidden = true
        hudWindow = nil
    }
}

struct HudView: View {
    var text: String?
    var size: CGSize = CGSize(width: 120, height: 120)
    
    var body: some View {
        
        ZStack {
            // Semi-transparent background (optional)
            Color.black.opacity(0.01)
                .ignoresSafeArea()
                .onTapGesture {
                    // Optionally dismiss on tap
                    HUDWindowManager.shared.hideHUD()
                }

        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            if let text = text {
                Text(text)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
        }
        .frame(width: size.width, height: size.height)
        .background(Color.black.opacity(0.8))
        .cornerRadius(12)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
    }
}
struct HUDModifier: ViewModifier {
    @Binding var isPresented: Bool?
    let text: String?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented ?? false) { newValue in
                if newValue {
                    HUDWindowManager.shared.showHUD(text: text)
                } else {
                    HUDWindowManager.shared.hideHUD()
                }
            }
    }
}

//extension View {
//    func hud(isPresented: Binding<Bool>, text: String? = nil) -> some View {
//        self.modifier(HUDModifier(isPresented: isPresented, text: text))
//    }
//}
