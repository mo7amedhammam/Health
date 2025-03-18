//
//  StartScreenVC.swift
//  Sehaty
//
//  Created by Hamza on 04/12/2023.
//

import UIKit

class StartScreenVC: UIViewController {
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 , execute: {
            
            if !Helper.shared.checkOnBoard() {
                Helper.shared.changeRootVC(newroot: SplashScreenVC.self,transitionFrom: .fromLeft)
            } else {
                if Helper.shared.CheckIfLoggedIn() {
                    Helper.shared.changeRootVC(newroot: HTBC.self,transitionFrom: .fromLeft)
                } else {
                    Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
                }
            }
        })
    }
    
}
