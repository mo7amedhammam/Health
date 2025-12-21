//
//  MyFilesView.swift
//  Sehaty
//
//  Created by mohamed hammam on 24/06/2025.
//

import SwiftUI
import UniformTypeIdentifiers
//import _PhotosUI_SwiftUI

struct MyFileModel: Identifiable {
    let id = UUID()
    var name: String
    var type: String
    var link: String? = nil
    var fileData: Data? = nil
}

struct MyFilesView: View {
//    @State private var showUploadSheet = false
    @StateObject var myfilesvm = MyFilesViewModel.shared

    @State private var files: [MyFileModel] = []
    @StateObject var lookupsvm = LookupsViewModel.shared

    var body: some View {
        VStack(spacing: 0) {
            TitleBar(title: "MyFiles_Title",hasbackBtn: true)
                        UploadButton {
                            Task{
                                myfilesvm.showUploadSheet = true
                                await lookupsvm.getFileTypes()
                            }
                        }
                        .padding([.top,.horizontal])
                        .padding(.top,30)

                        SectionHeader(image: Image("docicon"),title: "Files_")
                            .padding([.top,.horizontal])
                            .padding(.top,20)

                        filesList(files: myfilesvm.files)
                .refreshable {
                    await myfilesvm.refresh()
                }
        }
        .localizeView()
        .showHud(isShowing:  $myfilesvm.isLoading)
        .errorAlert(isPresented: Binding(
            get: { myfilesvm.errorMessage != nil },
            set: { if !$0 { myfilesvm.errorMessage = nil } }
        ), message: myfilesvm.errorMessage)

        .customSheet(isPresented: $myfilesvm.showUploadSheet,height: 440){
//            .sheet(isPresented: $showUploadSheet) {
//                UploadFileSheetView(isPresented: $myfilesvm.showUploadSheet)
//                    .environmentObject(myfilesvm)
//                    .environmentObject(lookupsvm)
            
            ReusableUploadFileSheetView(isPresented: $myfilesvm.showUploadSheet){file in
                myfilesvm.fileName = file.fileName
                      myfilesvm.fileType = file.fileType
                      myfilesvm.fileLink = file.link
                      myfilesvm.image = file.image
                      myfilesvm.fileURL = file.fileURL

                      Task { await myfilesvm.addNewFile() }
            }
            .environmentObject(lookupsvm)

//                    .frame(height: 600)

//                { newFile in
//                    files.append(newFile)
//                }
        }
        .task {
              if myfilesvm.files.isEmpty {
                  await myfilesvm.getMyFilesList()
              }
          }
//        .onAppear(){
//            Task{
//                await myfilesvm.getMyFilesList()
//            }
//        }
//        .frame(height: 600)

//        .navigationBarHidden(true)
//    }
    }
}

#Preview {
    MyFilesView()
}


struct UploadButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text("upload_New_File".localized)
                    .font(.bold(size: 24))
              
                ZStack{
                    Color(.white)
                        .cornerRadius(3)
                    
                    Image("uploadIcon")
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


struct UploadFileSheetView: View {
    @EnvironmentObject var lookupsvm : LookupsViewModel
    @EnvironmentObject var myfilesvm : MyFilesViewModel
    @Binding var isPresented: Bool
    
    @State private var fileName: String = ""
    @State private var fileType: FileTypeM? = nil
    @State private var fileLink: String = ""
    
//    @State private var showPickerOptions = false

    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage?

    @State private var showPdfPicker = false
    @State private var fileURL: URL?
    
    @State private var pickedFileName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                
                ZStack{
                    Color(.secondary)
                        .cornerRadius(3)
                    
                    Image("uploadIcon")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(Color(.white))
                        .frame(width: 14,height: 14)
                }
                .frame(width: 22,height: 22)
                
                Text("upload_New_File".localized)
                    .font(.semiBold(size: 22))
                    .foregroundColor(Color("mainBlue"))
                
                Spacer()
              
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(.secondary))
                }
                
            }
            .padding(.top, 20)

            Group {

                CustomDropListInputFieldUI(title: "new_fileName", placeholder: "new_filenameplaceholder",text: $fileName, isDisabled: false, showDropdownIndicator:false, trailingView: AnyView(Image("newfienameIcon")))
                
                        Menu {
                            ForEach(lookupsvm.fileTypes ?? [],id: \.id) { type in
                                Button(action: {
                                    fileType = type
                                }, label: {
                                    Text(type.type ?? "")
                                        .font(.semiBold(size: 12))
                                })
                                
                            }
                        } label: {
                            CustomDropListInputFieldUI(title: "new_fileType", placeholder: "new_filetypeplaceholder",text: .constant(fileType?.type ?? ""), isDisabled: true, showDropdownIndicator:true, trailingView: AnyView(Image("dateicon 1")))
                        }
//                        .onTapGesture{
//                            Task{
//                                if lookupsvm.fileTypes?.count ?? 0 == 0 {
//                                    await lookupsvm.getFileTypes()
//                                }
//                            }
//                        }
                    
                if fileType == nil {
                    CustomDropListInputFieldUI(title: "new_filelink", placeholder: "new_filelinkplaceholder",text: $fileLink, isDisabled: false, showDropdownIndicator:false, trailingView: AnyView(Image("newfilelinkicon")))

                }else{
                    CustomDropListInputFieldUI(title: "new_fileupload", placeholder: "new_fileuploadplaceholder",text: $pickedFileName, isDisabled: true, showDropdownIndicator:false, trailingView:
                                                AnyView( Image("uploadIcon")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .foregroundStyle(Color(.secondary))
                                                    .frame(width: 14,height: 14)
                                                ))
                    .onTapGesture {
                        switch fileType?.id {
                        case 0:
                            break
//                        case 1:
//                            showPdfPicker = true
                        case 2:
                            showImagePicker = true
                        default:
                            showPdfPicker = true
                        }
                    }
                }
            }

            HStack(spacing: 12) {
                
                CustomButton(title: "new_cancel_",backgroundView : AnyView(Color(.secondary))){
//                    isPresented = false
                    myfilesvm.clearNewFiles()
                }
                
                CustomButton(title: "new_confirm_",backgroundcolor: Color(.secondary)){
                    myfilesvm.fileName = fileName
                    myfilesvm.fileType = fileType
                    myfilesvm.fileLink = fileLink
                    myfilesvm.image = image
                    myfilesvm.fileURL = fileURL
                    Task{ await myfilesvm.addNewFile() }
                }
            }
            .padding(.bottom, 16)

        }
        .onAppear(perform: {
            Task{
//                   await lookupsvm.getFileTypes()
                    lookupsvm.fileTypes?.insert(FileTypeM.init(id: 0, type: "Link".localized), at: 0)
            }
        })
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImage: $image, sourceType: imagePickerSource)
        }.onChange(of: image){newval in
            pickedFileName = "Image is Selected Successfully_".localized
        }
        .fileImporter(
            isPresented: $showPdfPicker,
            allowedContentTypes: [.pdf, .plainText, .data, UTType(filenameExtension: "doc")!],
            allowsMultipleSelection: false
        ) { result in
            do {
                let file = try result.get().first
                if let file = file {
                    pickedFileName = file.lastPathComponent
//                    fileData = try Data(contentsOf: file)
                    fileURL = file
                }
            } catch {
                print("Error picking file: \(error.localizedDescription)")
            }
        }
 
    }
}

struct LabeledInputField: View {
    var icon: String
    var title: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.pink)
            VStack(alignment: .trailing) {
                Text(title)
                    .foregroundColor(Color("mainBlue"))
                    .font(.headline)
                TextField(placeholder, text: $text)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct FilePickerButton: View {
    @Binding var fileURL: URL?
    @Binding var fileData: Data?
    @State private var showPicker = false

    var body: some View {
        Button(action: {
            showPicker.toggle()
        }) {
            HStack {
                Image(systemName: "doc.badge.plus")
                Text(fileURL?.lastPathComponent ?? "jpg, png, pdf")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .fileImporter(
            isPresented: $showPicker,
            allowedContentTypes: [.pdf, .image, .data, .plainText, UTType(filenameExtension: "doc")!],
            allowsMultipleSelection: false
        ) { result in
            do {
                let file = try result.get().first
                fileURL = file
                fileData = try Data(contentsOf: file!)
            } catch {
                print("File picking failed: \(error.localizedDescription)")
            }
        }
    }
}


struct CustomDropListInputFieldUI: View {
    var title: String
    var placeholder: String
    @Binding var text: String
//    var isSecure: Bool = false
//    var showToggle: Bool = false
    var isValid: Bool = true
    var isDisabled: Bool? = false
    var showDropdownIndicator: Bool? = true
    
    /// Optional trailing view (e.g. icon, icon+arrow)
    var trailingView: AnyView? = nil
    
//    @State private var isPasswordVisible = false
    @State private var isMenuPresented = false

    var body: some View {
        let borderColor = isValid ? Color.gray.opacity(0.4) : Color(.wrong)
        let textColor = isValid ? Color(.mainBlue) : Color(.wrong)
        
        VStack(spacing: 2) {
            
            HStack {
                Text(title.localized)
                    .font(.semiBold(size: 20))
                    .foregroundColor(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let view = trailingView {
                    view
                }
            }
            
            HStack(spacing: 8) {
                TextFieldWrapper
                    .frame(height: 32)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .disabled(isDisabled ?? false )
                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .onTapGesture {
//                        isMenuPresented.toggle()
//                    }

                if showDropdownIndicator ?? true {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 12, height: 6)
                        .foregroundColor(.gray)
                }
                
                
//                if let view = trailingView {
//                    view
//                }
                
//                if showToggle {
//                    Button(action: {
//                        isPasswordVisible.toggle()
//                    }) {
//                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
//                            .foregroundColor(isValid ? Color(.secondary):textColor)
//                            .frame(width: 20, height: 20)
//                    }
//                }
            }
        
            Divider()
                .frame(height: 1.5)
                .background(borderColor)
        }
        .padding(.horizontal, 12)
//        .padding(.trailing, 12)
        .padding(.top, 12)
        .localizeView()
    }
    
    @ViewBuilder
    private var TextFieldWrapper: some View {
//        if isSecure && !isPasswordVisible {
////            SecureField(placeholder.localized, text: $text)
////                .padding(.leading, 4)
////                .font(.medium(size: 16))
////                .foregroundColor(isValid ? Color(.mainBlue) : Color(.wrong))
//        } else {
        
            TextField(placeholder.localized, text: $text)
                .padding(.leading, 4)
                .font(.medium(size: 16))
                .foregroundColor(isValid ? Color(.mainBlue) : Color(.wrong))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
//        }

    }
}


import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
