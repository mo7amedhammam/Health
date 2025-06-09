//
//  ProfileView.swift
//  Sehaty
//
//  Created by mohamed hammam on 03/06/2025.
//

import SwiftUI

// MARK: - Custom Colors (Replace with your actual asset catalog or theme)
extension Color {
    static let sehatyPrimary = Color(red: 0.96, green: 0.29, blue: 0.52) // Example Pink
    static let sehatyLightGray = Color(red: 0.95, green: 0.95, blue: 0.95) // Example Light Gray background
    static let sehatyTextGray = Color(red: 0.4, green: 0.4, blue: 0.4) // Example Medium Gray for text
    static let sehatyDarkBlue = Color(red: 0.1, green: 0.1, blue: 0.4) // Example dark blue for title
}


// MARK: - ProfileView (The main ScrollView)
struct ProfileView: View {
    var body: some View {
        // Using NavigationView for potential navigation to sub-views
        NavigationView {
            ScrollView {
                VStack(spacing: 0) { // Set spacing to 0 and add specific padding
                    // Custom Title Bar (Placeholder - replace with your actual TitleBar if available)
                    HStack {
                        Spacer()
                        Text("ملفي الشخصي") // Placeholder for "home_navtitle"
                            .font(.headline)
                            .foregroundColor(.sehatyDarkBlue) // Example color
                        Spacer()
                    }
                    .padding(.vertical) // Adjust padding as needed
                    .background(Color.white) // Or your app's nav bar background
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1) // Optional shadow
                    
                    // Profile Header Section
                    VStack(spacing: 8) {
                        Image("sehaty_logo_with_text") // Replace with your actual image asset
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80) // Adjust size as needed
                            .clipShape(Circle()) // Or any other shape if your logo is not circular
                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        
                        Text("Mohamed")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.black)
                        
                        Text("0100000004")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 20) // Padding for the entire profile header
                    .frame(maxWidth: .infinity)
                    .background(Color.sehatyLightGray) // Light gray background for this section
                    
                    // Spacer before menu items
                    Spacer().frame(height: 16)
                    
                    // Menu Items Section
                    VStack(spacing: 8) { // Spacing between menu items
                        MenuItemView(title: "اشتراكاتي", systemIconName: "square.stack.fill", iconBackgroundColor: Color.sehatyPrimary)
                        MenuItemView(title: "نصائح طبية", systemIconName: "heart.text.square.fill", iconBackgroundColor: Color(red: 0.3, green: 0.6, blue: 0.9)) // Example blue
                        MenuItemView(title: "Inbody", systemIconName: "waveform.path.ecg", iconBackgroundColor: Color(red: 0.9, green: 0.7, blue: 0.2)) // Example yellow
                    }
                    
                    // Spacer before settings group
                    Spacer().frame(height: 20)
                    
                    VStack(spacing: 8) {
                        MenuItemView(title: "الإعدادات", systemIconName: "gearshape.fill", iconBackgroundColor: Color.gray) // Example gray
                        MenuItemView(title: "تغيير كلمة المرور", systemIconName: "lock.fill", iconBackgroundColor: Color(red: 0.8, green: 0.4, blue: 0.7)) // Example purple
                        MenuItemView(title: "تغيير اللغة", systemIconName: "globe", iconBackgroundColor: Color(red: 0.2, green: 0.7, blue: 0.5)) // Example green
                        MenuItemView(title: "الحماية والخصوصية", systemIconName: "shield.lefthalf.filled", iconBackgroundColor: Color(red: 0.9, green: 0.5, blue: 0.3)) // Example orange
                        MenuItemView(title: "المساعدة", systemIconName: "questionmark.circle.fill", iconBackgroundColor: Color(red: 0.6, green: 0.3, blue: 0.8)) // Example darker purple
                        MenuItemView(title: "الشروط والأحكام", systemIconName: "doc.text.fill", iconBackgroundColor: Color(red: 0.2, green: 0.5, blue: 0.8)) // Example darker blue
                    }
                    
                    // Spacer before sign out button
                    Spacer().frame(height: 30)
                    
                    // Sign Out Button
                    Button(action: {
                        // Action for sign out
                        print("Sign Out Tapped")
                    }) {
                        Label("تسجيل الخروج", systemImage: "arrow.right.square.fill") // Using a placeholder SF Symbol
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(Color.sehatyPrimary)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer() // Pushes content up if scroll view content is short
                }
            }
            .navigationBarHidden(true) // Hide NavigationView's default bar
            .background(Color.sehatyLightGray.ignoresSafeArea()) // Apply background color to the whole screen
        }
    }
}

// MARK: - Preview Provider
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

// MARK: - Menu Item View
struct MenuItemView: View {
    let title: String
    let systemIconName: String // Using SF Symbols for placeholder icons
    let iconBackgroundColor: Color
    
    var body: some View {
        HStack {
            // Icon
            Image(systemName: systemIconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                .padding(8)
                .background(iconBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 8)) // Slightly rounded corners
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            
            Spacer()
            
            // Disclosure indicator (Arabic style)
            Image(systemName: "chevron.left") // Looks like a left chevron in the screenshot
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8) // Padding for each row
        .background(Color.white)
        .cornerRadius(10) // Rounded corners for the entire row
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2) // Subtle shadow
        .padding(.horizontal, 16) // Padding from screen edges
        .padding(.vertical, 4) // Spacing between rows
    }
}
