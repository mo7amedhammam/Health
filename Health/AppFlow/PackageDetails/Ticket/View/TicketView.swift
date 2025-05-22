//
//  TicketView.swift
//  Sehaty
//
//  Created by mohamed hammam on 22/05/2025.
//

import SwiftUI

struct TicketView: View {
    @StateObject var viewmodel = TicketViewModel()
    
    var body: some View {
        VStack {
            TitleBar(title: "ticket_confirm_title",hasbackBtn: true)

            ScrollView {
                ZStack {
                    //                        Image(.ticketBG)
                    //                            .resizable()
                    //                        //                    .aspectRatio(contentMode: .fill)
                    //                            .scaledToFill()
                    //                            .padding(.top)
                    //                            .frame(width: UIScreen.main.bounds.width - 25,height: gm.size.height, alignment: .center)
                    //
                    //                            .cardStyle(backgroundColor: .clear,cornerRadius: 5,shadowOpacity:0.06)
                    
                    
                    VStack{
                        Image(.logo)
                            .resizable()
                            .frame(width: 108, height: 75, alignment: .center)
                        
                        
                        VStack{
                            Image(.giftBox)
                                .resizable()
                                .frame(width: 36, height: 32, alignment: .center)
                            
                            HStack(alignment: .center, spacing: 0){
                                Text(" ------- ")

                                Text("confirm_Pack_data".localized)
                                    .padding(5)
                                    .padding(.horizontal,3)
                                    .background{
                                        Color(.bgPurple)
                                    }

                                Text(" ------- ".localized)

                            }
                            .font(.semiBold(size: 16))
                            .foregroundStyle(Color(.main))

                            let packageData = viewmodel.ticketData?.packageData ?? .init()
//                            ?? .init(packageData:PackageData(packageID: 0, packageName: "packageName", mainCategoryName: "mainCategoryName", categoryName: "categoryName", sessionCount: 3, duration: 40, priceBeforeDiscount: 90, discount: 20, priceAfterDiscount: 70 )
                                VStack(alignment:.leading,spacing: 8){
                                    
                                    Text("pack_Name".localized)
                                        .font(.regular(size: 14))
                                        .foregroundStyle(Color(.secondary))
                                    
                                    Text(packageData.packageName ?? "pack_Name".localized )
                                        .font(.semiBold(size: 15))
                                        .foregroundStyle(Color(.main))
                                    
                                    HStack(alignment: .center,spacing: 5){
                                        Text( packageData.categoryName ?? "category_Name".localized)
                                        Circle().fill(Color(.white))
                                            .frame(width: 4, height: 4)
                                        Text(packageData.mainCategoryName ?? "صحة عامة")
                                    }
                                    .font(.regular(size: 12))
                                    .foregroundStyle(Color(.secondary))

                                    // Title
                                    HStack (spacing:0){
                                        Image(.newconversationicon)
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 16, height: 9)
                                            .foregroundStyle(Color(.secondaryMain))
                                        
                                        ( Text(" \(packageData.sessionCount ?? 0) " )
                                            .font(.semiBold(size: 16)) + Text( "sessions".localized)
                                            .font(.regular(size: 10)))
                                        
                                        Text(" - " + "sessions_Duration".localized)
                                            .font(.regular(size: 10))
                                        
                                        Text(" \(packageData.duration ?? 0) " + "Minute_".localized)
                                            .font(.regular(size: 10))
                                        
                                    }
                                    .foregroundStyle(Color(.main))
                                    
                                    Text("معاد أول سيشن".localized + " : ")
                                        .font(.regular(size: 14))
                                        .foregroundStyle(Color(.secondary))
                                    
                                    HStack{
                                        ( Text("day ")
                                            .font(.semiBold(size: 14))
                                          
                                          + Text( "sessions".localized)
                                            .font(.regular(size: 12)))
                                        .foregroundStyle(Color(.main))
                                        Spacer()
                                        
                                        ( Text("3:00 pm" + " - ") + Text( "3:00 pm".localized))
                                        font(.regular(size: 12))
                                        .foregroundStyle(Color(.secondary))
                                        
                                    }
                                        Text("*سيقوم الدكتور  بتحديد مواعيد باقي السيشنز".localized)
                                            .font(.medium(size: 10))
                                            .foregroundStyle(Color(.secondary))
                                        
                                    

                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

//                            }else{
//                                    // no package data
//                                }
                        }
                        .padding(.vertical)
                        
                        
                        VStack {
                            Text("Add_Copon".localized)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.semiBold(size: 16))
                                .foregroundStyle(Color(.main))
                            
                            Spacer()
                        }
                        .frame(height:215)
//                        .padding(.horizontal,10)
                        
                        Spacer()
                    }
                    .padding(30)
                }
                .padding(.top)
                .background{
                    TicketShape(cutoutPosition: 0.75)
                        .fill(Color.white)
//                            .frame(height: 200)
                        .shadow(radius: 5)
                        .padding()
                }
                    
                    
                }
            
        }
    }
}

#Preview {
    TicketView()
}

struct TicketShape: Shape {
    /// The vertical offset (0 to 1) where the cutout appears vertically
    var cutoutPosition: CGFloat = 0.5 // 0.0 = top, 1.0 = bottom
    var cutoutRadius: CGFloat = 10
    var cornerRadius: CGFloat = 16

    func path(in rect: CGRect) -> Path {
        let cutoutY = rect.minY + rect.height * cutoutPosition
        var path = Path()

        // Start at top-left corner
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))

        // Top edge
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(0),
                    clockwise: false)

        // Right edge up to cutout
        path.addLine(to: CGPoint(x: rect.maxX, y: cutoutY - cutoutRadius))
        path.addArc(center: CGPoint(x: rect.maxX, y: cutoutY),
                    radius: cutoutRadius,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(90),
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))

        // Bottom-right corner
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)

        // Bottom edge
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false)

        // Left edge up to cutout
        path.addLine(to: CGPoint(x: rect.minX, y: cutoutY + cutoutRadius))
        path.addArc(center: CGPoint(x: rect.minX, y: cutoutY),
                    radius: cutoutRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(-90),
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

        // Top-left corner
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)

        return path
    }
}

struct TicketCardView: View {
    @State private var cutoutPosition: CGFloat = 0.5

    var body: some View {
        VStack {
            TicketShape(cutoutPosition: cutoutPosition)
                .fill(Color.white)
                .frame(height: 200)
                .shadow(radius: 5)
                .padding()

            Slider(value: $cutoutPosition, in: 0...1)
                .padding()
        }
        .background(Color.gray.opacity(0.2))
    }
}

#Preview {
    TicketCardView()
}
