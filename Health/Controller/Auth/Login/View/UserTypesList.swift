//
//  UserTypesList.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/09/2025.
//


import SwiftUI

//var users:[UserType] = [
////    UserType(id: 0, imgName: "student-vector",user: .Student,tintColor: .studentTint),
////    UserType(id: 1, imgName: "parent-vector",user: .Parent,tintColor: .parentTint),
////    UserType(id: 2, imgName: "teacher-vector",user: .Teacher,tintColor: .teacherTint)
//    
//    
//    UserType(id: 0, title: "Customer",imgName: "Student-active",selectedimgName: "Student-active-selected" ,tintColor: .mainBlue)
//    ,UserType(id: 1,title: "Doctor", imgName: "Parent-active",selectedimgName: "Parent-active-selected",tintColor: Color(.secondary))
////    ,UserType(id: 2, imgName: "Teacher-active",selectedimgName: "Teacher-active-selected",user: .Teacher,tintColor: .red)
//
//]
struct UserTypesList: View {
    @Binding var selectedUser:UserTypeEnum
    var action:(()->())?
    var body: some View {
        HStack{
            ForEach(UserTypeEnum.allCases,id: \.self){user in
                UserTypeCell(user: user, selectedUser: $selectedUser){
                    action?()
                }
                
                if user == .Customer{
                    Color(.mainBlue)
                        .frame(width: 1.5)
                        .padding(.vertical)
                }
            }
        }
        .padding(.top)
    }
}

#Preview {
    UserTypesList(selectedUser: .constant(.Customer))
}


//
//  UserTypeCell.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

enum UserTypeEnum:String,CaseIterable{
    case Customer
    case Doctor
    
    var user:UserType { switch self {
    case .Customer:
        return UserType(id: 0, title: "Customer",imgName: "customer_img",selectedimgName: "customer_img_selected" ,tintColor: Color(.btnDisabledTxt))
    case .Doctor:
        return UserType(id: 1,title: "Doctor", imgName: "doctor_img",selectedimgName: "doctor_img_selected",tintColor: Color(.btnDisabledTxt))

    }
    }
}
struct UserType {
    var id : Int = 0
    var title : String = "Customer"
    var imgName : String = "customer_img"
    var selectedimgName : String = "customer_img_selected"
//    var user : UserTypeEnum = .Customer
    var tintColor : Color = Color(.btnDisabledTxt)
}

import SwiftUI

struct UserTypeCell: View {
    var user:UserTypeEnum
//    = UserType.init(id: 0, imgName: "student-vector", user: .Student,tintColor: .studentTint)
    @Binding var selectedUser:UserTypeEnum
    var action:(()->())?

    var body: some View {
        Button(action: {
            selectedUser = user
            action?()
//            if selectedUser.user == .Student{
//                Helper.shared.setSelectedUserType(userType: .Student)
//
//            }else if selectedUser.user == .Parent{
//                Helper.shared.setSelectedUserType(userType: .Parent)
//
//            }else {
//                Helper.shared.setSelectedUserType(userType: .Teacher)
//            }
        }, label: {
            VStack {
                Image(user.user.id == selectedUser.user.id ? user.user.selectedimgName : user.user.imgName)
                    .resizable()
//                    .renderingMode(.template)
//                    .background(user.id == selectedUser.id ? ColorConstants.WhiteA700 :ColorConstants.Bluegray100)
//                    .foregroundColor(user.id == selectedUser.id ? ColorConstants.Black900 :ColorConstants.Gray600)

                //                    .background(user.id == selectedUser.id ? ColorConstants.WhiteA700 :ColorConstants.Bluegray100)
                //                    .foregroundColor(user.id == selectedUser.id ? ColorConstants.Black900 :ColorConstants.Gray600)

                    .frame(width: 77,
                           height: 77, alignment: .center)
                    .scaledToFit()
//                    .clipped()
                    .clipShape(.circle)
                    .padding(.top, 27.0)
                Text(user.user.title.localized())
                    .font(Font.bold(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(user.user.id == selectedUser.user.id ? Color(.mainBlue) :user.user.tintColor)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)

//                    .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0)
//                        .stroke(user.user.id == selectedUser.user.id ? Color(.mainBlue) : user.user.tintColor,
//                                lineWidth: 1))
                        
//                    .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0)
//                        .fill(user.user.id == selectedUser.user.id ? Color(.mainBlue) : .clear))

            }
            .frame(minWidth: 0,maxWidth: .infinity)
//            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
//                .fill(user.id == selectedUser.id ? ColorConstants.MainColor : user.tintColor))
        })
    }
}

#Preview {
    UserTypeCell(user:.Customer, selectedUser: .constant(.Customer))
}



struct RoundedCorners: Shape {
    var topLeft: CGFloat = 0.0
    var topRight: CGFloat = 0.0
    var bottomLeft: CGFloat = 0.0
    var bottomRight: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.size.width
        let height = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let topRight = min(min(self.topRight, height / 2), width / 2)
        let topLeft = min(min(self.topLeft, height / 2), width / 2)
        let bottomLeft = min(min(self.bottomLeft, height / 2), width / 2)
        let bottomRight = min(min(self.bottomRight, height / 2), width / 2)

        path.move(to: CGPoint(x: width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: width - topRight, y: 0))
        path.addArc(center: CGPoint(x: width - topRight, y: topRight), radius: topRight,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: width, y: height - bottomRight))
        path.addArc(center: CGPoint(x: width - bottomRight, y: height - bottomRight),
                    radius: bottomRight,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bottomLeft, y: height))
        path.addArc(center: CGPoint(x: bottomLeft, y: height - bottomLeft), radius: bottomLeft,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: topLeft))
        path.addArc(center: CGPoint(x: topLeft, y: topLeft), radius: topLeft,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270),
                    clockwise: false)
        path.closeSubpath()

        return path
    }
}
