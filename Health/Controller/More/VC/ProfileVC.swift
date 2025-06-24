//import UIKit
//import Alamofire
//import SwiftyJSON

//class ProfileVC: UIViewController {
//    
//    @IBOutlet weak var TVscreen: UITableView!
//    
//    let viewModel = ProfileVM()
//    var selectedIndex: Int?
//    
//    private enum Section {
//        case profileHeader
//        case mainOptions
//        case separator
//        case settings
//        case logout
//    }
//    
//     struct MenuItem {
//        let title: String
//        let imageName: String
//        let action: (() -> Void)?
//    }
//    
//    private var sections: [Section] = [.profileHeader, .mainOptions, .separator, .settings, .logout]
//    private var mainOptions: [MenuItem] = []
//    private var settingsOptions: [MenuItem] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        configureMenuItems()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        selectedIndex = nil
//        TVscreen.reloadData()
//        getMyProfile()
//    }
//    
//    private func setupTableView() {
//        TVscreen.dataSource = self
//        TVscreen.delegate = self
//        TVscreen.registerCellNib(cellClass: ProfileTVCellLine.self)
//        TVscreen.registerCellNib(cellClass: ProfileTVCellHeader.self)
//        TVscreen.registerCellNib(cellClass: ProfileTVCellMiddle.self)
//        TVscreen.registerCellNib(cellClass: ProfileTVCellLogout.self)
//        // In your viewDidLoad()
//        TVscreen.backgroundColor = UIColor(.white).withAlphaComponent(0.5)
//    }
//    
//    private func configureMenuItems() {
//          mainOptions = [
//            MenuItem(title: "اشتراكاتي".localized, imageName: "more_subscriptions") { [weak self] in
////                  self?.selectedIndex = 0
//                let destination = SubcripedPackagesView(onBack:{
//                    self?.navigationController?.popViewController(animated: true)
//                })
////                let destination = ChatsView(CustomerPackageId: 0)
//                self?.pushTo(destination)
//            },
//            MenuItem(title: "نصائح طبية".localized, imageName: "instruction") { [weak self] in
////                  self?.selectedIndex = 0
//                  self?.pushTo(TipsCategoriesVC1.self)
//              },
//            MenuItem(title: "Inbody".localized, imageName: "newInbody") { [weak self] in
////                  self?.selectedIndex = 1
//                  self?.pushTo(INBodyVC.self)
//              }
//          ]
//          
//          settingsOptions = [
//            MenuItem(title: "تغيير كلمة المرور".localized, imageName: "changepass") { [weak self] in
////                  self?.selectedIndex = 2
//                  self?.pushTo(ChangePasswordVC.self)
//              },
//            MenuItem(title: "تغيير اللغة".localized, imageName: "changelang") { [weak self] in
////                  self?.selectedIndex = 3
//                  self?.handleLanguageChange()
//              },
//            MenuItem(title: "الحماية والخصوصية".localized, imageName: "privacyprotection") { [weak self] in
////                  self?.selectedIndex = 4
//                  // Handle privacy action
//                  self?.pushTo(TermsConditionsVC.self)
//              },
//            MenuItem(title: "المساعدة".localized, imageName: "play") { [weak self] in
////                  self?.selectedIndex = 5
//                  self?.pushTo(HelpVC.self)
//              },
//            MenuItem(title: "الشروط والأحكام".localized, imageName: "termscondition") { [weak self] in
////                  self?.selectedIndex = 6
//                  self?.pushTo(TermsConditionsVC.self)
//              }
//          ]
//      }
//    
////    private func handleLanguageChange() {
////        LocalizationManager.shared.setLanguage(Helper.shared.getLanguage() == "ar" ? "en" : "ar") { _ in
////            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
////                sceneDelegate.reloadRootView()
////            }
////        }
////    }
//    private func handleLanguageChange() {
//        let newLanguage = Helper.shared.getLanguage() == "ar" ? "en" : "ar"
//        
//        // Show loading indicator if needed
//        Hud.showHud(in: self.view, text: "Changing language...")
//
//        LocalizationManager.shared.setLanguage(newLanguage) { [weak self] success in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                Hud.dismiss(from: self.view)
//                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//                    sceneDelegate.reloadRootView()
//                }
//                
////                if success{
//////                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//////                        sceneDelegate.reloadRootView()
//////                    }
////                    
////                }else{
////                    self.showLanguageChangeError()
////                }
//            }
//        }
//    }
//
//    private func showLanguageChangeError() {
//        let alert = UIAlertController(
//            title: "Language Change Failed",
//            message: "Language Change Failed",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "OK".localized, style: .default))
//        present(alert, animated: true)
//    }
//    
//    private func showLogoutConfirmation() {
//        if Helper.shared.CheckIfLoggedIn(){
//            
//            let actionSheet = UIAlertController(
//                title: "هل أنت متأكد بأنك تريد تسجيل الخروج؟".localized,
//                message: "",
//                preferredStyle: .alert
//            )
//            
//            let logoutAction = UIAlertAction(title: Helper.shared.CheckIfLoggedIn() ? "تسجيل الخروج".localized : "تسجيل الدخول".localized, style: .default) { _ in
//                Helper.shared.logout()
//                //            Helper.shared.changeRootVC(newroot: StartScreenVC.self, transitionFrom: .fromLeft)
//                let newhome = UIHostingController(rootView: AnyView(NewTabView()))
//                Helper.shared.changeRootVC(newroot:newhome , transitionFrom: .fromLeft)
//                
//                
//        }
//        
//        let cancelAction = UIAlertAction(title: "إلغاء".localized, style: .destructive)
//        
//        actionSheet.addAction(logoutAction)
//        actionSheet.addAction(cancelAction)
//        
//        // iPad support
//        if let popoverController = actionSheet.popoverPresentationController {
//            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2,
//                                                 y: UIScreen.main.bounds.height / 2,
//                                                 width: 0, height: 0)
//            popoverController.sourceView = view
//            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
//        }
//        
//        present(actionSheet, animated: true)
//            
//        }else{
//            //            Helper.shared.changeRootVC(newroot: StartScreenVC.self, transitionFrom: .fromLeft)
//            let newhome = UIHostingController(rootView: AnyView(LoginView()))
//            Helper.shared.changeRootVC(newroot:newhome , transitionFrom: .fromLeft)
//        }
//
//    }
//    
//    private func pushTo(_ destination: UIViewController.Type) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: destination) else { return }
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//    
//    private func getMyProfile() {
//        viewModel.GetMyProfile{ [weak self] state in
//            guard let self = self, let state = state else { return }
//            
//            switch state {
//            case .loading:
//                print("loading")
//            case .stopLoading:
//                Hud.dismiss(from: self.view)
//            case .success:
//                Hud.dismiss(from: self.view)
//                self.TVscreen.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//            case .error(_, let error):
//                Hud.dismiss(from: self.view)
//                print(error ?? "")
//            case .none:
//                break
//            }
//        }
//    }
//}
//extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch sections[section] {
//        case .profileHeader: return 1
//        case .mainOptions: return mainOptions.count
//        case .separator: return 1
//        case .settings: return settingsOptions.count
//        case .logout: return 1
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch sections[indexPath.section] {
//        case .profileHeader:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellHeader", for: indexPath) as! ProfileTVCellHeader
//            if let user = viewModel.responseModel {
//                cell.LaName.text = user.name
//                cell.LaPhone.text = user.mobile
//            }
//            return cell
//            
//        case .mainOptions:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
//            let item = mainOptions[indexPath.row]
//            cell.configure(with: item, isSelected: selectedIndex == indexPath.row)
//            return cell
//            
//        case .separator:
//            return tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellLine", for: indexPath) as! ProfileTVCellLine
//            
//        case .settings:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellMiddle", for: indexPath) as! ProfileTVCellMiddle
//            let item = settingsOptions[indexPath.row]
//            // Offset by mainOptions count + 1 (for separator) when checking selection
//            cell.configure(with: item, isSelected: false)
//            return cell
//            
//        case .logout:
//            return tableView.dequeueReusableCell(withIdentifier: "ProfileTVCellLogout", for: indexPath) as! ProfileTVCellLogout
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        switch sections[indexPath.section] {
//        case .profileHeader, .separator:
//            break
//            
//        case .mainOptions:
////            selectedIndex = indexPath.row
//            mainOptions[indexPath.row].action?()
//            
//        case .settings:
//            // Offset by mainOptions count + 1 (for separator)
////            selectedIndex = indexPath.row + 1 + mainOptions.count
//            settingsOptions[indexPath.row].action?()
//            
//        case .logout:
//            showLogoutConfirmation()
//        }
//        
//        tableView.reloadData()
//    }
//    
////    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        switch sections[indexPath.section] {
////        case .profileHeader: return 180
////        case .separator: return 1 // or whatever height your separator should be
////        default: return UITableView.automaticDimension
////        }
////    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//          switch sections[section] {
//          case .profileHeader:
//              return 0.1 // Minimal height for first section
//          case .mainOptions , .settings:
//              return 8 // Custom spacing between sections
//          case .separator:
//              return 10
//          case .logout:
//              return 0.1 // Extra space before logout button
//          }
//      }
//      
//      func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//          return 0.1 // Minimal footer height for all sections
//      }
//      
//      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//          let header = UIView()
//          header.backgroundColor = .clear
//          return header
//      }
//      
//      func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//          let footer = UIView()
//          footer.backgroundColor = .clear
//          return footer
//      }
//    
////    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////           // Apply card styling to main options and settings sections
////           switch sections[indexPath.section] {
////           case .mainOptions, .settings:
////               let isFirst = indexPath.row == 0
////               let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
////               cell.applyCardStyle(isFirst: isFirst, isLast: isLast)
////           default:
////               break
////           }
////       }
// 
//    
//}

//extension UITableViewCell {
//    func applyCardStyle(isFirst: Bool, isLast: Bool) {
//        // Clear background
//        backgroundColor = .clear
//        contentView.backgroundColor = .white
//        
//        // Corner radius
//        var maskedCorners: CACornerMask = []
//        if isFirst {
//                  maskedCorners.insert(.layerMinXMinYCorner) // topLeft
//                  maskedCorners.insert(.layerMaxXMinYCorner) // topRight
//              }
//              if isLast {
//                  maskedCorners.insert(.layerMinXMaxYCorner) // bottomLeft
//                  maskedCorners.insert(.layerMaxXMaxYCorner) // bottomRight
//              }
//
//        contentView.layer.cornerRadius = 12
//        contentView.layer.maskedCorners = maskedCorners
//        contentView.layer.masksToBounds = true
//        
//        // Shadow
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowRadius = 4
//        layer.shadowOpacity = 0.1
//        layer.masksToBounds = false
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
//    }
//}


extension UIView {
    func makeCardStyle() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
}
extension UIView {
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

extension UIViewController {
    /// Pushes a SwiftUI view onto the navigation stack
    func pushTo<Content: View>(_ swiftUIView: Content, hidesBottomBar: Bool = true) {
        let hostingController = UIHostingController(rootView:
            swiftUIView
                .navigationBarHidden(true) // Hide the native nav bar from SwiftUI
        )
        hostingController.hidesBottomBarWhenPushed = hidesBottomBar

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigationController?.pushViewController(hostingController, animated: true)
        }
    }
}

import SwiftUI

struct ProfileViewUI: View {
    @State private var showLogoutAlert = false
    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    var body: some View {
        VStack {
            TitleBar(title: "profile_title")

            List {
                
                Group{
                    // Profile Header Section
                    Section {
                        HStack(spacing: 16) {
                            
                            // Profile Image with Border and Edit Button
                            ZStack(alignment: .bottomLeading) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.blue)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.mainBlue, lineWidth: 1)
                                            .padding(-5)
                                    )
                                
                                // Edit Button
                                Button(action: {
                                    // Edit profile action
//                                    pushTo(destination: EditProfileView())
                                }) {
                                    Image("editprofile")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .offset(x: -5, y: 5)
                                }
                            }
                            
                            Text("ندى يونس")
                                .font(.bold(size: 24))
                                .foregroundColor(Color(.mainBlue))
                            
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 4) {
                                Image("walletIcon")
                                Text("محفظتك")
                                    .font(.semiBold(size: 16))
                                    .foregroundColor(Color(.mainBlue))
                                
                                Text("12,400")
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
                            ProfileRow(title: "الباقات", icon: "profile_packages"){
                                pushTo(destination: SubcripedPackagesView(hasbackBtn: true) )
                            }
                            ProfileRow(title: "تنبيهات الأدوية", icon: "profile_notification"){
                            let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: NotificationVC.self)!
                                pushUIKitVC(VC)
                            }
                            ProfileRow(title: "نصائح طبية", icon: "profile_tips"){
                                let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: TipsCategoriesVC1.self)!
                                    pushUIKitVC(VC)
                            }
                            ProfileRow(title: "Inbody", icon: "profile_inbody"){
                                let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: INBodyVC.self)!
                                    pushUIKitVC(VC)
                            }
                            ProfileRow(title: "ملفاتي", icon: "profile_files"){
                                pushTo(destination: MyFilesView())
                            }
                            ProfileRow(title: "المفضلة", icon: "profile_fav"){
                                pushTo(destination: WishListView())
                            }
                            ProfileRow(title: "الحساسية", icon: "profile_alergy"){
                                
                            }
                            ProfileRow(title: "حساباني", icon: "walletIcon",hasDivider:false){
                                
                            }
                        }
                        .padding()
                        .cardStyle(cornerRadius: 3,shadowOpacity: 0.1)                    }
                    .listRowInsets(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                    
                    // Settings Section
                    Section(header:
                                
                                HStack{
                        Image("profile_settings")

                        Text("الإعدادات")
                            .font(.bold(size: 22))
                            .foregroundStyle(Color(.mainBlue))
                    }
                        .padding(.bottom)

                    ) {
                        VStack{
                        ProfileRow(title: "تعديل العلف الشخصي", icon: "profile_editProfile"){
                            
                        }
                        ProfileRow(title: "تغيير كلمة المرور", icon: "profile_changePass"){
                            let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: ChangePasswordVC.self)!
                                pushUIKitVC(VC)
                        }
                        ProfileRow(title: "اللغة والدولة", icon: "profile_lang"){
                            pushTo(destination: SelectLanguageView(hasbackBtn:true))
                        }
                        ProfileRow(title: "الحماية والخصوصية", icon: "profile_privacy"){
                            let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: TermsConditionsVC.self)!
                                pushUIKitVC(VC)
                        }
                        ProfileRow(title: "المساعدة", icon: "profile_help"){
                            let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: HelpVC.self)!
                                pushUIKitVC(VC)
                        }
                        ProfileRow(title: "الشروط والأحكام", icon: "profile_terms",hasDivider: false){
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
                                Text(Helper.shared.CheckIfLoggedIn() ? "profile_logout".localized:"profile_login".localized)
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
            .listStyle(PlainListStyle())

            Spacer().frame(height:80)

        }
        .background(Color(.bg))
        
        // Add this modifier to your main view
             .alert(isPresented: $showLogoutAlert) {
                 Alert(
                     title: Text("هل أنت متأكد بأنك تريد تسجيل الخروج؟"),
                     message: Text(""),
                     primaryButton: .destructive(Text("تسجيل الخروج")) {
                         logoutAction()
                     },
                     secondaryButton: .cancel(Text("إلغاء"))
             )}
        
        NavigationLink( "", destination: destination, isActive: $isactive)

    }
}

struct ProfileRow: View {
    let title: String
    let icon: String
    var hasDivider: Bool? = true
    var trailingView: AnyView? = nil
    let action: (() -> Void)?

    var body: some View {
        VStack(spacing:20) {
            Button(action: {
                action?()
            }) {
                
                HStack {
                    ZStack {
                        Color(.secondary).cornerRadius(3)
                        
                        Image(icon)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14)
//                            .padding(5)
                            .foregroundColor(Color(.white))
                    }
                    .frame(width: 30,height: 30)
                        
                    Text(title)
                        .font(.bold(size: 16))
                        .foregroundColor(Color(.mainBlue))
                    
                    Spacer()
                    
                    if let trailingView = trailingView {
                        trailingView
                    }else{
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray.opacity(0.6))
                    }
                }
                .contentShape(Rectangle()) // Makes entire row tappable
            }
            .buttonStyle(PlainButtonStyle())
            if hasDivider == true{
                Divider()
                    .padding(.leading)
            }
            
//            Color(.separator)
//                .opacity(0.3)
//                .frame(height: 1)

        }
//        .frame(height: 48)
    }
}

struct ProfileViewUI_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewUI()
    }
}



extension ProfileViewUI{
    
    private func logoutAction() {
           if Helper.shared.CheckIfLoggedIn() {
               Helper.shared.logout()
               // Change root view to NewTabView
               if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first {
                   window.rootViewController = UIHostingController(rootView: NewTabView())
                   window.makeKeyAndVisible()
                   withAnimation {
                       window.rootViewController?.view.transform = CGAffineTransform(translationX: -window.bounds.width, y: 0)
                       UIView.animate(withDuration: 0.3) {
                           window.rootViewController?.view.transform = .identity
                       }
                   }
               }
           } else {
               // Change root view to LoginView
               if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first {
                   window.rootViewController = UIHostingController(rootView: LoginView())
                   window.makeKeyAndVisible()
                   withAnimation {
                       window.rootViewController?.view.transform = CGAffineTransform(translationX: -window.bounds.width, y: 0)
                       UIView.animate(withDuration: 0.3) {
                           window.rootViewController?.view.transform = .identity
                       }
                   }
               }
           }
       }
}
