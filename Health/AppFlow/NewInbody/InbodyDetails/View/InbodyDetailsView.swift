//
//  InbodyDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 05/08/2025.
//

import SwiftUI

struct InbodyDetailsView: View {
    @StateObject private var downloader = FileDownloader()

    var report:InbodyListItemM
    var body: some View {
        //        NavigationView {
        VStack(spacing: 0) {
            TitleBar(title: "Inbody_Title",hasbackBtn: true)
            
            ScrollView{
                VStack(spacing: 30){
                    
                    Image("profile_inbody")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(Color(.secondary))
                        .frame(width: 44,height: 118)
                        .padding(.top,30)
                    
                    if downloader.isDownloading {
                        ProgressView("Downloading_".localized, value: downloader.downloadProgress, total: 1.0)
                            .padding(.horizontal)
                    }

                    downloadInbodyButton {
//                        Task{
                        guard let fileURL = report.testFile else {return}
                            downloader.download(from: fileURL)
                            //                    showUploadSheet = true
                            //                        await lookupsvm.getFileTypes()
//                        }
                    }
                    .padding([.top,.horizontal])
                    .disabled(downloader.isDownloading)
                    
                    Text(report.title ?? "")
                        .font(.bold(size: 36))
                        .foregroundStyle(Color.mainBlue)
                        .multilineTextAlignment(.center)
                    
                    Text(report.formattedCreationDate ?? "")
                        .font(.medium(size: 18))
                        .foregroundStyle(Color(.secondary))
                        .multilineTextAlignment(.center)
                    
                    Text(report.comment ?? "")
                        .font(.medium(size: 18))
                        .foregroundStyle(Color.mainBlue)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.horizontal)

                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .localizeView()
//        .showHud(isShowing: $viewmodel.isLoading)
        .errorAlert(isPresented: .constant(downloader.errorMessage != nil), message: downloader.errorMessage)
//        .onChange(of: downloader.showSuccess){newval in
//            guard newval == true else { return }
//            fileDownloaded()
//        }
        .fullScreenCover(isPresented: $downloader.showSuccess, onDismiss: {}, content: {
           AnyView( fileDownloaded() )
        })
    }
}

#Preview {
    InbodyDetailsView(report: .init(testFile:"", title:"تحليل مكونات الجسم رقم _ 1",comment:"التعامل مع الإجهاد: ينصح بالتقليل من الإجهاد وممارسة التمارين الهادئة مثل اليوغا أو التأمل. الحفاظ على مستويات الكوليسترول الصحية: ينصح بتقليل تناول الدهون المشبعة والكوليسترول والأطعمة المعالجة.تناول الأدوية بانتظام: إذا كانت هناك أدوية موصوفة للقلب، فينبغي تناولها بانتظام وفقًا لتعليمات الطبيب.", date:"2025-06-29T1:41:39"))
}

struct downloadInbodyButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                //                ZStack{
                //                    Color(.white)
                //                        .cornerRadius(3)
                                    
                                    Image("Download")
                //                    Image(systemName: "plus")
                //                        .renderingMode(.template)
                                        .resizable()
                //                        .foregroundStyle(Color(.secondary))
                //                        .frame(width: 22,height: 22)
                //                }
                                .frame(width: 40,height: 40)
                Text("download_Inbody".localized)
                    .font(.bold(size: 24))

            }
            .foregroundColor(.white)
            .padding(10)
            .horizontalGradientBackground()
            .cornerRadius(3)
        }
    }
}

extension InbodyDetailsView{
    private func fileDownloaded()->any View {
        let successView = SuccessView(
            image: Image("successicon"),
            title: "inbody_success_title".localized,
            subtitle1: "inbody_success_subtitle1".localized,
            subtitle2: "inbody_success_subtitle2".localized,
            buttonTitle: "inbody_success_created_btn".localized,
            buttonAction: {
                // Navigate to home or login
//                let login = UIHostingController(rootView: LoginView())
//                Helper.shared.changeRootVC(newroot: login, transitionFrom: .fromLeft)
                
                downloader.showSuccess = false
            }
        )
//        let newVC = UIHostingController(rootView: successView)
//        Helper.shared.changeRootVC(newroot: newVC, transitionFrom: .fromLeft)
        return successView
    }
}
