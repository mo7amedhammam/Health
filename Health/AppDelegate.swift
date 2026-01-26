//
//  AppDelegate.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

//import UIKit
//import IQKeyboardManagerSwift
//import Firebase
//import FirebaseMessaging
////import DropDown
//import AVFoundation
//import UserNotifications

//@main
//class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
//    
//    var window : UIWindow?
//    let gcmMessageIDKey = "gcm.Message_ID"
//    var locationService: LocationService?
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
////        Helper.shared.onBoardOpened(opened: false)
//        detectCountry()
//        LocalizationInit()
//        IQKeyboardManager.shared.isEnabled = true
//        IQKeyboardManager.shared.resignOnTouchOutside = true
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        UNUserNotificationCenter.current().delegate = self
//        
//        if #available(iOS 10.0, *) {
////            Messaging.messaging().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            application.registerForRemoteNotifications()
//        } else {
//            let settings: UIUserNotificationSettings =
//            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
////        application.registerForRemoteNotifications()
//        
//        return true
//    }
//    
//    // MARK: UISceneSession Lifecycle
//    
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//    
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        print("userInfo1 : \(userInfo)")
//        
//    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        print("userInfo2 : \(userInfo)")
//        // if app in background make sound
//        var systemSoundID : SystemSoundID = 1007 // doesnt matter; edit path instead
//        let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/sms-received1.caf")
//        AudioServicesCreateSystemSoundID(url as CFURL, &systemSoundID)
//        AudioServicesPlaySystemSound(systemSoundID)
//
//        completionHandler(.newData)
//    }
//    
//    
//    
////    func showCustomNotification(title: String, body: String) {
////        let content = UNMutableNotificationContent()
////        content.title = title
////        content.body = body
////        content.sound = UNNotificationSound.default
////
////        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: nil)
////
////        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
////            if let error = error {
////                print("Error displaying notification: \(error.localizedDescription)")
////            }
////        })
////    }
//    
//}


//extension AppDelegate {
//    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(fcmToken ?? "")")
//        // Retrieve the previous token from UserDefaults or wherever you store it
//        let previousToken = Helper.shared.getFirebaseToken()
//        
//        if let newToken = fcmToken, newToken != previousToken {
//            // Token has changed, do something with the new token
//            print("New Firebase token: \(newToken)")
//            // Update the stored token
//            Shared.shared.NewFirebaseToken = true
//            Helper.shared.setFirebaseToken(token: newToken)
//            // Notify observers about the new token
//            let dataDict: [String: String] = ["token": newToken]
//            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//        } else {
//            // Token is either nil or hasn't changed
//            print("Token is either nil or hasn't changed")
//        }
//    }
//    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//        print("deviceToken : \(deviceToken)")
//    }
//    
//    
//}


//    extension AppDelegate : UNUserNotificationCenterDelegate {
//    
//    //    forground
//        func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                    willPresent notification: UNNotification,
//                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    
//            let userInfo = notification.request.content.userInfo
//            print("userInfo userInfo : \(userInfo)")
//            // play sound
//            // play sound
//            var systemSoundID : SystemSoundID = 1007 // doesnt matter; edit path instead
//            let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/sms-received1.caf")
//            AudioServicesCreateSystemSoundID(url as CFURL, &systemSoundID)
//            AudioServicesPlaySystemSound(systemSoundID)
//    
//            completionHandler([.banner, .list, .badge , .sound])
//        }
//    
//    //    background
//        func userNotificationCenter(
//            _ center: UNUserNotificationCenter,
//            didReceive response: UNNotificationResponse
//        ) async {
//    
//            let userInfo = response.notification.request.content.userInfo
//    
//            guard
//                let type = userInfo["type"] as? String,
//                type == "chat",
//                let packageId = userInfo["customerPackageId"] as? String
//            else { return }
//    
//            // 🔗 Deep link to chat
//            NotificationCenter.default.post(
//                name: .openChatFromNotification,
//                object: nil,
//                userInfo: ["packageId": packageId]
//            )
//        }
//    
//    }
//
//// MARK: --- Localization ---
//extension AppDelegate {
//    func LocalizationInit() {
////        UIFont.familyNames.forEach({ familyName in
////            let fontNames = UIFont.fontNames(forFamilyName: familyName)
////            print("familyName, fontNames",familyName, fontNames)
////        })
//        
////        changeLanguage(to: Helper.shared.getLanguage())
//        LocalizationManager.shared.changeLanguage(to: Helper.shared.getLanguage()) {
//            
//        }
//        
//        
////        LocalizationManager.shared.setLanguage(Helper.shared.getLanguage()) { _ in
////            // Ensure this code is executed on the main thread
//////            DispatchQueue.main.async {
//////                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//////                    sceneDelegate.reloadRootView()
//////                }
//////            }
////        }
//        print("Helper Language is:", Helper.shared.getLanguage())
//        print("LocalizationManager Language is:", LocalizationManager.shared.currentLanguage)
//
//        // Uncomment the following if you need to fetch translations
//        // LocalizationManager.shared.fetchTranslations() { success in
//        //    if success {
//        //        print("✅ Localization updated successfully")
//        //    } else {
//        //        print("❌ Failed to update localization")
//        //    }
//        // }
//    }
//    
//    
//    func detectCountry() {
//        locationService = LocationService() // keep a strong reference
//
//        locationService?.onCountryDetected = { countryCode in
//            if let code = countryCode {
//                print("Detected Country: \(code)")
//
//                // Example: Set global flags or variables
//                if code == "EG" {
//                    print("🇪🇬 User is in Egypt")
//                } else if code == "SA" {
//                    print("🇸🇦 User is in Saudi Arabia")
//                }
//            } else {
//                print("❌ Failed to detect country")
//            }
//        }
//    }
//    
//}
//
////DeepLinking
//extension Notification.Name {
//    static let openChatFromNotification = Notification.Name("openChatFromNotification")
//}


//===========================================


    import UIKit
    import FirebaseCore
    import FirebaseMessaging
    import UserNotifications
    import IQKeyboardManagerSwift
    import AudioToolbox

    @main
    final class AppDelegate: UIResponder, UIApplicationDelegate {
            let gcmMessageIDKey = "gcm.Message_ID"
            var locationService: LocationService?

        // MARK: - App Launch
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {

            configureAppEnvironment()
            configureKeyboard()
            configureFirebase()
            configureNotifications(application)

            return true
        }

        // MARK: - Scene Configuration
        func application(
            _ application: UIApplication,
            configurationForConnecting connectingSceneSession: UISceneSession,
            options: UIScene.ConnectionOptions
        ) -> UISceneConfiguration {

            UISceneConfiguration(
                name: "Default Configuration",
                sessionRole: connectingSceneSession.role
            )
        }
    }


    private extension AppDelegate {

        func configureAppEnvironment() {
            detectCountry()
            LocalizationInit()
        }

        func configureKeyboard() {
            IQKeyboardManager.shared.isEnabled = true
            IQKeyboardManager.shared.resignOnTouchOutside = true
        }
        
        func configureFirebase() {
              FirebaseApp.configure()
              Messaging.messaging().delegate = self
          }
        
        func sendTokenToBackend(token:String?) {
                    print("Firebase registration token: \(token ?? "")")
                    // Retrieve the previous token from UserDefaults or wherever you store it
                    let previousToken = Helper.shared.getFirebaseToken()
            
                    if let newToken = token, newToken != previousToken {
                        // Token has changed, do something with the new token
                        print("New Firebase token: \(newToken)")
                        // Update the stored token
                        Shared.shared.NewFirebaseToken = true
                        Helper.shared.setFirebaseToken(token: newToken)
                        // Notify observers about the new token
                        let dataDict: [String: String] = ["token": newToken]
                        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
                    } else {
                        // Token is either nil or hasn't changed
                        print("Token is either nil or hasn't changed")
                    }
        }

    }

    private extension AppDelegate {

        func configureNotifications(_ application: UIApplication) {

            let center = UNUserNotificationCenter.current()
            center.delegate = self

            center.requestAuthorization(
                options: [.alert, .badge, .sound]
            ) { granted, _ in
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        }
    }

extension AppDelegate {
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {

        func messaging(
            _ messaging: Messaging,
            didReceiveRegistrationToken fcmToken: String?
        ) {
            guard let token = fcmToken else { return }
            print("🔥 FCM Token:", token)

            // TODO: send token to backend
            sendTokenToBackend(token: token )
        }
        
    }

    extension AppDelegate: UNUserNotificationCenterDelegate {
        
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification
        ) async -> UNNotificationPresentationOptions {
//            SoundPlayer().play(.receive)
            let userInfo = notification.request.content.userInfo
               print("Foreground push received:", userInfo)

               // Optional: play sound via SoundPlayer
               SoundPlayer.shared.play(.receive)

               // ✅ Show banner, badge, sound
               return [.banner, .list, .badge, .sound]
        }
        
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse
        ) async {

            let userInfo = response.notification.request.content.userInfo

            guard
                let type = userInfo["type"] as? String,
                type == "chat",
                let packageId = userInfo["customerPackageId"] as? String
            else { return }
            
            NotificationCenter.default.post(
                name: .openChatFromNotification,
                object: nil,
                userInfo: ["packageId": packageId]
            )
        }
        
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            print("userInfo2 : \(userInfo)")
            // if app in background make sound
//            var systemSoundID : SystemSoundID = 1007 // doesnt matter; edit path instead
//            let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/sms-received1.caf")
//            AudioServicesCreateSystemSoundID(url as CFURL, &systemSoundID)
//            AudioServicesPlaySystemSound(systemSoundID)

            SoundPlayer.shared.play(.receive)
            completionHandler(.newData)
        }
        
    //        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    //            if let messageID = userInfo[gcmMessageIDKey] {
    //                print("Message ID: \(messageID)")
    //            }
    //            print("userInfo1 : \(userInfo)")
    //
    //        }

    }



    extension Notification.Name {
        static let openChatFromNotification = Notification.Name("openChatFromNotification")
    }


    // MARK: --- Localization ---
    extension AppDelegate {
        func LocalizationInit() {
    //        UIFont.familyNames.forEach({ familyName in
    //            let fontNames = UIFont.fontNames(forFamilyName: familyName)
    //            print("familyName, fontNames",familyName, fontNames)
    //        })

    //        changeLanguage(to: Helper.shared.getLanguage())
            LocalizationManager.shared.changeLanguage(to: Helper.shared.getLanguage()) {

            }


    //        LocalizationManager.shared.setLanguage(Helper.shared.getLanguage()) { _ in
    //            // Ensure this code is executed on the main thread
    ////            DispatchQueue.main.async {
    ////                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
    ////                    sceneDelegate.reloadRootView()
    ////                }
    ////            }
    //        }
            print("Helper Language is:", Helper.shared.getLanguage())
            print("LocalizationManager Language is:", LocalizationManager.shared.currentLanguage)

            // Uncomment the following if you need to fetch translations
            // LocalizationManager.shared.fetchTranslations() { success in
            //    if success {
            //        print("✅ Localization updated successfully")
            //    } else {
            //        print("❌ Failed to update localization")
            //    }
            // }
        }


        func detectCountry() {
            locationService = LocationService() // keep a strong reference

            locationService?.onCountryDetected = { countryCode in
                if let code = countryCode {
                    print("Detected Country: \(code)")

                    // Example: Set global flags or variables
                    if code == "EG" {
                        print("🇪🇬 User is in Egypt")
                    } else if code == "SA" {
                        print("🇸🇦 User is in Saudi Arabia")
                    }
                } else {
                    print("❌ Failed to detect country")
                }
            }
        }

    }
