//
//  NewTabView.swift
//  Sehaty
//
//  Created by mohamed hammam on 15/04/2025.
//

import SwiftUI

struct NewTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        CustomTabView(
            selectedIndex: $selectedTab,
            tabItems: [
                TabItem(image: "tab1", title: "Home", selectedImage: "tab1selected"),
                TabItem(image: "tab2", title: "Health", selectedImage: "tab2selected"),
                TabItem(image: "tab3", title: "Add", selectedImage: "tab3selected"),
                TabItem(image: "tab4", title: "Stats", selectedImage: "tab4selected"),
                TabItem(image: "tab5", title: "Profile", selectedImage: "tab5selected")
            ],
            cornerRadius: 30,
            backgroundColor: .white
        ) {
            // Your main content here
            Group {
                switch selectedTab {
                case 0: NewHomeView()
                case 1: Color.green.opacity(0.1).ignoresSafeArea()
                case 2: Color.blue.opacity(0.1).ignoresSafeArea()
                case 3: Color.orange.opacity(0.1).ignoresSafeArea()
                case 4: Color.purple.opacity(0.1).ignoresSafeArea()
                default: EmptyView()
                }
            }
        }
    }
}

#Preview{
    NewTabView()
}

//MARK: ---  tab items ---
// Tab Item Data Model
struct TabItem {
    let image: String
    let selectedImage: String? // Make this optional
    let title: String
    
    // Convenience init for when selectedImage is the same as image
    init(image: String, title: String, selectedImage: String? = nil) {
        self.image = image
        self.title = title
        self.selectedImage = selectedImage
    }
}

struct CustomTabView<Content: View>: View {
    @Binding var selectedIndex: Int
    let tabItems: [TabItem]
    let content: Content
    let cornerRadius: CGFloat
    let backgroundColor: Color
    
    init(selectedIndex: Binding<Int>,
         tabItems: [TabItem],
         cornerRadius: CGFloat = 30,
         backgroundColor: Color = .white,
         centerButtonImage: String = "plus",
         centerButtonAction: (() -> Void)? = nil,
         @ViewBuilder content: () -> Content) {
        self._selectedIndex = selectedIndex
        self.tabItems = tabItems
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Main content
            content
                .transaction { $0.animation = nil }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom tab bar with curved background
            VStack {
                Spacer()
                
                ZStack(alignment: .bottom) {
                    // Main tab bar background with cutout for center button
                    TabBarBackground(
                        cornerRadius: cornerRadius,
                        backgroundColor: backgroundColor,
                        centerButtonSize: 60
                    )
                    .frame(height: 80)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                    
                    // Tab items
                    HStack(spacing: 0) {
                        ForEach(0..<tabItems.count, id: \.self) { index in
                            let isCenter = index == tabItems.count / 2 && tabItems.count % 2 == 1
                            
                            let button = TabBarButton(
                                image: tabItems[index].image,
                                selectedImage: tabItems[index].selectedImage,
                                title: tabItems[index].title,
                                isSelected: selectedIndex == index,
                                action: {
                                    var transaction = Transaction()
                                    transaction.disablesAnimations = true
                                    withTransaction(transaction) {
                                        selectedIndex = index
                                    }
                                }
                            )
                                                      
                            if isCenter {
                                button.offset(y: -35)
                            } else {
                                button
                            }
                        }
                    }
                    .frame(height: 80)

                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct TabBarButton: View {
    let image: String
    let selectedImage: String? // Add this for selected state image
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                // Use selectedImage if provided and button is selected
                Image(isSelected ? (selectedImage ?? image) : image)
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


//MARK: --- tabView Shape ---

// Custom background shape with center curve
struct TabBarBackground: View {
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let centerButtonSize: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(backgroundColor)
            .mask(
                TabBarShape(
                    cornerRadius: cornerRadius,
                    centerButtonSize: centerButtonSize
                )
                .fill(style: FillStyle(eoFill: true))
            )
    }
}

// Custom shape for the tab bar with center curve
struct TabBarShape: Shape {
    let cornerRadius: CGFloat
    let centerButtonSize: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let centerX = rect.midX
        let buttonRadius = (-centerButtonSize/2) - 6
        let curveDepth: CGFloat = -40
        
        // Start from top-left
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // Line to top-left rounded corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        
        // Top-left rounded corner
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 270),
            clockwise: false
        )
        
        // Line to before center curve (left side)
        path.addLine(to: CGPoint(x: centerX - buttonRadius , y: rect.minY))
        
        // Center curve (left side)
        path.addCurve(
            to: CGPoint(x: centerX, y: rect.minY - curveDepth),
            control1: CGPoint(x: centerX - buttonRadius, y: rect.minY),
            control2: CGPoint(x: centerX - buttonRadius, y: rect.minY - curveDepth)
        )
        
        // Center curve (right side)
        path.addCurve(
            to: CGPoint(x: centerX + buttonRadius, y: rect.minY),
            control1: CGPoint(x: centerX + buttonRadius, y: rect.minY - curveDepth),
            control2: CGPoint(x: centerX + buttonRadius, y: rect.minY)
        )
        
        // Line to top-right rounded corner
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        
        // Top-right rounded corner
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 270),
            endAngle: Angle(degrees: 0),
            clockwise: false
        )
        
        // Line to bottom-right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        // Line to bottom-left
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path
    }
}
