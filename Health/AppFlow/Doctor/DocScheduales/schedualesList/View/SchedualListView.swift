//
//  SchedualListView.swift
//  Sehaty
//
//  Created by mohamed hammam on 01/12/2025.
//

import SwiftUI

struct SchedualListView: View{
    
    @EnvironmentObject var profileViewModel: EditProfileViewModel
    @StateObject var router = NavigationRouter.shared
    @StateObject private var viewModel = DocSchedualeViewModel.shared
    var hasbackBtn : Bool? = true
    //    var onBack: (() -> Void)? // for uikit dismissal
    
//    @State var showCancel: Bool = false
    @State var idToDelete: Int?
    
//    @State var destination = AnyView(EmptyView())
    @State var mustLogin: Bool = false
    //    @State var isactive: Bool = false
    //    func pushTo(destination: any View) {
    //        self.destination = AnyView(destination)
    //        self.isactive = true
    //    }
    @State private var showDialog = false

    init(hasbackBtn : Bool? = true) {
        self.hasbackBtn = hasbackBtn
        //        self.onBack = onBack
    }
    
        var body: some View {
            //        NavigationView(){
            ZStack {
                VStack(spacing:0){
                    VStack(){
                        TitleBar(title: "doc_myscehdules",titlecolor: .white,hasbackBtn: hasbackBtn ?? true)
                            .padding(.top,55)
                        
                        VStack(spacing:5){
                            
                            if let imageURL = profileViewModel.imageURL{
                                KFImageLoader(url:URL(string:Constants.imagesURL + (imageURL.validateSlashs())),placeholder: Image(.onboarding1), isOpenable:true, shouldRefetch: false)
                                    .clipShape(Circle())
                                    .background(Circle()
                                        .stroke(.white, lineWidth: 5).padding(-2))
                                    .frame(width: 91,height:91)
                                if profileViewModel.Name.count > 0{
                                    Text(profileViewModel.Name)
                                        .font(.bold(size: 24))
                                        .foregroundStyle(Color.white)
                                }else{
                                    Text("home_Welcome".localized)
                                        .font(.semiBold(size: 14))
                                        .foregroundStyle(Color.white)
                                }
                            }else{
                                Spacer()
                            }
                        }
                        .background{
                            Image(.logoWaterMarkIcon)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fill)
                                .foregroundStyle(.white)
                                .allowsHitTesting(false)
                                .frame(width: UIScreen.main.bounds.width)
                        }
                        .padding(.vertical,10)
                    }
                    .frame(height: 232)
                    .horizontalGradientBackground()
                                        
                    Spacer()
                    
                    // MARK: Days and Slots
                    ScrollView {
                        Button(action: {
                            router.push(DocScheduleView(schedualeId: nil).environmentObject(profileViewModel))
                        }) {
                            HStack {
                                Text("add_available_scheduale".localized)
                                    .font(.bold(size: 24))
                              
                                ZStack{
                                    Color(.white)
                                        .cornerRadius(3)
                                    
                                    Image(systemName: "plus")
                                        .renderingMode(.template)
                                        .resizable()
                                        .foregroundStyle(Color(.secondary))
                                        .frame(width: 18,height: 18)
                                }
                                .frame(width: 40,height: 40)

                            }
                            .foregroundColor(.white)
                            .padding(10)
                            .horizontalGradientBackground()
                            .cornerRadius(3)
                        }
                        VStack(alignment: .leading, spacing: 16) {
                            if let Scheduales = viewModel.scheduales {
                            ForEach( Scheduales, id: \.self) { scheduale in
                                    ScheduleCellView(model: scheduale,onEdit: {
                                        router.push(DocScheduleView(schedualeId: scheduale.id).environmentObject(profileViewModel))

                                    },onDelete: {
//                                        viewModel.DeleteScheduale()
                                        idToDelete = scheduale.id
                                        showDialog = true
                                    })
                                }
                            }else{
//                                
                            }

                        }
                        .padding()
                        // MARK: Footer Buttons
//                        HStack(spacing: 4) {
//                            CustomButton(title: "new_confirm_",backgroundcolor: Color(.mainBlue)){
//                                print("Selected Slots:", viewModel.selectedSlots)
//                                showDialog = true
//                            }
//                            CustomButton(title: "remove_all_btn",backgroundView : AnyView(Color(.secondary))){
//                                viewModel.clear()
//                            }
//                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    //            }
                    
                    Spacer().frame(height: hasbackBtn ?? true ? 0 : 80)
                    
                }
                .localizeView()
                //            .withNavigation(router: router)
                .showHud(isShowing:  $viewModel.isLoading)
                .errorAlert(isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                ), message: viewModel.errorMessage)
                .edgesIgnoringSafeArea([.top,.horizontal])
                .task{
//                    Task{
                        if (Helper.shared.CheckIfLoggedIn()) {
                            async let Profile:() = profileViewModel.getProfile()
                                async let scheduales:() = viewModel.getMyScheduales()
                            //                    await viewModel.getSubscripedPackages()
                            _ = await (Profile,scheduales)
                        } else {
                            profileViewModel.cleanup()
                            viewModel.clear()
                            mustLogin = true
                        }
//                    }
                }
                .refreshable {
                    if (Helper.shared.CheckIfLoggedIn()) {
                        async let Profile:() = profileViewModel.getProfile()
                            async let scheduales:() = viewModel.refreshScheduales()
                        //                    await viewModel.getSubscripedPackages()
                        _ = await (Profile,scheduales)
                    } else {
                        profileViewModel.cleanup()
                        viewModel.clear()
                        mustLogin = true
                    }
                }
                
                
                if showDialog {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showDialog = false
                        }

                    ConfirmationDialogView(
                        iconName: "remove_trash", // your asset
                        message: "confirm_del_title",
                        confirmTitle: "new_confirm_",
                        cancelTitle: "cancel_",
                        onConfirm: {
                            print("Confirmed")
                            guard let idToDelete = self.idToDelete else { return }
                            Task{ await viewModel.DeleteScheduale(Id: idToDelete)}
                            showDialog = false
                        },
                        onCancel: {
                            showDialog = false
                        }
                    )
                }
            }
            .localizeView()
            .withNavigation(router: router)
            .showHud(isShowing:  $viewModel.isLoading)
            .errorAlert(isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            ), message: viewModel.errorMessage)

//            .fullScreenCover(isPresented: $viewModel.showSuccess, onDismiss: {}, content: {
//               AnyView( DocSchedualeSelectedView() )
//            })
            .customSheet(isPresented: $mustLogin ,height: 350){
                LoginSheetView()
            }
            
        }
}

#Preview {
    SchedualListView()
        .environmentObject(EditProfileViewModel.shared)
}

struct ScheduleCellView: View {
    let model: SchedualeM
    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
            HStack {
                                
                // MARK: - Dates Section
//                VStack(alignment: .trailing, spacing: 16) {
                    
                // من تاريخ
                VStack(alignment: .leading, spacing: 10) {
                    Text("from_date".localized)
                        .font(.medium(size: 14))
                        .foregroundColor(Color(.secondaryMain))
                    
                    HStack(spacing: 6) {
                        Image(.dateicon1)
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(model.formattedstartdate ?? "")
                            .font(.medium(size: 14))
                            .foregroundColor(Color(.mainBlue))
                    }
                }
                    
                Spacer()
                
                // إلى تاريخ
                VStack(alignment: .leading, spacing: 10) {
                    Text("to_date".localized)
                        .font(.regular(size: 14))
                        .foregroundColor(Color(.secondaryMain))
                    
                    HStack(spacing: 6) {
                        Image(.dateicon1)
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(model.formattedenddate ?? "")
                            .font(.medium(size: 14))
                            .foregroundColor(Color(.mainBlue))
                    }
                }
//                }
                
                Spacer()
                
                // MARK: - Edit + Delete Buttons
                VStack(alignment: .leading, spacing: 10) {
                    
                    // تعديل
                    if let onEdit = onEdit {
                        Button(action: onEdit) {
                            HStack(spacing: 4) {
                                Image(.newediticon)
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                    .foregroundColor(Color("secondary"))
                                
                                Text("edit_".localized)
                                    .font(.medium(size: 14))
                                    .foregroundColor(Color("mainBlue"))
                                    .underline()
                            }
                        }
                    }
                    
                    // حذف
                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            HStack(spacing: 4) {
                                Image(.removeTrash)
                                    .resizable()
                                    .frame(width: 14, height: 16)
                                    .foregroundColor(.red)
                                
                                Text("delete_".localized)
                                    .font(.medium(size: 14))
                                    .foregroundColor(Color("mainBlue"))
                                    .underline()
                            }
                        }
                    }
                }
            }
            .padding(20)
        
        .background(Color.white)
        .cardStyle(cornerRadius: 3,shadowOpacity: 0.1)
//        .cornerRadius(10)
//        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
//        .padding(.horizontal)
//        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Helper
private func displayDate(_ dateString: String?) -> String {
    guard let dateString = dateString else { return "---" }
    return dateString.ChangeDateFormat(
        FormatFrom: "yyyy-MM-dd'T'HH:mm:ss",
        FormatTo: "dd/MM/yyyy"
    )
}
