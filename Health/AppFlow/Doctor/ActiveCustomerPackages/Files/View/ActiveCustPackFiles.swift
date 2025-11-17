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
import UniformTypeIdentifiers

struct ActiveCustPackFiles : View {
    var customerId:Int?
    var CustomerPackageId:Int?

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
                
                if filesCase == .Packages{
                    UploadButton {
                        Task{
                            showUploadSheet = true
                            await lookupsvm.getFileTypes()
                        }
                    }
                    .padding([.horizontal])
                    //                .padding(.top,30)
                }
                
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

            .customSheet(isPresented: $myfilesvm.showUploadSheet,height: 440){
                ReusableUploadFileSheetView(isPresented: $myfilesvm.showUploadSheet){file in
                    myfilesvm.fileName = file.fileName
                          myfilesvm.fileType = file.fileType
                          myfilesvm.fileLink = file.link
                          myfilesvm.image = file.image
                          myfilesvm.fileURL = file.fileURL

                          Task { await myfilesvm.addNewPackageFile() }
                }
//                    .environmentObject(myfilesvm)
                    .environmentObject(lookupsvm)
//                    .frame(height: 600)

//                { newFile in
//                    files.append(newFile)
//                }
            }
            .onAppear(){
                Task{
                    myfilesvm.CustomerId = customerId
                    myfilesvm.customerPackageId = CustomerPackageId
                    await myfilesvm.getPackageFilesList()
                }
            }
            .onChange(of: filesCase){ newval in
                if newval != filesCase{
                    switch newval {
                    case .Customer:
                        Task{
                            await myfilesvm.getCustomerFilesList()
                        }
                    case .Packages:
                        Task{
                            await myfilesvm.getPackageFilesList()
                        }

                    }
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


struct UploadFilePayload {
    var fileName: String?
    var fileType: FileTypeM?
    var link: String?
    var image: UIImage?
    var fileURL: URL?
}
struct ReusableUploadFileSheetView: View {
    @EnvironmentObject var lookupsvm : LookupsViewModel
    @Binding var isPresented: Bool

    // Callback returns the selected file payload
    var onSubmit: (UploadFilePayload) -> Void

    @State private var fileName: String = ""
    @State private var fileType: FileTypeM? = nil
    @State private var fileLink: String = ""

    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage?

    @State private var showPdfPicker = false
    @State private var fileURL: URL?

    @State private var pickedFileName: String = ""

    var body: some View {
        VStack(spacing: 20) {

            // ---------- HEADER ----------
            HStack {
                ZStack {
                    Color(.secondary).cornerRadius(3)
                    Image("uploadIcon")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 14, height: 14)
                }
                .frame(width: 22, height: 22)

                Text("upload_New_File".localized)
                    .font(.semiBold(size: 22))
                    .foregroundColor(Color("mainBlue"))

                Spacer()

                Button { isPresented = false } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(.secondary))
                }
            }
            .padding(.top, 20)

            // ---------- FORM FIELDS ----------
            Group {

                // File Name
                CustomDropListInputFieldUI(
                    title: "new_fileName",
                    placeholder: "new_filenameplaceholder",
                    text: $fileName,
                    isDisabled: false,
                    showDropdownIndicator: false,
                    trailingView: AnyView(Image("newfienameIcon"))
                )

                // File Types
                Menu {
                    ForEach(lookupsvm.fileTypes ?? [], id: \.id) { type in
                        Button(type.type ?? "") {
                            fileType = type
                        }
                    }
                } label: {
                    CustomDropListInputFieldUI(
                        title: "new_fileType",
                        placeholder: "new_filetypeplaceholder",
                        text: .constant(fileType?.type ?? ""),
                        isDisabled: true,
                        showDropdownIndicator: true,
                        trailingView: AnyView(Image("dateicon 1"))
                    )
                }

                // If type = Link → show text input
                if fileType?.id == 0 || fileType == nil {
                    CustomDropListInputFieldUI(
                        title: "new_filelink",
                        placeholder: "new_filelinkplaceholder",
                        text: $fileLink,
                        isDisabled: false,
                        showDropdownIndicator: false,
                        trailingView: AnyView(Image("newfilelinkicon"))
                    )

                } else {
                    // Upload button
                    CustomDropListInputFieldUI(
                        title: "new_fileupload",
                        placeholder: "new_fileuploadplaceholder",
                        text: $pickedFileName,
                        isDisabled: true,
                        showDropdownIndicator: false,
                        trailingView: AnyView(
                            Image("uploadIcon")
                                .renderingMode(.template)
                                .foregroundStyle(Color(.secondary))
                                .frame(width: 14, height: 14)
                        )
                    )
                    .onTapGesture {
                        switch fileType?.id {
                        case 2:
                            showImagePicker = true
                        default:
                            showPdfPicker = true
                        }
                    }
                }
            }

            // ---------- ACTION BUTTONS ----------
            HStack(spacing: 12) {

                CustomButton(
                    title: "new_cancel_",
                    backgroundView: AnyView(Color(.secondary))
                ) {
                    resetState()
                    isPresented = false
                }

                CustomButton(
                    title: "new_confirm_",
                    backgroundcolor: Color(.secondary)
                ) {
                    let payload = UploadFilePayload(
                        fileName: fileName,
                        fileType: fileType,
                        link: fileLink.isEmpty ? nil : fileLink,
                        image: image,
                        fileURL: fileURL
                    )

                    onSubmit(payload)   // ← send back to parent
                }
            }
            .padding(.bottom, 16)

        }
        .onAppear {
            lookupsvm.fileTypes?.insert(FileTypeM(id: 0, type: "Link".localized), at: 0)
        }
        .padding()

        // ---------- PICKERS ----------
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImage: $image, sourceType: imagePickerSource)
        }
        .onChange(of: image) { _ in
            pickedFileName = "Image is Selected Successfully_".localized
        }

        .fileImporter(
            isPresented: $showPdfPicker,
            allowedContentTypes: [.pdf, .plainText, .data, UTType(filenameExtension: "doc")!],
            allowsMultipleSelection: false
        ) { result in
            do {
                if let file = try result.get().first {
                    pickedFileName = file.lastPathComponent
                    fileURL = file
                }
            } catch {
                print("File picker error:", error.localizedDescription)
            }
        }
    }

    private func resetState() {
        fileName = ""
        fileType = nil
        fileLink = ""
        image = nil
        fileURL = nil
        pickedFileName = ""
    }
}
