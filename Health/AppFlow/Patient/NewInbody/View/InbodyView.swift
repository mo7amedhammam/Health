//
//  InbodyView.swift
//  Sehaty
//
//  Created by mohamed hammam on 29/07/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct InbodyView: View {
    @StateObject var router:NavigationRouter = NavigationRouter.shared
    @State private var showUploadSheet = false
    @StateObject var viewmodel = InbodyViewModel.shared

//    @State private var files: [MyFileModel] = []
//    @StateObject var lookupsvm = LookupsViewModel.shared
    @State private var showFileTypeDialog = false
    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage?

    @State private var showPdfPicker = false
    @State private var fileURL: URL?
    
    @State private var pickedFileName: String = ""

    var body: some View {
//        NavigationView {
            VStack(spacing: 0) {
                TitleBar(title: "Inbody_Title",hasbackBtn: true)

                newInbodyButton {
                    Task{
                        viewmodel.showAddSheet = true
//                        await lookupsvm.getFileTypes()
                    }
                }
                .padding([.top,.horizontal])
                .padding(.top,30)

                inbodiesList(files:viewmodel.files?.items ,onSelect: {file in
                    router.push(InbodyDetailsView(report: file))
                },loadMore: {
                    Task {
                        await viewmodel.loadMoreIfNeeded()
                    }
                })
                .refreshable {
                    await viewmodel.refresh()
                }
                Spacer()
            }
            .withNavigation(router: router)
            .localizeView()
            .showHud(isShowing: $viewmodel.isLoading)
            .errorAlert(isPresented: Binding(
                get: { viewmodel.errorMessage != nil && !viewmodel.showAddSheet },
                set: { if !$0 { viewmodel.errorMessage = nil } }
            ), message: viewmodel.errorMessage)
            .customSheet(isPresented: $viewmodel.showAddSheet,height: 470){
                UploadInbodySheetView( isPresented: $viewmodel.showAddSheet)
                    .environmentObject(viewmodel)
            }
//            .task(){
////                Task{
//                    await viewmodel.refresh()
////                }
//            }

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
                
                Text("upload_New_Inbody".localized)
                    .font(.bold(size: 24))

            }
            .foregroundColor(.white)
            .padding(10)
            .horizontalGradientBackground()
            .cornerRadius(3)
        }
    }
}

struct inbodiesList:View {
    var files:[InbodyListItemM]?
    var onSelect:((InbodyListItemM)->Void)?
    var loadMore: (() -> Void)?

    var body: some View {
        
        GeometryReader{ geometry in
            ScrollView{
                if let files = files, files.count > 0{
                    LazyVStack{
                    //                    VStack(spacing: 0) {
                    Spacer()
                    ForEach(files,id: \.self) { file in
                        Button(action: {
                            onSelect?(file)
                        },label:{
                            VStack(spacing:12) {
                                HStack(alignment: .top){
                                    
                                    Image(.inbodyIcon)
                                    
                                    VStack(alignment: .leading,spacing: 12){
                                        Text(file.title ?? "")
                                            .font(.semiBold(size: 16))
                                            .foregroundStyle(Color(.main))
                                        
                                        Text(file.formattedCreationDate ?? "")
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
                                    
                                    Text(file.comment ?? "" )
                                        .font(.regular(size: 14))
                                        .foregroundStyle(Color(.main))
                                        .lineSpacing(10)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                                .frame(maxWidth:.infinity,alignment: .leading)
                                
                                //                            if file != files.last{
                                //                                Color.gray.opacity(0.12)
                                //                                    .frame(height:1)
                                //                                    .padding(.horizontal)
                                //                            }
                                
                            }
                            .padding([.horizontal,.vertical])
                        })
                        .onAppear {
                            if file == files.last {
                                loadMore?()
                            }
                        }
                        
                    }
                    //                    }
                    .padding(.bottom,5)
                    .cardStyle(cornerRadius: 6,shadowOpacity: 0.12)
                    .padding(.horizontal)
                    
                }
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


struct UploadInbodySheetView: View {
//    @EnvironmentObject var lookupsvm : LookupsViewModel
    @EnvironmentObject var viewmodel : InbodyViewModel
    @Binding var isPresented: Bool
    
    @State private var fileName: String = ""
//    @State private var fileType: FileTypeM? = nil
    @State private var fileLink: String = ""
    
//    @State private var showPickerOptions = false
    @State private var showFileTypeDialog = false
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
                    viewmodel.removeInputs()
                }) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(.secondary))
                }
                
            }
            .padding(.top, 20)

            Group {

//                CustomDropListInputFieldUI(title: "new_fileName", placeholder: "new_filenameplaceholder",text: $viewmodel.fileName, isDisabled: false, showDropdownIndicator:false, trailingView: AnyView(Image("newfienameIcon")))
             
                CustomDatePickerField(selectedDate: $viewmodel.date) {
                    HStack {
                        CustomDropListInputFieldUI(title: "new_filedate", placeholder: "new_filedateplaceholder",text: $viewmodel.formattedDate, isDisabled: true, showDropdownIndicator:false, trailingView: AnyView(Image("dateicon 1")))
                    }
                }

                CustomDropListInputFieldUI(title: "new_filecomments", placeholder: "new_filecommentsplaceholder",text: $viewmodel.Comment, isDisabled: false, showDropdownIndicator:false, trailingView: AnyView(Image("messagecentrepopup")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(Color(.secondary))
                    .frame(width: 16,height: 16)
                ))

//                        Menu {
//                            ForEach(lookupsvm.fileTypes ?? [],id: \.id) { type in
//                                Button(action: {
//                                    fileType = type
//                                }, label: {
//                                    Text(type.type ?? "")
//                                        .font(.semiBold(size: 12))
//                                })
//                                
//                            }
//                        } label: {
//                            CustomDropListInputFieldUI(title: "new_fileType", placeholder: "new_filetypeplaceholder",text: .constant(fileType?.type ?? ""), isDisabled: true, showDropdownIndicator:true, trailingView: AnyView(Image("dateicon 1")))
//                        }
//                        .onTapGesture{
//                            Task{
//                                if lookupsvm.fileTypes?.count ?? 0 == 0 {
//                                    await lookupsvm.getFileTypes()
//                                }
//                            }
//                        }
                    
//                if fileType == nil {
//                    CustomDropListInputFieldUI(title: "new_filelink", placeholder: "new_filelinkplaceholder",text: $fileLink, isDisabled: false, showDropdownIndicator:false, trailingView: AnyView(Image("newfilelinkicon")))
//
//                }else{
                    CustomDropListInputFieldUI(title: "new_fileupload", placeholder: "new_fileuploadplaceholder",text: $pickedFileName, isDisabled: true, showDropdownIndicator:false, trailingView:
                                                AnyView( Image("uploadIcon")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .foregroundStyle(Color(.secondary))
                                                    .frame(width: 14,height: 14)
                                                ))
                    .onTapGesture {
                        showFileTypeDialog = true
//                        switch fileType?.id {
//                        case 0:
//                            break
////                        case 1:
////                            showPdfPicker = true
//                        case 2:
//                            showImagePicker = true
//                        default:
//                            showPdfPicker = true
//                        }
                    }
//                }
            }

            HStack(spacing: 12) {
                CustomButton(title: "new_cancel_",backgroundView : AnyView(Color(.secondary))){
                    isPresented = false
                    viewmodel.removeInputs()
                }
                
                CustomButton(title: "new_confirm_",backgroundcolor: Color(.secondary)){
                    Task{
                      await viewmodel.addNewInbody()
                    }
                }
            }
            .padding(.bottom, 16)

        }
//        .onAppear(perform: {
//            Task{
////                   await lookupsvm.getFileTypes()
//                    lookupsvm.fileTypes?.insert(FileTypeM.init(id: 0, type: "Link".localized), at: 0)
//            }
//        })
        .padding()
        .confirmationDialog("", isPresented: $showFileTypeDialog) {
            Button("Image".localized) {
                imagePickerSource = .photoLibrary
                showImagePicker = true
            }
            Button("PDF".localized) {
                showPdfPicker = true
            }
            Button("cancel_".localized, role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImage: $image, sourceType: imagePickerSource)
        }.onChange(of: image){newval in
            pickedFileName = "Image is Selected Successfully_".localized
            viewmodel.image = newval
        }
        .fileImporter(
            isPresented: $showPdfPicker,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) { result in
            do {
                if let file = try result.get().first {
                    let _ = file.startAccessingSecurityScopedResource() // ✅ Start accessing

                    pickedFileName = file.lastPathComponent
                    viewmodel.fileURL = file

                    // Optional: You can also test reading it immediately
                    do {
                        let data = try Data(contentsOf: file)
                        print("PDF loaded: \(data.count) bytes")
                    } catch {
                        print("Failed to read file after access start: \(error)")
                    }

                    // Note: call stopAccessingSecurityScopedResource() *after* you're done (e.g. in viewModel)
//                     file.stopAccessingSecurityScopedResource()

                }
            } catch {
                print("Error picking file: \(error.localizedDescription)")
            }
        }
        .errorAlert(isPresented: Binding(
            get: { viewmodel.errorMessage != nil },
            set: { if !$0 { viewmodel.errorMessage = nil } }
        ), message: viewmodel.errorMessage)

 
    }
}
