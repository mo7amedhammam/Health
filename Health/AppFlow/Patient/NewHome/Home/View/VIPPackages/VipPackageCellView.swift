//
//  VipPackageCellView.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//

import SwiftUI


struct VipPackagesSection: View {
    var packages: [FeaturedPackageItemM]?
    @Binding var selectedPackage : FeaturedPackageItemM?

//    var action : ((FeaturedPackageItemM) -> Void)?
    var likeAction : ((Int) -> Void)?
//    @EnvironmentObject var wishlistviewModel: WishListManagerViewModel

    var body: some View {
        VStack{
            SectionHeader(image: Image(.newvippackicon),title: "home_vippackages"){
                //                            go to last mes package
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal,showsIndicators:false){
                LazyHStack {
                    let items = packages ?? []
                    if items.allSatisfy({ $0.appCountryPackageId != nil }) {
                        ForEach(items, id: \.appCountryPackageId) { item in
                            cell(for: item)
                        }
                    } else {
                        ForEach(items, id: \.id) { item in
                            cell(for: item)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical,5)
            }
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
    }

    @ViewBuilder
    private func cell(for item: FeaturedPackageItemM) -> some View {
        VipPackageCellView(
            item: item,
            action: { selectedPackage = item },
            likeAction: {
                guard let packageId = item.appCountryPackageId else { return }
                likeAction?(packageId)
            }
        )
        .equatable()
    }
}

struct VipPackageCellView: View, Equatable {
    static func == (lhs: VipPackageCellView, rhs: VipPackageCellView) -> Bool {
        // Only re-render when the item’s value actually changes.
        // (Closures are intentionally not part of equality.)
        lhs.item == rhs.item
    }

    let item : FeaturedPackageItemM
    var action : (() -> Void)? = nil
    var likeAction : (() -> Void)? = nil

    // Explicit initializer so calls with action/likeAction compile even if
    // a different init was introduced elsewhere.
    init(
        item: FeaturedPackageItemM,
        action: (() -> Void)? = nil,
        likeAction: (() -> Void)? = nil
    ) {
        self.item = item
        self.action = action
        self.likeAction = likeAction
    }

    var body: some View {
        Button(action: {
            action?()
        }, label: {
            ZStack(alignment: .bottom){
                //                                Image(.onboarding1)
                //                                    .resizable()
                //                                    .aspectRatio(contentMode: .fill)
                //                                //                                    .frame(width: 166, height: 221)
                //                                    .frame(width: 200, height: 356)
                
                KFImageLoader(url:URL(string:Constants.imagesURL + (item.homeImage?.validateSlashs() ?? "")),placeholder: Image("logo"),placeholderSize: CGSize(width: 200, height: 356), shouldRefetch: true)
                    .frame(width: 200, height: 356)
                
                VStack {
                    HStack(alignment:.top){
                        // Title
                        HStack (spacing:3){
                            Image(.newconversationicon)
                                .resizable()
                                .frame(width: 16, height: 8)
                            
                            Text("\(item.sessionCount ?? 0) ").font(.semiBold(size: 18))
                            
                            Text("sessions".localized)
                                .font(.regular(size: 12))

                        }
                        .foregroundStyle(Color.white)
                        .frame(height:32)
                        .padding(.horizontal,10)
                        .background{Color(.secondaryMain)}
                        .cardStyle( cornerRadius: 3)
                        
                        Spacer()
                        Button(action: {
                            likeAction?()
                        }, label: {
                            Image( item.isWishlist ?? false ? .newlikeicon : .newunlikeicon)
                                .resizable()
                                .frame(width: 20, height: 20)
                        })
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity,alignment:.leading)
                    .padding(10)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5),.clear]), startPoint: .top, endPoint: .bottom)
                    )
                    
                    Spacer()
                    
                    VStack(alignment: .leading,spacing: 10){
                        Text(item.name ?? "")
                            .font(.semiBold(size: 20))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity,alignment:.leading)
                        
//                        HStack(alignment: .center,spacing: 5){
                        VStack{
                            Text(item.categoryName ?? "")
                            Text(item.mainCategoryName ?? "")

//                            Circle().fill(Color(.white))
//                                .frame(width: 4, height: 4)
//                            Text("23 / 7 / 2023")
                        }
                        .font(.medium(size: 12))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity,alignment:.leading)
                        
                        (Text(item.priceAfterDiscount ?? 0,format: .number.precision(.fractionLength(1))) + Text(" "+"EGP".localized))
                            .font(.semiBold(size: 16))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity,alignment:.leading)
                        
                        HStack{
                            (Text(item.priceBeforeDiscount ?? 0,format: .number.precision(.fractionLength(1))) + Text(" "+"EGP".localized)).strikethrough().foregroundStyle(Color(.secondary))
                                .font(.medium(size: 12))
                            
//                            HStack(spacing: 0){
//                                Text("(".localized)
//                                Text("Discount".localized )
//                                Text( " \(item.discount ?? 0)")
//                                Text("%".localized)
//                                Text(")".localized)
//                            }
//                                .font(.semiBold(size: 12))
//                                .foregroundStyle(Color.white)
                            
                            DiscountLine(discount: item.discount)

                        }
                        .frame(maxWidth: .infinity,alignment:.leading)
                        
                    }
                    .padding(.top,5)
                    .padding([.bottom,.horizontal],10)
                    .background{
                        BlurView(radius: 5)
                            .horizontalGradientBackground(reverse: (Helper.shared.getLanguage().lowercased() != "ar")).opacity(0.89)
                    }
                }
            }
            
        })
        .cardStyle(cornerRadius: 3)
        .frame(width: 200, height: 356)
    }
}

#Preview {
    VipPackageCellView(item: .init())
}
