//
//  DocTabView.swift
//  Sehaty
//
//  Created by mohamed hammam on 31/08/2025.
//
import SwiftUI

struct DocTabView: View{
    @StateObject private var viewModel = EditProfileViewModel.shared

    @State var selectedTab = 2
    
    var body: some View {
        CustomTabView(
            selectedIndex: $selectedTab,
            tabItems: [
                TabItem(image: "tab1", title: "Home", selectedImage: "tab1selected"),
                TabItem(image: "tab2", title: "Health", selectedImage: "tab2selected"),
                TabItem(image: "tab3", title: "Add", selectedImage: "tab3selected"),
                TabItem(image: "tab4", title: "Stats", selectedImage: "tab4selected"),
                TabItem(image: "tab5", title: "Profile", selectedImage: "tab5selected")
            ],
            cornerRadius: 30,
            backgroundColor: .white
        ) {
            // Your main content here
            Group {
                switch selectedTab {
                case 0:
                    //                    MARK: -- uikit --
//                    UIKitViewControllerWrapper(makeViewController: {
//                        let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: ProfileVC.self)!
//                        return VC
//                    })
//                    .ignoresSafeArea()
                    
                    ProfileViewUI()
                        .environmentObject(viewModel)

                case 1:
//                    SubcripedPackagesView(hasbackBtn: false)
//                        .environmentObject(viewModel)
                    
                    ActiveCustomerPackagesView()

                case 2:
                    NewHomeView()
                        .environmentObject(viewModel)

//                    UIKitViewControllerWrapper(makeViewController: {
//                    let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasurementsVC.self)!
//                    return VC
//                })
//                .ignoresSafeArea()
                    
                case 3:
                    
                    MyMeasurementsView()
                    
//                    UIKitViewControllerWrapper(makeViewController: {
////                    let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: NotificationVC.self)!
//                                    
//                        let VC: UIViewController = initiateViewController(storyboardName: .main, viewControllerIdentifier: MeasurementsVC.self)!
//
//                    return VC
//                }).ignoresSafeArea()

                case 4:
                    AppointmentsView()

                default: EmptyView()
                }
            }
//            .reversLocalizeView()
//            .localizeView()
        }
        .localizeView()
    }
}

#Preview{
    DocTabView()
}
