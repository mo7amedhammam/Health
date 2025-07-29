//
//  InbodyView.swift
//  Sehaty
//
//  Created by mohamed hammam on 29/07/2025.
//

import SwiftUI

struct InbodyView: View {
    @State private var showUploadSheet = false
    @StateObject var myfilesvm = MyFilesViewModel.shared

    @State private var files: [MyFileModel] = []
    @StateObject var lookupsvm = LookupsViewModel.shared

    var body: some View {
//        NavigationView {
            VStack(spacing: 0) {
                TitleBar(title: "Inbody_Title",hasbackBtn: true)

                
                newInbodyButton {
                    Task{
                        showUploadSheet = true
                        await lookupsvm.getFileTypes()
                    }
                }
                .padding([.top,.horizontal])
                .padding(.top,30)
                
//                SectionHeader(image: Image("docicon"),title: "Files_")
//                    .padding([.top,.horizontal])
//                    .padding(.top,20)

                inbodiesList()

                Spacer()
            }
            .localizeView()
            .showHud(isShowing:  $myfilesvm.isLoading)
            .errorAlert(isPresented: .constant(myfilesvm.errorMessage != nil), message: myfilesvm.errorMessage)

            .customSheet(isPresented: $showUploadSheet,height: 440){
//            .sheet(isPresented: $showUploadSheet) {
                UploadFileSheetView(isPresented: $showUploadSheet)
                    .environmentObject(myfilesvm)
                    .environmentObject(lookupsvm)
//                    .frame(height: 600)

//                { newFile in
//                    files.append(newFile)
//                }
            }
            .onAppear(){
                Task{
//                    await myfilesvm.getMyFilesList()
                }
            }
//            .frame(height: 600)

//            .navigationBarHidden(true)
//        }
    }
}

#Preview {
    InbodyView()
}

struct newInbodyButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text("upload_New_Inbody".localized)
                    .font(.bold(size: 24))
              
                ZStack{
                    Color(.white)
                        .cornerRadius(3)
                    
                    Image(systemName: "plus")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(Color(.secondary))
                        .frame(width: 22,height: 22)
                }
                .frame(width: 40,height: 40)

            }
            .foregroundColor(.white)
            .padding(10)
            .horizontalGradientBackground()
            .cornerRadius(3)
        }
    }
}

struct inbodiesList:View {
    var files:[MyFileM]? = [.init(),.init(),.init()]
    
    var body: some View {
        
        GeometryReader{ geometry in
            ScrollView{
                if let files = files, files.count > 0{
//                    VStack(spacing: 0) {
                    Spacer()
                        ForEach(files,id: \.self) { file in
                            VStack(spacing:12) {
                                HStack(alignment: .top){
                                
//                                    Button(action: {
//                                     
//                                        if let filePath = file.filePath , let url = URL(string: filePath ) {
//                                            UIApplication.shared.open(url)
//                                        }
//                                        
//                                    }, label: {
//                                    VStack(spacing:8){
//                                        Image("downloadicon")
//                                            .resizable()
//                                            .frame(width: 24, height: 24)
//                                            .horizontalGradientBackground()
//                                            .cardStyle(cornerRadius: 3)
//                                        
//                                        let title = switch file.fileTypeID ?? 0 {
//                                        case 1,2:
//                                            "Download_".localized
//                                        case 3,4:
//                                            "Watch_".localized
//                                        default:
//                                            "Open_".localized
//                                        }
//                                        
//                                        Text(title)
//                                            .font(.medium(size: 12))
//                                            .foregroundStyle(Color(.main))
//                                    }
//                                    })
                                    Image(.inbodyIcon)
                                    
                                    VStack(alignment: .leading,spacing: 12){
                                        Text(file.fileName ?? "فيديو تمرينات الأسبوع الأول والثاني")
                                            .font(.semiBold(size: 16))
                                            .foregroundStyle(Color(.main))
                                        
                                        Text(file.formattedCreationDate ?? "12 أكتوبر 2020")
                                            .font(.medium(size: 14))
                                            .foregroundStyle(Color(.secondary))
                                    }
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                }
                                
                                VStack (alignment: .leading,spacing:12){
                                    HStack{
                                        Image("payments_notes")
                                        Text("inbody_notes".localized)
                                            .font(.semiBold(size: 14))
                                            .foregroundStyle(Color(.secondary))
                                        
                                    }
                                
                                    Text(file.notes ?? "التعامل مع الإجهاد: ينصح بالتقليل من الإجهاد وممارسة التمارين الهادئة مثل اليوغا أو التأمل." )
                                        .font(.regular(size: 14))
                                        .foregroundStyle(Color(.main))
                                        .lineSpacing(10)

                                }
                                .frame(maxWidth:.infinity,alignment: .leading)

                                
                                if file != files.last{
                                    Color.gray.opacity(0.12)
                                        .frame(height:1)
                                        .padding(.horizontal)
                                }
                                
                            }
                            .padding([.horizontal,.vertical])

                        }
//                    }
                    .padding(.bottom,5)
                    .cardStyle(cornerRadius: 3,shadowOpacity: 0.12)
                    .padding(.horizontal)
                    
                }else {
                    VStack{
                        
                        Image(.noInbody)
                            .resizable()
                            .frame(width: 162, height: 162)
                        
                        Text("inbody_no_files".localized)
                            .font(.semiBold(size: 22))
                            .foregroundStyle(Color(.btnDisabledTxt))
                            .padding()
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                            .lineSpacing(12)
                    }
                    .frame(width: geometry.size.width,height:geometry.size.height)
                    
                }
            }.padding(.top)
            
        }
        
    }
}
