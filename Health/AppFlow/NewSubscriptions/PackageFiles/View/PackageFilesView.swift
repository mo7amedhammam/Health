//
//  PackageFilesView.swift
//  Sehaty
//
//  Created by mohamed hammam on 31/05/2025.
//

import SwiftUI

struct PackageFilesView: View {
    var CustomerPackageId : Int
    @StateObject var viewmodel = PackageFilesViewModel.shared

    var body: some View {
        VStack(){
            TitleBar(title: "Package_Files",hasbackBtn: true)

            Spacer()
            
            filesList(files: viewmodel.packageFiles)
            
        }
        .background(Color(.bg))
        .task {
            viewmodel.CustomerPackageId = CustomerPackageId
            await viewmodel.getSubscripedPackageFiles()
        }
        .reversLocalizeView()
        .showHud(isShowing:  $viewmodel.isLoading)
        .errorAlert(isPresented: .constant(viewmodel.errorMessage != nil), message: viewmodel.errorMessage)

    }
}

#Preview {
    PackageFilesView(CustomerPackageId: 0)
}


struct filesList:View {
    var files:[PackageFileM]? = [.init(),.init(),.init()]
    
    var body: some View {
        
        GeometryReader{ geometry in
            ScrollView{
                if let files = files, files.count > 0{
                    VStack(spacing: 0) {
                        ForEach(files,id: \.self) { file in
                            VStack {
                                HStack(alignment: .top){
                                    
                                    VStack(spacing:8){
                                        Image("downloadicon")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .horizontalGradientBackground()
                                            .cardStyle(cornerRadius: 3)
                                        Text("Watch_".localized)
                                            .font(.medium(size: 10))
                                            .foregroundStyle(Color(.main))
                                    }
                                    
                                    VStack(alignment: .trailing,spacing: 12){
                                        Text(file.instText ?? "فيديو تمرينات الأسبوع الأول والثاني")
                                            .font(.semiBold(size: 14))
                                            .foregroundStyle(Color(.main))
                                        
                                        Text("08/05/2025")
                                            .font(.medium(size: 10))
                                            .foregroundStyle(Color(.secondary))
                                    }
                                    .frame(maxWidth:.infinity,alignment: .trailing)
                                }
                                .padding([.horizontal,.top])
                                
                                Color.gray.opacity(0.12)
                                    .frame(height:1)
                                    .padding(.horizontal)
                            }
                        }                                                
                    }
                    .padding(.bottom,5)
                    .cardStyle(cornerRadius: 3,shadowOpacity: 0.12)
                    .padding()
                    
                }else {
                    VStack{
                        
                        Image(.nopackageFiles)
                            .resizable()
                            .frame(width: 162, height: 162)
                        
                        Text("package_no_files".localized)
                            .font(.semiBold(size: 22))
                            .foregroundStyle(Color(.btnDisabledTxt))
                            .padding()
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                            .lineSpacing(12)
                    }
                    .frame(width: geometry.size.width,height:geometry.size.height)
                    
                }
            }
        }
    }
}


