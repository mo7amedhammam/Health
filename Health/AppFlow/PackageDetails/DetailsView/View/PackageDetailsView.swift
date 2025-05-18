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
                    
//                    HStack{
                        VStack{
                            Text(package.name ?? "pack_name".localized)
                                .font(.bold(size: 20))
                                .foregroundStyle(.white)
                            
                            HStack(alignment: .center,spacing: 5){
                                Text(package.categoryName ?? "التغذية العلاجية")
                                Circle().fill(Color(.white))
                                    .frame(width: 4, height: 4)
                                Text("صحة عامة")
                            }
                            .font(.regular(size: 12))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity,alignment:.center)

                        }
                    .padding(10)
                    .background{
                        BlurView(radius: 6)
                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    }
                }
                .background{
                    KFImageLoader(url:URL(string:Constants.imagesURL + (package.imagePath?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                        .frame( height: 195)

//                    Image(.adsbg2)
//                        .resizable()
                }
                .frame(height: 195)
                
            HStack(alignment: .bottom){
                VStack(alignment: .leading){
                    Text("\(package.priceAfterDiscount ?? 0) " + "EGP".localized)
                        .font(.semiBold(size: 16))
                        .foregroundStyle(Color.white)
                    
                    HStack{
                        Text("\(package.priceBeforeDiscount ?? 0) " + "EGP".localized).strikethrough().foregroundStyle(Color(.secondary))
                            .font(.semiBold(size: 12))
                        
                        (Text("(".localized + "Discount".localized ) + Text( " \(package.discount ?? 0)" + "%".localized + ")".localized))
                            .font(.semiBold(size: 12))
                            .foregroundStyle(Color.white)
                    }
                    .padding(.top,2)
                }
                
                Spacer()
                
                VStack(alignment:.trailing,spacing: 2.5){
                    Button(action: {
                        
                    }, label: {
                        Image(.newlikeicon)
                            .resizable()
                            .frame(width: 20, height: 20)
                    })
                    
                    Spacer()

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
                }
            }
            .offset(y:-12)
            .padding()
            .frame(height: 69)
            .background(Color.mainBlue)
                ScrollView(showsIndicators: false){
                    VStack(alignment:.leading){
                        AvailableDoctorsListView(){doctor in
                            guard let doctorId  = doctor.packageDoctorID else {return}
                            pushTo(destination: PackageMoreDetailsView(doctorId: doctorId))
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
                guard let packageId  = package.id else {return}
                await viewmodel.getAvailableDoctors(PackageId: packageId)
            }
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
            
            SectionHeader(image: Image(.newdocicon),title: "\(viewmodel.availableDoctors?.totalCount ?? 0) \("available_doc".localized)"){
                //                            go to last mes package
            }
            
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
                                    (Text("doc".localized + "/".localized) + Text(item.doctorName ?? "name"))
                                       .font(.bold(size: 16))
                                       .frame(maxWidth: .infinity,alignment:.leading)
                                       .foregroundStyle(Color.mainBlue)

                                    HStack(spacing:2) {
                                        Text(item.speciality ?? "")
                                           .font(.medium(size: 10))
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
                                        
                                        Text("مزيد من التفاصيل".localized)
                                    }
                                    .font(.bold(size: 12))
                                    .foregroundStyle(Color.white)
                                    .frame(height:36)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal,10)
                                    .background{LinearGradient(gradient: Gradient(colors: [.mainBlue, Color(.secondary)]), startPoint: .leading, endPoint: .trailing)}
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
