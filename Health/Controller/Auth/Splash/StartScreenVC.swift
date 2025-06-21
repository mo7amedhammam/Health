//
//  StartScreenVC.swift
//  Sehaty
//
//  Created by Hamza on 04/12/2023.
//

import UIKit
import SwiftUI

class StartScreenVC: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async( execute: {

            if !Helper.shared.checkOnBoard() {
                let rootVC = UIHostingController(rootView: OnboardingView())

                Helper.shared.changeRootVC(newroot: rootVC,transitionFrom: .fromLeft)
            } else {
                if Helper.shared.CheckIfLoggedIn() {
                    Helper.shared.changeRootVC(newroot: HTBC.self,transitionFrom: .fromLeft)
                } else {
//                    Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
                    let newHome = UIHostingController(rootView: LoginView())
                    Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)

                }
            }
        })
    }
    
}
