//
//  SubcripedPackageDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 28/05/2025.
//


import SwiftUI

struct SubcripedPackageDetailsView: View {
    @StateObject var viewmodel = AvailableDoctorsViewModel()
    var package: SubcripedPackageItemM
    
    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    init(package: SubcripedPackageItemM) {
        self.package = package
    }

    var body: some View {
//        NavigationView(){
        VStack(spacing:0){
                VStack(){
                    TitleBar(title: "",hasbackBtn: true)
                        .padding(.top,50)

                    Spacer()
                    
                    ZStack (alignment:.top){
                        HStack{
                            VStack{
                                Text(package.packageName ?? "pack_Name".localized)
                                    .font(.semiBold(size: 16))
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity,alignment:.leading)
                                
                                HStack{
                                    Text(package.mainCategoryName ?? "main_category")
                                    Circle()
                                        .fill(Color(.secondary))
                                        .frame(width: 5, height: 5)
                                    
                                    Text(package.categoryName ?? "sub_category")
                                    
                                }
                                .font(.regular(size: 10))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity,alignment:.leading)
                                
                            }
                            
                            VStack(alignment: .trailing,spacing: 5){
                                HStack(spacing:0){
                                    Text( "remain_".localized)
                                    
                                    let reamin = (package.sessionCount ?? 0) - (package.attendedSessionCount ?? 0)
                                    
                                    (Text(" \(reamin) " + "from".localized + " \(package.sessionCount ?? 0) "))
                                        .font(.bold(size: 12))
                                    
                                    Text( "sessions_ar".localized )
                                    
                                    Image("remainingsessions")
                                        .resizable()
                                        .frame(width: 9, height: 9)
                                        .padding(.horizontal,3)
                                    
                                }
                                .font(.regular(size: 10))
                                .minimumScaleFactor(0.5)
                                .foregroundStyle(Color(.white))
                                .padding(.vertical,8)
                                
                                Button(action: {
                                    
                                },label:{
                                    HStack(spacing:3){
                                        Image("newreschedual")
                                            .resizable()
                                            .frame(width: 10, height: 8.5)
                                        Text("renew_subscription".localized)
                                            .underline()
                                    }
                                    .foregroundStyle(Color.white)
                                    .font(.regular(size: 10))
                                })
                            }
                            .font(.regular(size: 10))
                            .foregroundStyle(Color.white)
                            
                        }
                        .padding(10)
                        .background{
                            BlurView(radius: 5)
                                .horizontalGradientBackground().opacity(0.89)
                        }
                        
                        HStack (spacing:3){
                            Circle()
                                .frame(width: 5, height: 5)
                            
                            Text(package.status ?? "Active")
                        }
                        .font(.medium(size: 10))
                        .foregroundStyle(Color.white)
                        .frame(height:22)
                        .padding(.horizontal,10)
                        .background{Color(.active)}
                        .cardStyle(cornerRadius: 3)
                        .offset(y:-11)
                    }
                }
                .background{
                    KFImageLoader(url:URL(string:Constants.imagesURL + (package.packageImage?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                        .frame( height: 238)
                }
                .frame(height: 238)
  
            ScrollView(showsIndicators: false){
                    VStack(alignment:.leading){
                        AvailableDoctorsListView(){doctor in
                            guard let doctorPackageId  = doctor.packageDoctorID else {return}
                            pushTo(destination: PackageMoreDetailsView(doctorPackageId: doctorPackageId))
                        }
                            .environmentObject(viewmodel)
                    }
                    .padding([.horizontal,.top],10)
                    
//                    Spacer()
                    
                    Spacer().frame(height: 55)
                }
            
            }
            .edgesIgnoringSafeArea([.top,.horizontal])
//            .task {
//                guard let packageId  = package.id else {return}
//                await viewmodel.getAvailableDoctors(PackageId: packageId)
//            }
        NavigationLink( "", destination: destination, isActive: $isactive)

    }
}

#Preview {
    SubcripedPackageDetailsView(package: .init())
}
