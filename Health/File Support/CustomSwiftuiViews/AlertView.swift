//
////
////  CustomAlert.swift
////  MrS-Cool
////
////  Created by wecancity on 22/10/2023.
////
//
//import Combine
//import SwiftUI
//
///// Alert type
//public enum AlertType {
//    
//    case success(title: String? = nil,image: String? = "iconSuccess",imgrendermode:Image.TemplateRenderingMode? = nil, message: String = "",buttonTitle:String = "Done",secondButtonTitle:String? = nil,isVertical:Bool? = false,mainBtnAction:(()->())? = nil,secondBtnAction:(()->())? = nil,dismissWithMainAction:Bool? = true )
//    case error(title: String? = nil,image:String? = "img_subtract" ,imgrendermode:Image.TemplateRenderingMode? = nil, message: String = "",buttonTitle:String,secondButtonTitle:String? = nil,isVertical:Bool? = false,mainBtnAction:(()->()?)? = nil,secondBtnAction:(()->()?)? = nil)
//    case question(title: String? = nil,image:String? = "img_group",imgrendermode:Image.TemplateRenderingMode? = nil, message: String = "",buttonTitle:String,secondButtonTitle:String? = nil,isVertical:Bool? = false,mainBtnAction:(()->()?)? = nil,secondBtnAction:(()->()?)? = nil)
//    
//    func title() -> String? {
//        switch self {
//        case .success(title: let title,_ ,_,_, _,_, _, _, _,_):
//            return title
//        case .error(title: let title,_ ,_, _,_,_, _, _, _):
//            return title
//        case .question(title: let title,_ , _,_, _, _, _, _, _):
//            return title
//        }
//    }
//    func image() -> String?{
//        switch self {
//        case .success(_, image:let image,_,_,_,_,_, _, _,_):
//            return image
//        case .error(_, image:let image, _,_, _,_, _, _, _):
//            return image
//        case .question(_, image:let image,_, _, _,_, _,_, _):
//            return image
//        }
//    }
//    
//    func imagerendermode() -> Image.TemplateRenderingMode?{
//        switch self {
//        case .success(_, _,let imagebgcolor,_,_,_,_, _, _,_):
//            return imagebgcolor
//        case .error(_, _, let imagebgcolor,_, _, _, _,_, _):
//            return imagebgcolor
//        case .question(_, _, let imagebgcolor,_, _,_, _,_, _):
//            return imagebgcolor
//        }
//    }
//
//    func message() -> String {
//        switch self {
//        case .success(_,_ ,_,message: let message,_,_ ,_, _, _,_):
//            return message
//        case .error(_,_ ,_,message: let message,_,_ ,_, _, _):
//            return message
//            
//        case .question(_,_,_,message:let message,_,_,_,_, _):
//            return message
//        }
//    }
//    
//    /// Left button action text for the alert view
//    var MainButtonTitle: String {
//        switch self {
//        case .success(_,_,_,_,buttonTitle:let text,_,_, _, _,_):
//            return text
//        case .error(_, _,_,_,buttonTitle:let text,_,_, _, _):
//            return text
//        case .question(_,_, _,_,buttonTitle:let text,_,_,_, _):
//            return text
//
//        }
//    }
//    
//    /// Left button action text for the alert view
//    var icVertical: Bool? {
//        switch self {
//        case .success(_,_, _,_,_,_,let icVertical,_, _,_):
//            return icVertical
//        case .error(_,_, _,_,_,_,let icVertical,_, _):
//            return icVertical
//        case .question(_,_, _,_,_,_,let icVertical,_, _):
//            return icVertical
//
//        }
//    }
//    
//    var MainButtonAction: (()->()?)? {
//        switch self {
//        case .success(_,_,_,_,_,_,_,let action,_,_):
//            return action
//        case .error(_, _,_,_,_,_,_,let action,_):
//            return action
//        case .question(_,_,_,_,_,_,_,let action,_):
//            return action
//        }
//    }
//    /// Right button action text for the alert view
//    var SecondButtonTitle: String? {
//        switch self {
//        case .success(_, _,_,_, _, secondButtonTitle:let text,_,_,_,_):
//            return text
//        case .error(_, _,_,_, _, secondButtonTitle:let text,_,_,_):
//            return text
//        case .question(_, _,_,_, _, secondButtonTitle:let text,_,_,_):
//            return text
//        }
//    }
//    var SecondButtonAction: (()->()?)? {
//        switch self {
//        case .success(_,_,_,_,_,_,_,_,let action,_):
//            return action
//        case .error(_,_,_,_,_,_,_,_,let action):
//            return action
//        case .question(_,_,_,_,_,_,_,_,let action):
//            return action
//        }
//    }
//    var dismissWithMainAction: Bool? {
//        switch self {
//        case .success(_,_,_,_,_,_,_,_,_,let dismissWithMainAction):
//            return dismissWithMainAction
//        case .error(_,_,_,_,_,_,_,_,_):
//            return false
//        case .question(_,_,_,_,_,_,_,_,_):
//            return false
//        }
//    }
////    func height(isShowVerticalButtons: Bool = false) -> CGFloat {
////        switch self {
////        case .success:
////            return isShowVerticalButtons ? 220 : title() == "" ? 180:240
////        case .error(_,_, _, _, _):
////            return isShowVerticalButtons ? 220 : title() == "" ? 180:240
////        case .question:
////            return isShowVerticalButtons ? 220 : title() == "" ? 100:240
////
////        }
////    }
//}
//
///// A boolean State variable is required in order to present the view.
//struct CustomAlertView: View {
//    
//    /// Flag used to dismiss the alert on the presenting view
//    @Binding var presentAlert: Bool
//    
//    /// The alert type being shown
//    @State var alertType: AlertType = .success()
//    
//    /// based on this value alert buttons will show vertically
////    var haveTwoButtons:Bool? = false
//
////    var leftButtonText = ""
////    var rightButtonText = ""
//    var leftButtonAction: (() -> ())?
//    var rightButtonAction: (() -> ())?
//    
////    let verticalButtonsHeight: CGFloat = 50
//    
////    private let topcolor = UIColor(Color("Second_Color"))
////    private let bottomcolor =  UIColor( #colorLiteral(red: 0.4801040292, green: 0.2913792729, blue: 0.6648703814, alpha: 1) )
//
//    var body: some View {
//        
//        ZStack {
//            // faded background
//            Color.black.opacity(0.75)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture {
//                    if alertType.dismissWithMainAction == true{
//                        alertType.MainButtonAction?()
//                    }
//                    presentAlert=false
//                }
//            
//            VStack(spacing: 0) {
//                
//                ZStack{
//                    //                topcolor
//                    //                Color(topcolor)
//                    //                    .frame(height : 8)
//                    //                    .frame(height: verticalButtonsHeight)
//                    
//                    
//
//                }
//                
////                if let imgStr = alertType.image(){
//                    ZStack {
//                        Image(alertType.image() ?? "payment_failed")
//                            .resizable()
//                            .renderingMode(alertType.image() == nil ? .original : alertType.imagerendermode() ?? .template)
//                        //                                .foregroundColor(Color("Second_Color"))
//                            .foregroundColor(Color.mainBlue)
//                            .aspectRatio( contentMode: .fill)
//                            .frame(width: 70, height: 70, alignment: .center)
//                    }
//                    .padding(.top)
////                }
//                
//                if let title = alertType.title(){
//                    // alert title
//                    Text(title.localized())
//                        .font(Font.regular(size: 16))
//                        .foregroundColor(.black)
//                        .multilineTextAlignment(.center)
//                        .frame(height: 25)
//                    ////                        .padding(.top, 16)
//                    ////                        .padding(.bottom, 8)
//                        .padding(.horizontal, 16)
//                }
//                
//                // alert message
//                Text(alertType.message().localized())
//                //                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//                    .font(Font.regular(size: 16))
//                    .foregroundColor(.black)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal, 16)
//                //                    .padding(.bottom, 16)
//                    .padding(.vertical)
//                    .minimumScaleFactor(0.5)
//                
//                //                Divider()
//                //                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 0.5)
//                //                    .padding(.all, 0)
//                
//                
//                
//                
//                if alertType.icVertical ?? true {
//                    VStack() {
//                        // top button
//                        CustomSwiftuiButton(Title: alertType.MainButtonTitle, IsDisabled: .constant(false), action: {
//                            alertType.MainButtonAction?()
//                            presentAlert.toggle()
//                        })
//                        .frame(height: 40)
//                        
//                        // spacer
//                        Spacer().frame(height: 20)
//                        
//                        // bottom button
//                        if let secondTitle = alertType.SecondButtonTitle {
//                            CustomBorderedButton(Title: secondTitle, IsDisabled: .constant(false), action: {
//                                alertType.SecondButtonAction?()
//                                presentAlert.toggle()
//                            })
//                            .frame(height: 40)
//                        }
//                    }
////                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 55)
////                    .frame(height: 40)
//                    .padding(.horizontal)
//                    .padding(.bottom, 20)
//
//                } else {
//                    HStack(spacing: 0) {
//                        // left button
//                        CustomSwiftuiButton(Title: alertType.MainButtonTitle, IsDisabled: .constant(false), action: {
//                            alertType.MainButtonAction?()
//                            presentAlert.toggle()
//                        })
//                        .frame(width: 100)
//                        
//                        if let secondTitle = alertType.SecondButtonTitle {
//                            Spacer().frame(width: 50)
//                            // right button (default)
//                            CustomBorderedButton(Title: secondTitle, IsDisabled: .constant(false), action: {
//                                alertType.SecondButtonAction?()
//                                presentAlert.toggle()
//                            })
//                            .frame(width: 100)
//                        }
//                    }
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 55)
//                    .frame(height: 40)
//                    .padding(.horizontal, 0)
//                    .padding(.bottom, 20)
//                }
//
//            }
//            .background(
//                Color.white
//            )
//            .cornerRadius(10)
//            .padding(.horizontal)
//        }
//        .localizeView()
//        .zIndex(2)
//    }
//}
//
//#Preview {
////    CustomAlertView(presentAlert: .constant(true),alertType: .error(title: "", image: nil, imgrendermode: .original, message: "MEssage", buttonTitle: "OK", isVertical: false))
//    
////        CustomAlert(presentAlert: .constant(true),alertType:.question(title: "Title", message: "Are you sure you want to delete this item ?",lefttext: "Save",righttext: "Clear"),haveTwoButtons: true)
//    
////    CustomAlertView(presentAlert: .constant(true),alertType:.success(title: "Title", imgrendermode:.original, message: "succeeded",buttonTitle: "Done",secondButtonTitle: "OK"))
//
//    CustomAlertView(presentAlert: .constant(true),alertType: .question( image: "MenuSt_signout_new", message: "Are you sure you want to sign out ?", buttonTitle: "Sign Out", secondButtonTitle: "Cancel", mainBtnAction: {
//        
//    },secondBtnAction:{
//    }))
//
////    CustomAlertView(presentAlert: .constant(true),alertType:.success (title: "Are you sure you want to delete this item ?", image: "studenticon",imgrendermode: .original, message: "Are you want to create a new \naccount ?", buttonTitle: "Create New Account", secondButtonTitle: "No, Connect to my son account",isVertical:true, mainBtnAction: {
////        tabbarvm.destination = AnyView( StudentSignUpView()
////            .environmentObject(LookUpsVM())
////            .environmentObject(StudentSignUpVM())
////        )
////        tabbarvm.ispush = true
////    }, secondBtnAction: {
////        
////    }))
//    
//}
//
//
//struct showAlertModifier: ViewModifier {
//    @Binding var hasError: Bool
//    var alertType: AlertType
//    var leftAction: (() -> ())?
//    var rightAction: (() -> ())?
//
//    func body(content: Content) -> some View {
//        content.overlay {
//            if hasError {
//                CustomAlertView(
//                    presentAlert: $hasError,
//                    alertType: alertType,
//                    leftButtonAction: {
//                        leftAction?()
//                        hasError.toggle()
//                    },
//                    rightButtonAction: {
//                        rightAction?()
//                        hasError.toggle()
//                    }
//                )
//            }
//        }
//    }
//}
//
//extension View {
//    public func showAlert(hasAlert: Binding<Bool>, alertType: AlertType?, leftAction: (() -> ())? = nil, rightAction: (() -> ())? = nil) -> some View {
//        modifier(showAlertModifier(hasError: hasAlert, alertType: alertType ?? .error( message: "", buttonTitle: ""), leftAction: leftAction, rightAction: rightAction))
//    }
//}
//
////===-=-=-=-=-=-=-=-=-=-
//
////
////  CustomButton.swift
////  MrS-Cool
////
////  Created by wecancity on 17/10/2023.
////
//
//
//struct CustomSwiftuiButton: View {
////    @State private var language = LocalizationService.shared.language
//
//    var imageName:String?
////    var imageColor:Color?
//    var Title = ""
//    var bgColor:Color?
//    @Binding var IsDisabled:Bool
//    var action: () -> Void
//
//    var body: some View {
//        Button(action: {
//                action()
//        }, label: {
//            HStack(alignment:.center) {
//                if let imageName = imageName{
//                    Image(imageName)
//                        .resizable()
//                        .renderingMode(.template)
//                        .frame(width: 20,
//                               height: 20, alignment: .center)
////                        .font(Font.system(size: 2))
////                        .scaledToFit()
//                        .aspectRatio(contentMode: .fit)
//                        .clipped()
//                }
//                if Title.count > 0 {
//                    Text(Title.localized())
//                        .font(Font.semiBold(size:14))
//                        .fontWeight(.semibold)
//                        .multilineTextAlignment(.center)
//                }
//            }
//            .frame(minWidth: 0, maxWidth: .infinity)
//            .frame(minHeight: 0, maxHeight: .infinity)
//
//            .padding()
//            .foregroundColor(IsDisabled ? ColorConstants.Bluegray400:ColorConstants.WhiteA700)
//
//            .background(
//                RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0, bottomRight: 8.0)
//                .fill(IsDisabled ? ColorConstants.Gray300:bgColor ?? ColorConstants.MainColor)
////                .opacity(IsDisabled ? 0.5:1)
//            )
//
//            .cornerRadius(8)
//        })
//            .disabled(IsDisabled)
//    }
//}
//
//#Preview {
//    CustomSwiftuiButton(imageName:"icons8-plus-90",Title: "",IsDisabled: .constant(false), action:{})
//        .frame(width:40,height: 40)
//}
//
//
//struct CustomBorderedButton: View {
//    var imageName:String?
//    var Title = ""
//    @Binding var IsDisabled:Bool
//    var action: () -> Void
//    var body: some View {
//        
//        Button(action: {
//            action()
//        }, label: {
//            HStack(spacing: 0) {
//                if let imageName = imageName{
//                    Image(imageName)
//                        .resizable()
//                        .renderingMode(.template)
//                        .frame(width: 20,
//                               height: 20, alignment: .center)
////                        .font(Font.system(size: 2))
////                        .scaledToFit()
//                        .aspectRatio(contentMode: .fit)
//                        .clipped()
//                }
//                Text(Title.localized())
//                    .font(Font.semiBold(size: 14))
//                    .fontWeight(.semibold)
////                    .minimumScaleFactor(0.5)
//                    .multilineTextAlignment(.center)
//            }
//            .foregroundColor(IsDisabled ? ColorConstants.Bluegray400:ColorConstants.Black900)
//
//            .frame(minWidth: 0, maxWidth: .infinity)
//            .frame(minHeight: 0, maxHeight: .infinity)
//            .padding()
//
//            .overlay(RoundedCorners(topLeft: 8, topRight: 8, bottomLeft: 8,
//                                    bottomRight: 8)
//                .stroke(IsDisabled ? ColorConstants.Gray300: ColorConstants.MainColor,
//                        lineWidth: 2))
//            .background(RoundedCorners(topLeft:8,topRight:8,bottomLeft:8,bottomRight:8)
//                .fill(ColorConstants.WhiteA700))
//        })
//        .disabled(IsDisabled)
//        
//    }
//}
//#Preview{
//    CustomBorderedButton(IsDisabled: .constant(false), action: {})
//}
//
