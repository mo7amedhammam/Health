//
//  LastMesurmentsSection.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//

import SwiftUI

struct LastMesurmentsSection: View {
    var measurements : [MyMeasurementsStatsM]?
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
//        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack{
            SectionHeader(image: Image(.newlastmesicon),title: "home_lastMes"){
                //                            go to last mes package
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(measurements ?? [], id: \.self) { item in
                    VStack{
                        Text(item.title ?? "")
                            .font(.bold(size: 16))
                            .foregroundStyle(Color.mainBlue)
                            .frame(maxWidth: .infinity)
                        
                        //                        Image(.sugarMeasurement1)
                        //                            .resizable()
                        //                            .frame(width: 30, height: 30)
                        //                            .aspectRatio(contentMode: .fit)
                        
                        KFImageLoader(url:URL(string:Constants.imagesURL + (item.image?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                            .frame(width: 30, height: 30)
                        
                        Text(item.lastMeasurementValue ?? "")
                            .font(.bold(size: 16))
                            .foregroundStyle(Color(.secondaryMain))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,0)
                        
                        let date = (item.formatteddate ?? "")
                        
//                        (Text("mes_inDate".localized).font(.semiBold(size: 6))
//                         +
                         Text( date )
//                        Text("27/6/2022" )

//                        )
                        .font(.medium(size: 10))
                        .foregroundStyle(Color.mainBlue)
                        .frame(maxWidth: .infinity)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width/3.3, height: 112)
                    .cardStyle(cornerRadius: 3,shadowOpacity:0.08)
                }
            }
            .padding(.horizontal)
            .padding(.vertical,5)
            
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
    }
}

#Preview {
    LastMesurmentsSection()
}
