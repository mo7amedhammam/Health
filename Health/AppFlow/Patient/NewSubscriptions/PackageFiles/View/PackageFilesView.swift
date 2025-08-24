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
            
            filesList(files: viewmodel.packageFiles?.items)
            
        }
        .background(Color(.bg))
        .task {
            viewmodel.CustomerPackageId = CustomerPackageId
            await viewmodel.getSubscripedPackageFiles()
        }
//        .reversLocalizeView()
        .localizeView()
        .showHud(isShowing:  $viewmodel.isLoading)
        .errorAlert(isPresented: .constant(viewmodel.errorMessage != nil), message: viewmodel.errorMessage)

    }
}

#Preview {
    PackageFilesView(CustomerPackageId: 0)
}


struct filesList:View {
    var files:[MyFileM]? = [.init(),.init(),.init()]
    
    var body: some View {
        
        GeometryReader{ geometry in
            ScrollView{
                if let files = files, files.count > 0{
                    VStack(spacing: 0) {
                        ForEach(files,id: \.self) { file in
                            VStack {
                                HStack(alignment: .top){
                                
                                    Button(action: {
                                     
                                        if let filePath = file.filePath , let url = URL(string: filePath ) {
                                            UIApplication.shared.open(url)
                                        }
                                        
                                    }, label: {
                                    VStack(spacing:8){
                                        Image("downloadicon")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .horizontalGradientBackground()
                                            .cardStyle(cornerRadius: 3)
                                        
                                        let title = switch file.fileTypeID ?? 0 {
                                        case 1,2:
                                            "Download_".localized
                                        case 3,4:
                                            "Watch_".localized
                                        default:
                                            "Open_".localized
                                        }
                                        
                                        Text(title)
                                            .font(.medium(size: 12))
                                            .foregroundStyle(Color(.main))
                                    }
                                    })
                                    
                                    VStack(alignment: .trailing,spacing: 12){
                                        Text(file.fileName ?? "فيديو تمرينات الأسبوع الأول والثاني")
                                            .font(.semiBold(size: 16))
                                            .foregroundStyle(Color(.main))
                                        
                                        Text(file.formattedCreationDate ?? "12 أكتوبر 2020")
                                            .font(.medium(size: 14))
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


