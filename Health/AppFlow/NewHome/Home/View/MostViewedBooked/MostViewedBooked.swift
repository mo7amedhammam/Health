//
//  MostViewedBooked.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//

import SwiftUI

struct MostViewedBooked: View {
//    @EnvironmentObject var viewModel : NewHomeViewModel
    
     enum mostcases {
        case mostviewed
        case mostbooked
    }
    @State private var currentcase:mostcases = .mostviewed
     var packaces: [FeaturedPackageItemM]?
    @Binding var selectedPackage : FeaturedPackageItemM?
    var likeAction : ((Int) -> Void)?
    var onChangeTab : ((mostcases) -> Void)? // callback to parent

    var body: some View {
        
        HStack{
            HStack(alignment:.top, spacing:20){
                Button(action: {
                    currentcase = .mostbooked
//                    getFeaturedPackages()
                    onChangeTab?(.mostbooked)

                }){
                    VStack {
                        Text("Most_Booked".localized)
                            .foregroundStyle(currentcase == .mostbooked ? Color(.secondary) : Color(.btnDisabledTxt))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .fixedSize() // Prevents layout issues after rotation
                        Circle().fill(currentcase == .mostbooked ? Color(.secondary) : .clear)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Button(action: {
                    currentcase = .mostviewed
//                    getFeaturedPackages()
                    onChangeTab?(.mostviewed)

                }){
                    VStack {
                        Text("Most_Viewed".localized)
                            .foregroundStyle(currentcase == .mostviewed ? Color(.secondary) : Color(.btnDisabledTxt))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .fixedSize() // Prevents layout issues after rotation
                        
                        Circle().fill(currentcase == .mostviewed ? Color(.secondary) : .clear)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .rotationEffect(.degrees(-90))
            .frame(width: 30)
            .font(.bold(size: 22))
            .padding(.leading)
            
            ScrollView(.horizontal,showsIndicators:false){
                HStack{
                    ForEach(packaces ?? [], id: \.self) { item in
                        VipPackageCellView(item: item,action:{
                            selectedPackage = item
                        },likeAction:{
                            likeAction?(item.id ?? 0)})
                    }
                }
                .padding(.horizontal)
                .padding(.vertical,5)
                
            }
        }
        .frame(height:356)
        .padding(.vertical,10)
        .padding(.bottom,5)
//        .task {
//            getFeaturedPackages()
//        }
//        .onAppear{
//            Task{
//                packaces = currentcase == .mostbooked ? viewModel.mostBookedPackages : viewModel.mostViewedPackages
//
//                switch currentcase {
//                    
//                case .mostviewed:
//                    packaces = viewModel.mostViewedPackages
//
//                case .mostbooked:
//                    packaces = viewModel.mostBookedPackages
//
//                }
//            }
//        }
    }
//    func getFeaturedPackages() {
//        Task() {
//            switch currentcase {
//            case .mostviewed:
//                await viewModel.getMostBookedOrViewedPackages(forcase: .MostViewed)
//            case .mostbooked:
//                await viewModel.getMostBookedOrViewedPackages(forcase: .MostBooked)
//            }
//            packaces = currentcase == .mostbooked ? viewModel.mostBookedPackages : viewModel.mostViewedPackages
//        }
//    }
}


#Preview(body: {
    MostViewedBooked( selectedPackage: .constant(nil))
})
