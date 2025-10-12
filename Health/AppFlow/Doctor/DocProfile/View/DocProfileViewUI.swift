//
//  DocProfileViewUI.swift
//  Sehaty
//
//  Created by mohamed hammam on 31/08/2025.
//

import SwiftUI

struct DocProfileViewUI: View {
    @StateObject var router = NavigationRouter()

    //    @StateObject var localizationManager = LocalizationManager.shared
    @StateObject private var paymentsVM = DocPaymentsViewModel.shared
    @ObservedObject var localizationManager = LocalizationManager.shared
    @EnvironmentObject var viewModel: EditProfileViewModel
    @State private var showLogoutAlert = false

    @State var isLogedin = Helper.shared.CheckIfLoggedIn()
    
    var body: some View {
        VStack {
            TitleBar(title: "profile_title")
            
            List {
                Group{
                    if isLogedin{
                        // Profile Header Section
                        Section {
                            HStack(spacing: 16) {
                                
                                // Profile Image with Border and Edit Button
//                                ZStack(alignment: .bottomLeading) {
//                                    Image(systemName: "person.circle.fill")
//                                        .resizable()
//                                        .frame(width: 60, height: 60)
//                                        .foregroundColor(.blue)
//                                        .overlay(
//                                            Circle()
//                                                .stroke(Color.mainBlue, lineWidth: 1)
//                                                .padding(-5)
//                                        )
//                                    
//                                    // Edit Button
//                                    Button(action: {
//                                        // Edit profile action
//                                        //                                    pushTo(destination: EditProfileView())
//                                    }) {
//                                        Image("editprofile")
//                                            .resizable()
//                                            .frame(width: 24, height: 24)
//                                            .offset(x: -5, y: 5)
//                                    }
//                                }
                                
                                KFImageLoader(url:URL(string:Constants.imagesURL + (viewModel.imageURL?.validateSlashs() ?? "")),placeholder: Image(.user), isOpenable: true,shouldRefetch: false)

    //                            Image(systemName: "person.circle.fill")
    //                            .resizable()
                                    .clipShape(Circle())
                                .scaledToFill()
                                .frame(width: 79, height: 79)
                                
                                Text(viewModel.Name)
                                    .font(.bold(size: 24))
                                    .foregroundColor(Color(.mainBlue))
                                
                                Spacer()
                                
                                VStack(alignment: .center, spacing: 4) {
                                    Image("walletIcon")
                                    Text("payments_wallet".localized)
                                        .font(.semiBold(size: 16))
                                        .foregroundColor(Color(.mainBlue))
                                    
                                    Text(paymentsVM.ballance?.total ?? 0, format: .number.precision(.fractionLength(2)) )
                                        .font(.bold(size: 26))
                                        .foregroundColor(Color(.secondary))
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .disabled(true)            // Disables any interaction
                        
                        
                        // Main Menu Section
                        Section {
                            VStack{
                                ProfileRow(title: "profile_Packages".localized, icon: "profile_packages"){
//                                    router.push(DocScheduleView())
                                    router.push( DocPackagesScreen())

                                }
                                ProfileRow(title: "profile_drugnotifications".localized, icon: "profile_notification"){
//                                    router.push( MedicationReminderView())
                                    router.push( DocScheduleView().environmentObject(viewModel))

//                                    let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: NotificationVC.self)!
//                                    pushUIKitVC(VC)
                                }
//                                ProfileRow(title: "profile_tips".localized, icon: "profile_tips"){
//                                    router.push( TipsView())
////                                    let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC1.self)!
////                                    pushUIKitVC(VC)
//                                }
//                                ProfileRow(title: "profile_inbody".localized, icon: "profile_inbody"){
//                                    router.push( InbodyView())
//
////                                    let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: INBodyVC.self)!
////                                    pushUIKitVC(VC)
//
//                                }
                                ProfileRow(title: "profile_files".localized, icon: "profile_files"){
                                    router.push( MyFilesView())
                                }
                                ProfileRow(title: "profile_Favourite".localized, icon: "profile_fav"){
                                    router.push( WishListView())
                                }
                                ProfileRow(title: "profile_allergies".localized, icon: "profile_alergy"){
                                    router.push( AllergiesView())
                                    
                                }
                                ProfileRow(title: "profile_Payments".localized, icon: "walletIcon",hasDivider:false){
                                    router.push( DocPaymentsView().environmentObject(paymentsVM) )
                                }
                            }
                            .padding()
                            .cardStyle(cornerRadius: 3,shadowOpacity: 0.1)
                        }
                        .listRowInsets(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                    }
                    
                    
                    // Settings Section
                    Section(header:
                                
                                HStack{
                        Image("profile_settings")
                        
                        Text("profile_settings".localized)
                            .font(.bold(size: 22))
                            .foregroundStyle(Color(.mainBlue))
                    }
                        .padding(.bottom)
                            
                    ) {
                        VStack{
                            
                            if isLogedin{
                                ProfileRow(title: "profile_editProfile".localized, icon: "profile_editProfile"){
                                    router.push( DocEditProfileView().environmentObject(viewModel))

                                }
                                ProfileRow(title: "profile_changepassword".localized, icon: "profile_changePass"){
                                    //                            let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: ChangePasswordVC.self)!
                                    //                                pushUIKitVC(VC)
                                    
                                    router.push( ChangePasswordView())
                                    
                                }
                            }
                            ProfileRow(title: "profile_languageandcountry".localized, icon: "profile_lang"){
                                router.push( SelectLanguageView(hasbackBtn:true))
                            }
                            
                            ProfileRow(title: "profile_privacyandsecurity".localized, icon: "profile_privacy"){
                                let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: TermsConditionsVC.self)!
                                pushUIKitVC(VC)
                            }
                            
                            ProfileRow(title: "profile_help".localized, icon: "profile_help"){
                                let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: HelpVC.self)!
                                pushUIKitVC(VC)
                            }
                            
                            ProfileRow(title: "profile_termsandconditions".localized, icon: "profile_terms",hasDivider: false){
                                let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: TermsConditionsVC.self)!
                                pushUIKitVC(VC)
                            }
                        }
                        .padding()
                        .cardStyle(cornerRadius: 3,shadowOpacity: 0.1)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                    
                    // Logout Section
                    Section {
                        Button(action: {
                            // Logout action
                            logoutAction()
                        }) {
                            HStack {
                                Spacer()
                                Text(isLogedin ? "profile_logout".localized:"profile_login".localized)
                                    .font(.bold(size: 24))
                                    .foregroundColor(.white)
                                
                                Image("logout")
                                Spacer()
                            }
                            
                        }
                        .frame(height: 50)
                        .background(Color(.secondary))
                        .padding(.vertical)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowSpacing(0)
            }
            .listStyle(.plain)
            
            Spacer().frame(height:80)
            
        }
        .localizeView()
        .withNavigation(router: router)
        //        .environment(\.layoutDirection,localizationManager.currentLanguage == "ar" ? .rightToLeft : .leftToRight)
        //        .localizeView()
        .background(Color(.bg))
        .task {
            await paymentsVM.getMyBallance()
        }
        
    }
}
struct DocProfileViewUI_Previews: PreviewProvider {
    static var previews: some View {
        DocProfileViewUI().environmentObject(EditProfileViewModel.shared)
    }
}

extension DocProfileViewUI{
    
    private func logoutAction() {
        if isLogedin {
            Helper.shared.logout()
            // Change root view to NewTabView
            let newHome = UIHostingController(rootView: DocTabView())
            Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
            
        } else {
            // Change root view to LoginView
            let newHome = UIHostingController(rootView: LoginView())
            Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
            
        }
    }
}
