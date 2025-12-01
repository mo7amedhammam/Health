//
//  DocScheduleView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/08/2025.
//

import SwiftUI

struct DocScheduleView: View {
    
    @EnvironmentObject var profileViewModel: EditProfileViewModel
//    @StateObject var router = NavigationRouter.shared
    @StateObject private var viewModel = DocSchedualeViewModel.shared
    var hasbackBtn : Bool? = true
    //    var onBack: (() -> Void)? // for uikit dismissal
    
//    @State var showCancel: Bool = false
//    @State var idToCancel: Int?
    
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
                    
                    SectionHeader(image: Image(.docSchedIc), title: "select_available_time_slots",subTitle: Text("select_available_time_slots_subtitle".localized)
                        .foregroundStyle(Color(.secondary))
                        .font(.medium(size: 10))
                        .frame(maxWidth:.infinity,alignment: .leading), MoreBtnimage: nil
                    )
                    .padding([.horizontal, .top])
                    
                    
                    Spacer()
                    
                    
                    // MARK: Days and Slots
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.days, id: \.self) { day in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(day)
                                        .font(.bold(size: 20))
                                        .foregroundColor(.mainBlue)
                                    
                                    HStack(spacing: 8) {
                                        ForEach(viewModel.slots, id: \.title) { slot in
                                            let isSelected = viewModel.selectedSlots[day]?.contains(slot) ?? false
                                            
                                            VStack(spacing: 4) {
                                                Text(slot.title)
                                                    .font(.bold(size: 14))
                                                Text(slot.time)
                                                    .font(.medium(size: 10))
                                            }
                                            .padding(8)
                                            .frame(maxWidth: .infinity)
                                            .background(isSelected ? Color(.secondary) : Color("wrongsurface") )
                                            .foregroundStyle(isSelected ? Color(.white) : Color(.secondary))
                                            .cornerRadius(3)
                                            .onTapGesture {
                                                viewModel.toggleSlot(day: day, slot: slot)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        
                        // MARK: Footer Buttons
                        HStack(spacing: 4) {
                            CustomButton(title: "new_confirm_",backgroundcolor: Color(.mainBlue)){
                                print("Selected Slots:", viewModel.selectedSlots)
                                showDialog = true
                            }
                            CustomButton(title: "remove_all_btn",backgroundView : AnyView(Color(.secondary))){
                                viewModel.clear()
                            }
                        }
                    }
                    
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
                .onAppear {
                    Task{
                        if (Helper.shared.CheckIfLoggedIn()) {
                            async let Profile:() = profileViewModel.getProfile()
                            //                        async let Packages:() = viewModel.refresh()
                            //                    await viewModel.getSubscripedPackages()
                            _ = await (Profile)
                            
                            //                        print("Items count:", viewModel.subscripedPackages?.items?.count ?? -1)
                            //                           print("Items:", viewModel.subscripedPackages?.items ?? [])
                        } else {
                            profileViewModel.cleanup()
                            viewModel.clear()
                            mustLogin = true
                        }
                    }
                }
                
                
                if showDialog {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showDialog = false
                        }

                    ConfirmationDialogView(
                        iconName: "doc_sched_ic", // your asset
                        message: "confirm_title",
                        confirmTitle: "new_confirm_",
                        cancelTitle: "cancel_",
                        onConfirm: {
                            print("Confirmed")
                            Task{ await viewModel.CreateOrUpdateScheduales()}
                            showDialog = false
                        },
                        onCancel: {
                            showDialog = false
                        }
                    )
                }
            }
            .fullScreenCover(isPresented: $viewModel.showSuccess, onDismiss: {}, content: {
               AnyView( DocSchedualeSelectedView() )
            })
            
        }
}
#Preview {
    DocScheduleView().environmentObject(EditProfileViewModel.shared)
}

extension DocScheduleView{
    private func DocSchedualeSelectedView()->any View {
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
                
                viewModel.showSuccess = false
            }
        )
//        let newVC = UIHostingController(rootView: successView)
//        Helper.shared.changeRootVC(newroot: newVC, transitionFrom: .fromLeft)
        return successView
    }
}
