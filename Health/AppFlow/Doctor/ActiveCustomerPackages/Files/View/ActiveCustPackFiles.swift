//
//  ActiveCustPackFiles.swift
//  Sehaty
//
//  Created by mohamed hammam on 17/09/2025.
//
enum filesCases{
    case Customer,Packages
}
import SwiftUI

struct ActiveCustPackFiles : View {
    var customerId:Int?
    var PackageId:Int?

    @State private var showUploadSheet = false
    @StateObject var myfilesvm = ActiveCustomerPackFilesViewModel.shared

    @State private var files: [MyFileModel] = []
    @StateObject var lookupsvm = LookupsViewModel.shared
    @State var filesCase: filesCases = .Packages
    var body: some View {
//        NavigationView {
            VStack(spacing: 0) {
                TitleBar(title: "Files_Title",hasbackBtn: true)

                HStack {
                    
                    CustomButton(title: "Package_Files",font: .bold(size: 22),foregroundcolor: filesCase == .Packages ? Color(.white):Color(.secondary), backgroundcolor : filesCase == .Packages ? Color(.secondary):Color(.wrongsurface),backgroundView: nil){
                        filesCase = .Packages
                    }
                    
                    CustomButton(title: "Customer_Files",font: .bold(size: 22),foregroundcolor: filesCase == .Customer ? Color(.white):Color(.secondary), backgroundcolor : filesCase == .Customer ? Color(.secondary):Color(.wrongsurface),backgroundView: nil){
                        filesCase = .Customer
                    }
                    
                }
                .padding(.vertical,20)
                
                UploadButton {
                    Task{
                        showUploadSheet = true
                        await lookupsvm.getFileTypes()
                    }
                }
                .padding([.horizontal])
//                .padding(.top,30)
                
//                SectionHeader(image: Image("docicon"),title: "Files_")
//                    .padding([.top,.horizontal])
//                    .padding(.top,20)

                filesList()

                Spacer()
            }
            .localizeView()
            .showHud(isShowing:  $myfilesvm.isLoading)
            .errorAlert(isPresented: Binding(
                get: { myfilesvm.errorMessage != nil },
                set: { if !$0 { myfilesvm.errorMessage = nil } }
            ), message: myfilesvm.errorMessage)

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
                    await myfilesvm.getPackageFilesList()
                }
            }
//            .frame(height: 600)

//            .navigationBarHidden(true)
//        }
    }
}

#Preview {
    ActiveCustPackFiles()
}
