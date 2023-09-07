//
//  Navigations.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//

import UIKit

enum storyboards : String {
case main = "Main"
//    case Question = "Question"
}

func initiateXibViewController<T: UIViewController>(viewControllerIdentifier:UIViewController.Type, as type: T.Type) -> T? {

        guard let vc = viewControllerIdentifier.init(nibName: String(describing: viewControllerIdentifier.self), bundle: nil) as? T else {
            return nil
        }
        return vc
    
}

func initiateViewController<T: UIViewController>(storyboardName: storyboards, viewControllerIdentifier: T.Type) -> T? {
    let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: viewControllerIdentifier.self)) as? T else {
        return nil
    }
    return viewController
}

func loadViewFromNib(nibName: String, owner: Any?) -> UIView? {
    let nib = UINib(nibName: nibName, bundle: nil)
    return nib.instantiate(withOwner: owner, options: nil).first as? UIView
}
