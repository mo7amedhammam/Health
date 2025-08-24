//
//  PackageDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/05/2025.
//

import SwiftUI

struct PackageDetailsView: View {
    @StateObject var viewmodel = AvailableDoctorsViewModel()
    var package: FeaturedPackageItemM
    
    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    init(package: FeaturedPackageItemM) {
        self.package = package
    }

    var body: some View {
//        NavigationView(){
        VStack(spacing:0){
                VStack(){
                    TitleBar(title: "",hasbackBtn: true)
                        .padding(.top,50)

                    Spacer()
                    
                    HStack{
//                    VStack(alignment: .leading){
//                            Text(package.name ?? "pack_name".localized)
//                                .font(.semiBold(size: 22))
//                                .foregroundStyle(.white)
                            
//                            HStack(alignment: .center,spacing: 5){
                        VStack(alignment: .leading,spacing: 4){
                            Text(package.name ?? "pack_name".localized)
                                .font(.semiBold(size: 22))
                                .foregroundStyle(.white)

                                Text(package.mainCategoryName ?? "seha 3ama")
                                .padding(.top,4)
//                                Circle().fill(Color(.white))
//                                    .frame(width: 4, height: 4)
                                Text(package.categoryName ?? "tagzia 3lagia")
                            }
                            .font(.medium(size: 18))
                            .foregroundStyle(Color.white)
//                            .frame(maxWidth: .infinity,alignment:.center)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing){
                            Button(action: {
                                
                            }, label: {
                                Image(.newlikeicon)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            })
                            Spacer()
                            
                            HStack(alignment: .center,spacing: 5){
                                ( Text(" \(package.doctorCount ?? 0) ") + Text("avilable_doc".localized))
                                    .font(.regular(size: 10))

                                Image(.newdocicon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 10,height:12)
                                    .scaledToFit()
                                    .foregroundStyle(Color("FF8F15"))
                                    .padding(3)
//                                    .background(Color(.secondary))
                                
//                                    .frame(maxWidth: .infinity,alignment:.leading)
                            }
                            .font(.medium(size: 12))
                            .foregroundStyle(Color.white)
                        }
                        }
                    .frame(height: 76)
                    .padding(10)
                    .background{
                        BlurView(radius: 5)
                            .horizontalGradientBackground().opacity(0.89)
                    }
                }
                .background{
                    KFImageLoader(url:URL(string:Constants.imagesURL + (package.imagePath?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                        .frame( height: 195)

//                    Image(.adsbg2)
//                        .resizable()
                }
                .frame(height: 239)
                
            HStack(alignment: .bottom){
                VStack(alignment: .leading){
                    (Text(package.priceAfterDiscount ?? 0,format:.number.precision(.fractionLength(1))) + Text(" "+"EGP".localized))
                        .font(.semiBold(size: 16))
                        .foregroundStyle(Color.white)
                    
                    HStack{
                        (Text(package.priceBeforeDiscount ?? 0,format:.number.precision(.fractionLength(1))) + Text(" "+"EGP".localized)).strikethrough().foregroundStyle(Color(.secondary))
                            .font(.semiBold(size: 12))
                        
                        DiscountLine(discount: package.discount)
                    }
                    .padding(.top,2)
                }
                
                Spacer()
                
//                VStack(alignment:.trailing,spacing: 2.5){
//                    Button(action: {
//                        
//                    }, label: {
//                        Image(.newlikeicon)
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                    })
                    
//                    Spacer()

                    // Title
                    HStack (spacing:3){
                        Image(.newconversationicon)
                            .resizable()
                            .frame(width: 16, height: 9)
                        Text("\(package.sessionCount ?? 0) ").font(.semiBold(size: 16))
                        
                        Text("sessions".localized)
                    }
                    .font(.regular(size: 10))
                    .foregroundStyle(Color.white)
                    .frame(height:32)
                    .padding(.horizontal,10)
                    .background{Color(.secondaryMain)}
                    .cardStyle( cornerRadius: 3)
//                }
            }
//            .offset(y:-12)
            .padding()
            .frame(height: 69)
            .background(Color.mainBlue)
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
            .task {
                guard let appCountryPackageId  = package.appCountryPackageId else {return}
                await viewmodel.getAvailableDoctors(appCountryPackageId: appCountryPackageId)
            }
//            .reversLocalizeView()
            .localizeView()
            .showHud(isShowing:  $viewmodel.isLoading)
            .errorAlert(isPresented: .constant(viewmodel.errorMessage != nil), message: viewmodel.errorMessage)

        NavigationLink( "", destination: destination, isActive: $isactive)

    }
}

#Preview {
    PackageDetailsView(package: .init())
}

struct AvailableDoctorsListView: View {
    @EnvironmentObject var viewmodel : AvailableDoctorsViewModel

//    var doctors:[AvailabeDoctorsItemM]?
    var action: ((AvailabeDoctorsItemM) -> Void)?
    var body: some View {
        VStack{
            
//            SectionHeader(image: Image(.newdocicon),title: "\(viewmodel.availableDoctors?.totalCount ?? 0) \("available_doc".localized)"){
//                //                            go to last mes package
//            }
            
//            ScrollView(.horizontal,showsIndicators:false){
            ScrollView{
//                let doctors: [AvailabeDoctorsItemM]? = viewmodel.availableDoctors?.items
                    ForEach(viewmodel.availableDoctors?.items ?? [], id: \.self) { item in
                        Button(action: {
                            
                        }, label: {
                            VStack{
//                                    Image(.onboarding1)
//                                        .resizable()
//                                        .frame( height: 160)
//                                        .aspectRatio(contentMode: .fill)
//                                        .cardStyle(cornerRadius: 3)
                                
                                KFImageLoader(url:URL(string:Constants.imagesURL + (item.doctorImage?.validateSlashs() ?? "")),placeholder: Image("logo") , shouldRefetch: true)
                                    .frame(height: 160)
                                    .frame(maxWidth:.infinity)
                                    .cardStyle(cornerRadius: 3,shadowOpacity: 0.1)
                                
                                HStack(alignment: .center,spacing: 5){
                                    (
//                                        Text("doc".localized + "/".localized) +
                                     Text(item.doctorName ?? "name"))
                                       .font(.semiBold(size: 22))
                                       .frame(maxWidth: .infinity,alignment:.leading)
                                       .foregroundStyle(Color.mainBlue)

                                    HStack(spacing:2) {
                                        Text(item.speciality ?? "")
                                           .font(.semiBold(size: 12))
//                                           .frame(maxWidth: .infinity,alignment:.leading)
                                           .foregroundStyle(Color.mainBlue)
                                        
                                        Image(.newpharmacisticon)
//                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 12,height:12)
                                            .scaledToFit()
//                                            .foregroundStyle(.white)
                                            .padding(3)
                                    }
//                                        .background(Color(.secondary))
                                    
                                }
                                Text("job title" + " - " + "uiniverrsity name")
                                   .font(.medium(size: 10))
                                   .frame(maxWidth: .infinity,alignment:.leading)
                                   .foregroundStyle(Color(.secondary))
                                   .padding(.bottom,2)
                                
                                Button(action: {
                                    action?(item)
                                }){
                                    HStack (spacing:5){
                                        Image(.newmoreicon)
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                        
                                        Text("more_detail".localized)
                                    }
                                    .font(.bold(size: 16))
                                    .foregroundStyle(Color.white)
                                    .frame(height:36)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal,10)
                                    .horizontalGradientBackground()
//                                    .background{LinearGradient(gradient: Gradient(colors: [.mainBlue, Color(.secondary)]), startPoint: .leading, endPoint: .trailing)}
//                                    .cardStyle( cornerRadius: 3)
                                    .cornerRadius(3)
                                }
                            }
//                            .padding(10)
//                            .cardStyle(cornerRadius: 3)
//                            .background{Color.white}

                            
                        })

//                        .padding()
//                        .cardStyle(cornerRadius: 3)
//                        .frame(width: 200, height: 356)

//                        .padding(.vertical,10)
//                        .background{Color.red}
                        .background{Color.white}
                                    .padding(10)

                        .cardStyle(cornerRadius: 3)

                    }
                    .padding(10)

//                    .cardStyle(cornerRadius: 3)

            }
            .padding(-10)

        }
//        .padding(.vertical,5)
        .padding(.bottom,5)
    }
}

struct DiscountLine: View {
    let discount: Double?
    var body: some View {
        HStack(spacing:0){
            Text("(".localized)
            Text("Discount".localized + " ")
            Text( discount ?? 0,format: .percent)
//            Text("%".localized )
            Text(")".localized)
        }
        .font(.semiBold(size: 12))
        .foregroundStyle(Color.white)
    }
}
