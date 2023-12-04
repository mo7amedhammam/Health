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
            
            if !Helper.checkOnBoard() {
                Helper.changeRootVC(newroot: SplashScreenVC.self,transitionFrom: .fromLeft)
            } else {
                if Helper.CheckIfLoggedIn() {
                    Helper.changeRootVC(newroot: HTBC.self,transitionFrom: .fromLeft)
                } else {
                    Helper.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
                }
            }
        })
    }
    
}
