//
//  Alert.swift
//  Health
//
//  Created by wecancity on 05/09/2023.
//

import UIKit

//@available(iOS 13.0, *)
class SimpleAlert : NSObject {
  static let shared = SimpleAlert()

    func showAlert(title: String, message: String, viewController: UIViewController, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
//              alertController.view.tintColor = UIColor.red // Set the tint color of the alert
//
//              let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
//              let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
//              alertController.setValue(titleAttrString, forKey: "attributedTitle") // Set the font of the title
//
//              let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
//              let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
//              alertController.setValue(messageAttrString, forKey: "attributedMessage") // Set the font of the message
//
              let okAction = UIAlertAction(title: "موافق", style: .default){ _ in
                  completion?()
                  if title == NetworkError.expiredTokenMsg.errorDescription ||  message == NetworkError.expiredTokenMsg.errorDescription {
                      Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
                  }
              }
              okAction.setValue(UIColor.blue, forKey: "titleTextColor") // Set the text color of the action
//        if withCancel ?? false{
//            let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel)
//            alertController.addAction(cancelAction)
//        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
       }
    
    
    
    
    
//    static var alertView = AlertView()

//    var cancellables = Set<AnyCancellable>()

//   class func showAlert(title: String, message: String , in view : UIView) {
//        alertView.configure(title: title, message: message)
//       alertView.show()
//       view.addSubview(alertView)
////        Publishers.showAlert(alertView)
////            .sink { shouldDismiss in
////                if shouldDismiss {
////                    self.alertView.hide()
////                }
////            }
////            .store(in: &cancellables)
//    }
    
//    func hide(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
    
    
}



class NewSimpleAlert {
    static let shared = NewSimpleAlert()

    /// Shows an alert with a title, message, and an optional completion handler.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    ///   - viewController: The view controller to present the alert.
    ///   - completion: An optional closure to execute when the "OK" button is tapped.
    func showAlert( in viewController: UIViewController, title: String, message: String,btnTitle:String? = "" ,completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Configure the "OK" action
        let okAction = UIAlertAction(title:AppKeys.OkAlert.localized, style: .default) { _ in
            completion?()
            if title == NetworkError.expiredTokenMsg.errorDescription || message == NetworkError.expiredTokenMsg.errorDescription {
                Helper.shared.changeRootVC(newroot: LoginVC.self, transitionFrom: .fromLeft)
            }
        }
        okAction.setValue(UIColor.systemBlue, forKey: "titleTextColor") // Adapts to dark/light mode

        // Add the action to the alert
        alertController.addAction(okAction)

        // Present the alert
        viewController.present(alertController, animated: true, completion: nil)
    }
}
