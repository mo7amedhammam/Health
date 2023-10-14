//
//  Helper.swift
//  Flash Card
//
//  Created by mac on 25/05/2021.
//

import UIKit
import SystemConfiguration
import MapKit
import Foundation
import Kingfisher


class Helper: NSObject {
    
    
//     "id": 0,
//     "phoneNumber": "string",
//     "token": "string",
//     "name": "string",
//     "mobile": "string",
//     "imagePath": "string",
//     "role": "string",
//     "roleId": 0
    
    
    
    class func SetAvailableUpdate (shouldUpdate : Int) {
        let def = UserDefaults.standard
        def.setValue(shouldUpdate  , forKey: "shouldUpdate")
        def.synchronize()

    }
    
    class func IS_Available_Update() ->Int {
        let def = UserDefaults.standard
        return (def.object(forKey: "shouldUpdate") as? Int ?? 0)
    }
    
    // ..............................
    
    
    class func getnameAr() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "nameAr") as! String)
    }
    class func getnameEn() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "nameEn") as! String)
    }
    
    
    class func getid()->Int {
        let def = UserDefaults.standard
        return (def.object(forKey: "id") as! Int)
    }
    class func getphoneNumber() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "phoneNumber") as! String)
    }
    
    class func gettoken() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "token") as! String)
    }
    class func getname() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "name") as! String)
    }
    class func getmobile() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "mobile") as! String)
    }
    class func getimagePath() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "imagePath") as! String)
    }
  
    class func getrole() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "role") as! String)
    }
    class func getroleId() ->Int {
        let def = UserDefaults.standard
        return (def.object(forKey: "roleId") as! Int)
    }
    
    
    class func getemail() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "email") as! String)
    }
 
    // check in scene delegate
    class func IsUserData()->Bool {
        let def = UserDefaults.standard
        return (def.object(forKey: "id") as? Int) != nil
    }
    
    
    class func Isemail() ->Bool {
        let def = UserDefaults.standard
        return (def.object(forKey: "email") as? String) != nil
    }
    
    
    
    //save password
    class func setPassword(password : String){
        let def = UserDefaults.standard
        def.setValue(password, forKey: "password")
        def.synchronize()
    }
    
    class func getPassword()->String{
        let def = UserDefaults.standard
        return (def.object(forKey: "password") as! String)
    }
    
   
    
    
    //save image
//    class func setProfileImage(image : String){
//        let def = UserDefaults.standard
//        def.setValue(image, forKey: "profileImage")
//        def.synchronize()
//    }
//
//
//    class func getProfileImage() ->String {
//        let def = UserDefaults.standard
//        return (def.object(forKey: "profileImage") as! String)
//    }
//
    
    //     "id": 0,
    //     "phoneNumber": "string",
    //     "token": "string",
    //     "name": "string",
    //     "mobile": "string",
    //     "imagePath": "string",
    //     "role": "string",
    //     "roleId": 0
    

    
    class func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    class func isValidPassword(passwordStr:String) -> Bool {
        let passwordRegEx = "(?=.{8,})"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: passwordStr)
    }
    
    class func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    
    
    class func openWhatsapp(Num : String){
        let urlWhats = "whatsapp://send?phone=(\(Num))"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    
    class func openTelegram (TelegramLink : String) {
        
        let botURL = URL.init(string: TelegramLink)
            if UIApplication.shared.canOpenURL(botURL!) {
                UIApplication.shared.openURL(botURL!)
            } else {
                let urlAppStore = URL(string: "itms-apps://itunes.apple.com/app/id686449807")
                if(UIApplication.shared.canOpenURL(urlAppStore!))
                {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(urlAppStore!, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(urlAppStore!)
                    }
                }
            }
    }
    
    
    
    class func openFaceBook(pageId: String, pageName: String) {
        let appURL = NSURL(string: "fb://page/?id=\(pageId)")!
        let webURL = NSURL(string: "http://facebook.com/\(pageName)/")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
       }

    
    
    class func SetImage (EndPoint : String? , image : UIImageView , name : String , status : Int) {
        // status == 0 system  else 1 named
        if !EndPoint!.isEmpty || EndPoint != nil {
            let url = URL(string: "" + "\(EndPoint ?? "")")
            image.kf.indicatorType = .activity
            image.kf.setImage(with: url, placeholder: UIImage(named: "no_image"), options: nil, progressBlock: nil, completionHandler: nil)
//            print("HelperImage: \(url)")
        } else {
            if status == 0 {
                image.image = UIImage(systemName: name)
            } else {
                image.image = UIImage(named: name)
            }
        }
    }
    
    
    
    class func GoToAnyScreen (storyboard : String , identifier : String) {
        guard let window = UIApplication.shared.keyWindow else{return}
        let storyboard = UIStoryboard(name: storyboard , bundle: nil)
        var vc:UIViewController
        vc = storyboard.instantiateViewController(withIdentifier: identifier )
        window.rootViewController = vc
    }
    
    class func PushToAnyScreen (TargetStoryboard : String , targetViewController : String) {
        let storyboard = UIStoryboard(name: TargetStoryboard , bundle: nil)
        var vc:UIViewController
        vc = storyboard.instantiateViewController(withIdentifier: targetViewController )
        let nav = UINavigationController()
        nav.pushViewController(vc, animated: true)
    }
    class func PopAnyScreen () {
      
        let nav = UINavigationController()
        nav.popViewController(animated: true)
    }
    class func PopAnyRootScreen () {
      
        let nav = UINavigationController()
        nav.popToRootViewController(animated: true)
    }
    
   
    
    
    class func retreiveCityName(lattitude: Double, longitude: Double, completionHandler: @escaping (String?) -> Void) {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: lattitude, longitude: longitude), completionHandler:
            {
                placeMarks, error in
                let country = placeMarks?.first?.country
                let admin = placeMarks?.first?.administrativeArea
                let subLocality = placeMarks?.first?.subLocality
                let name = placeMarks?.first?.name

                let address = "\(country ?? ""),\(admin ?? ""),\(subLocality ?? ""),\(name ?? "")"


                completionHandler(address)
             })
        }
    
    
    
    
    enum pushTo {
        case tabBar
        case VC
    }
    class func PushTo(type:pushTo,id: AnyClass ){
        let storyboard = UIStoryboard(name: "Main" , bundle: nil)
        let nav = UINavigationController()

        switch type {
        case .tabBar:
            let  vc = (storyboard.instantiateViewController(withIdentifier: "\(id)")) as! UITabBarController
            vc.selectedIndex = 0
            print("push")
            nav.pushViewController(vc , animated: true)

        case .VC:
            let vc = (storyboard.instantiateViewController(withIdentifier: "\(id)")) as UIViewController
            nav.pushViewController(vc , animated: true)

        }

    }
      
}


extension String {
func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.text = self
    label.font = font
    label.sizeToFit()

    return label.frame.height
 }
}


enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}



extension Helper{

    @available(iOS 13.0, *)
        static let userDef = UserDefaults.standard
        
        private static let onBoardKey = "onBoard"
        private static let LoggedInKey = "LoggedId"
        private static let UserDataKey = "UserDataKey"

        
        class func saveUser(user: LoginM) {
            IsLoggedIn(value: true)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                userDef.set(encoded, forKey: UserDataKey)
                IsLoggedIn(value: true)
                userDef.synchronize()
            }
        }

        class func getUser() -> LoginM? {
            if let data = userDef.object(forKey: UserDataKey) as? Data {
                let decoder = JSONDecoder()
                if let user = try? decoder.decode(LoginM.self, from: data) {
                    return user
                }
            }
            return nil
        }
        
        //remove data then logout
        class func logout() {
            IsLoggedIn(value: false)
            userDef.removeObject(forKey:UserDataKey  )
        }
            
        static func onBoardOpened(opened:Bool) {
            UserDefaults.standard.set(opened, forKey: onBoardKey)
        }

        static func checkOnBoard() -> Bool {
            return UserDefaults.standard.bool(forKey: onBoardKey)
        }
        static func IsLoggedIn(value:Bool) {
            UserDefaults.standard.set(value, forKey: LoggedInKey)
        }
        static func CheckIfLoggedIn() -> Bool {
            return UserDefaults.standard.bool(forKey: LoggedInKey)
        }

        
        // Checking internet connection
        class func isConnectedToNetwork() -> Bool {
            
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
            }

       class func ChangeFormate( NewFormat:String) -> DateFormatter {
        //    @AppStorage("language")
        //    var language = LocalizationService.shared.language
            let df = DateFormatter()
            df.dateFormat = NewFormat
           df.locale = Locale(identifier: "en_US_POSIX")
//            df.locale = Locale(identifier: language.rawValue == "ar" ? "ar":"en_US_POSIX")
            return df
        }

        class func calculatePercentage(number: Int, total: Int) -> Double {
            guard total > 0 else {
                return 0.0  // Avoid division by zero
            }
            
            let percentage = Double(number) / Double(total) * 100.0
            return percentage
        }
        
        @available(iOS 13.0, *)
    static func changeRootVC(newroot viewcontroller:UIViewController.Type,transitionFrom from : CATransitionSubtype){
            guard  let controller = initiateViewController(storyboardName: .main,viewControllerIdentifier: viewcontroller.self) else {return}
            let nav = UINavigationController(rootViewController: controller)
            nav.navigationBar.isHidden = true
            UIApplication.shared.keyWindow?.replaceRootViewController(nav, from)
        }
        

        
        
    }




