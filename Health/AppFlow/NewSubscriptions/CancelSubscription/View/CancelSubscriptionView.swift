//
//  CancelSubscriptionView.swift
//  Sehaty
//
//  Created by mohamed hammam on 01/06/2025.
//

import SwiftUI

struct CancelSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @State var reason: String = ""
    var body: some View {
        ZStack{
            VStack{
                Image("cancelsubscription")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color(.secondary))
                    .frame(width: 54,height: 45)
                    .aspectRatio(contentMode: .fill)

                Text("هل أنت متأكد أنك تريد إلغاء الاشتراك في هذه الباقة؟".localized)
                    .font(.semiBold(size: 12))
                    .foregroundStyle(Color(.main))
                    .padding()
                
                VStack(alignment: .leading){
                    HStack{
                        Text("سبب إلغاء الاشتراك".localized)
                            .font(.semiBold(size: 16))
                            .foregroundStyle(Color(.main))
                            .frame(maxWidth:.infinity,alignment: .leading)
                        
                        Image("messagecentrepopup")
                            .resizable()
                            .frame(width: 16,height: 16)
                            .aspectRatio(contentMode: .fill)
                        
                    }
                    
                    if #available(iOS 16.0, *) {
                        TextField("برجاء إبلاغنا سبب إلغاء الاشتراك في هذه الباقة".localized, text: $reason, axis: .vertical)
                            .padding(.vertical)
                            .font(.medium(size: 12))
                        
                    } else {
                        // Fallback on earlier versions
                        TextField("برجاء إبلاغنا سبب إلغاء الاشتراك في هذه الباقة".localized, text: $reason)
                            .padding(.vertical)
                            .font(.medium(size: 12))
                    }
                }
                
                HStack(spacing:20){
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel".localized)
                            .font(.bold(size: 18))
                    })
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height:50)
                    .foregroundStyle(.white)
                    .background{Color(.secondary)}
                    .cardStyle(cornerRadius: 3)
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Confirm".localized)
                            .font(.bold(size: 18))
                    })
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height:50)
                    .foregroundStyle(.white)
                    .background{Color(.main)}
                    .cardStyle(cornerRadius: 3)

                }
            }
            .padding()
            .cardStyle(cornerRadius: 3)
            .padding(30)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{Color.black.opacity(0.3)}
        .ignoresSafeArea()
    }
}

#Preview {
    CancelSubscriptionView()
}
