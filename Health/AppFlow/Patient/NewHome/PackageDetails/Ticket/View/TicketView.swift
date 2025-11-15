//
//  TicketView.swift
//  Sehaty
//
//  Created by mohamed hammam on 22/05/2025.
//

import SwiftUI

struct TicketView: View {
    @StateObject var viewmodel = TicketViewModel()
    //    var day:AvailableDayM?
    var ticketData:TicketM?
    var parameters:[String:Any]?
    
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
                                DashedLine(dash:[3,1])
                                    .frame(width:40)
                                
                                Text("confirm_Package_data".localized)
                                    .padding(5)
                                    .padding(.horizontal,3)
                                    .background{
                                        Color(.bgPurple)
                                    }
                                    .font(.semiBold(size: 22))
                                
                                DashedLine(dash:[3,1])
                                    .frame(width:40)
                            }
                            .foregroundStyle(Color(.main))
                            
                            
                            let packageData = viewmodel.ticketData?.packageData ?? nil
                            let bookedTiming = viewmodel.ticketData?.bookedTimming ?? nil
                            VStack(alignment:.leading,spacing: 10){
                                
                                //                                Text("pack_Name".localized)
                                //                                    .font(.regular(size: 14))
                                //                                    .foregroundStyle(Color(.secondary))
                                
                                Text(packageData?.packageName ?? "pack_Name".localized )
                                    .font(.semiBold(size: 22))
                                    .foregroundStyle(Color(.main))
                                
                                Group{
                                    Text( packageData?.categoryName ?? "category_Name".localized)
                                    //                                    Circle().fill(Color(.secondary))
                                    //                                        .frame(width: 4, height: 4)
                                    Text(packageData?.mainCategoryName ?? "صحة عامة")
                                }
                                .font(.medium(size: 18))
                                .foregroundStyle(Color(.secondary))
                                
                                // Title
                                HStack (spacing:0){
                                    Image(.newconversationicon)
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 16, height: 9)
                                        .foregroundStyle(Color(.secondaryMain))
                                    
                                    ( Text(" \(packageData?.sessionCount ?? 0) " )
                                        .font(.semiBold(size: 16)) + Text( "sessions".localized)
                                        .font(.semiBold(size: 16)))
                                    
                                    Text(" - " + "sessions_Duration".localized)
                                        .font(.regular(size: 12))
                                    
                                    Text(" \(packageData?.duration ?? 0) " + "Minutes".localized)
                                        .font(.regular(size: 12))
                                    
                                }
                                .foregroundStyle(Color(.main))
                                
                                (Text("first_session".localized) + Text(" : "))
                                    .font(.regular(size: 14))
                                    .foregroundStyle(Color(.secondary))
                                
                                HStack{
                                    (Text("\(bookedTiming?.dayName ?? "") ")
                                        .font(.semiBold(size: 16)) + Text((bookedTiming?.date ?? "").ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd"))
                                        .font(.regular(size: 14)))
                                    .foregroundStyle(Color(.main))
                                    
                                    Spacer()
                                    
                                    ( Text("\(bookedTiming?.timefrom ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")) + Text(" - ") + Text("\(bookedTiming?.timeTo ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")))
                                        .font(.regular(size: 14))
                                        .foregroundStyle(Color(.secondary))
                                }
                                
                                Text("sessions_selection_hint".localized)
                                    .font(.medium(size: 10))
                                    .foregroundStyle(Color(.secondary))
                                
                                DashedLine()
                                    .padding(.top)
                                
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            //                            }else{
                            //                                    // no package data
                            //                                }
                        }
                        .padding(.vertical)
                        
                        let doctorData = viewmodel.ticketData?.doctorData ?? nil
                        
                        VStack{
                            Image(.officialDoctorIcon)
                                .resizable()
                                .frame(width: 36, height: 36, alignment: .center)
                            
                            HStack(alignment: .center, spacing: 0){
                                DashedLine(dash:[3,1])
                                    .frame(width:40)
                                
                                Text("confirm_Doctor_data".localized)
                                    .padding(5)
                                    .padding(.horizontal,3)
                                    .background{
                                        Color(.bgPurple)
                                    }
                                    .font(.semiBold(size: 22))
                                
                                DashedLine(dash:[3,1])
                                    .frame(width:40)
                            }
                            .foregroundStyle(Color(.main))
                            
                            VStack(spacing:10){
                                
                                HStack{
                                    Text(doctorData?.doctorName ?? "Doctor_Name_")
                                        .font(.semiBold(size: 22))
                                        .foregroundStyle(Color(.main))
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    //                                    Text(doctorData.doctorName ?? "doc_name".localized)
                                    //                                        .font(.regular(size: 14))
                                    //                                        .foregroundStyle(Color(.secondary))
                                    //                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    HStack(spacing:2) {
                                        Text(doctorData?.nationality ?? "egyption_".localized)
                                            .font(.semiBold(size: 12))
                                            .foregroundStyle(Color(.main))
                                        
                                        
                                        KFImageLoader(url:URL(string:Constants.imagesURL + (doctorData?.flag?.validateSlashs() ?? "")),placeholder: Image("egFlagIcon"), shouldRefetch: false)
                                            .frame(width: 12,height: 12)
                                        
                                        //                                        Image(.egFlagIcon)
                                        //                                            .resizable()
                                        //                                            .frame(width: 12,height:8)
                                        //                                            .scaledToFill()
                                        //                                            .padding(3)
                                    }
                                }
                                
                                HStack{
                                    Text(doctorData?.doctorName ?? "Doctor_Name_")
                                        .font(.semiBold(size: 16))
                                        .foregroundStyle(Color(.main))
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    
                                    HStack(spacing:2) {
                                        Text(doctorData?.speciality ?? "speciality_")
                                            .font(.semiBold(size: 12))
                                            .foregroundStyle(Color(.main))
                                        
                                        //                                            Image(.egFlagIcon)
                                        //                                                .resizable()
                                        //                                                .frame(width: 12,height:8)
                                        //                                                .scaledToFill()
                                        //                                                .padding(3)
                                    }
                                }
                                
                                //                                Text(doctorData.speciality ?? "speciality_")
                                //                                   .font(.medium(size: 10))
                                //                                   .foregroundStyle(Color(.secondary))
                                //                                   .frame(maxWidth: .infinity,alignment:.leading)
                            }
                            
                            DashedLine()
                                .padding(.vertical)
                        }
                        
                        
                        VStack(spacing:15) {
                            Text("Add_Copon".localized)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.bold(size: 22))
                                .foregroundStyle(Color(.main))
                            
                            HStack {
                                HStack(spacing: 8) {
                                    Image("coponIcon")
                                        .resizable()
                                        .frame(width: 12, height: 17)
                                    
                                    TextField("enter_Copon_number".localized, text: $viewmodel.couponeCode)
                                        .font(.regular(size: 16))
                                        .foregroundColor(.mainBlue)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal)
                                .frame(height:50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.mainBlue, lineWidth: 1)
                                )
                                
                                Button(action: {
                                    Task{
                                        await viewmodel.createCustomerPackage(paramters: parameters)
                                    }
                                }){
                                    //
                                    Text("confirm_".localized)
                                        .underline()
                                        .font(.bold(size: 16))
                                        .padding(.horizontal,8)
                                        .frame(height:50)
                                        .padding(.horizontal,10)
                                        .foregroundStyle(Color.white)
                                        .background(Color.mainBlue)
                                    //                                        .horizontalGradientBackground()
                                        .cornerRadius(3)
                                }
                            }
                            
                        }
                        .frame(height:80)
                        .padding(.bottom,8)
                        .frame(maxWidth:.infinity)
                        
                        
                        ZStack {
                            
                            Image(.logoWaterMarkIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding(.horizontal,-15)
                            //                                .padding(.bottom,40)
                            
                            VStack(spacing:10){
                                let coponData = viewmodel.ticketData?.coupon ?? .init()
                                Text("Payment_shortly".localized)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.bold(size: 22))
                                    .foregroundStyle(Color(.main))
                                
                                HStack(spacing:2) {
                                    Text("price_".localized)
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    Text("\(coponData.totalBeforeDiscount ?? 0)")
                                    Text("EGP_".localized)
                                }
                                .font(.medium(size: 16))
                                .foregroundStyle(Color(.main))
                                
                                HStack(spacing:2) {
                                    Text("la_Discount".localized)
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    Text("\(coponData.discount ?? 0)")
                                    Text("EGP_".localized)
                                }
                                .font(.medium(size: 16))
                                .foregroundStyle(Color(.secondary))
                                
                                HStack(spacing:2) {
                                    Text("Final_price_".localized)
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    Text("\(coponData.totalAfterDiscount ?? 0)")
                                    Text("EGP_".localized)
                                }
                                .font(.semiBold(size: 16))
                                .foregroundStyle(Color(.main))
                                
                                Spacer().frame(height:60)
                            }
                        }
                        //                        .frame(height:170)
                        
                        //                        .background{
                        //                            Image(.logoWaterMarkIcon)
                        //                                .resizable()
                        //                                .aspectRatio(contentMode: .fill)
                        //                                .padding(.horizontal,-15)
                        //                                .padding(.bottom,40)
                        //
                        //
                        //                        }
                        
                        //                        Spacer()
                    }
                    .padding(.horizontal,30)
                    .padding(.top,30)
                    
                }
                .padding(.top)
                .background{
                    TicketShape(cutoutPosition: 0.72)
                        .fill(Color.white)
                    //                            .frame(height: 200)
                        .shadow(radius: 3)
                        .padding()
                }
                
                
                CustomButton(title: "Continue_".localized, backgroundView:
                                AnyView(Color.clear.horizontalGradientBackground())) {
                    Task {
                        await viewmodel.createCustomerPackage(paramters: parameters )
                    }
                }
                
                
            }
        }
        .task {
            viewmodel.ticketData = ticketData
        }
        //        .reversLocalizeView()
        //        .localizeView(reverse: true)
        .localizeView()
        .showHud(isShowing:  $viewmodel.isLoading)
        .errorAlert(isPresented:Binding(
            get: { viewmodel.errorMessage != nil },
            set: { if !$0 { viewmodel.errorMessage = nil } }
        ), message: viewmodel.errorMessage)
        
    }
}

#Preview {
    TicketView( ticketData: .init())
}

struct TicketShape: Shape {
    /// The vertical offset (0 to 1) where the cutout appears vertically
    var cutoutPosition: CGFloat = 0.5 // 0.0 = top, 1.0 = bottom
    var cutoutRadius: CGFloat = 10
    var cornerRadius: CGFloat = 5
    
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
    var cutoutRadius: CGFloat = 10
    var cornerRadius: CGFloat = 5
    
    var body: some View {
        VStack {
            TicketShape(cutoutPosition: cutoutPosition, cutoutRadius:cutoutRadius,cornerRadius:cornerRadius)
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

struct DashedLine: View {
    var dash: [CGFloat] = [6,4]
    var lineWidth: CGFloat = 1
    var color: Color = .secondary
    var width: CGFloat? = nil // Optional: set fixed width if needed
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let lineWidth = width ?? geometry.size.width
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: lineWidth, y: 0))
            }
            .stroke(style: StrokeStyle(lineWidth: lineWidth, dash: dash))
            .foregroundStyle(color)
        }
        .frame(height: lineWidth)
    }
}

