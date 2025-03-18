//
//  AppDelegate.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import DropDown
import AVFoundation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var window : UIWindow?
    let gcmMessageIDKey = "gcm.Message_ID"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LocalizationInit()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 10.0, *) {
            Messaging.messaging().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("userInfo1 : \(userInfo)")
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("userInfo2 : \(userInfo)")
        // if app in background make sound
        var systemSoundID : SystemSoundID = 1007 // doesnt matter; edit path instead
        let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/sms-received1.caf")
        AudioServicesCreateSystemSoundID(url as CFURL, &systemSoundID)
        AudioServicesPlaySystemSound(systemSoundID)

        completionHandler(.newData)
    }
    
    
    
//    func showCustomNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = UNNotificationSound.default
//
//        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: nil)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
//            if let error = error {
//                print("Error displaying notification: \(error.localizedDescription)")
//            }
//        })
//    }
    
}


extension AppDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        // Retrieve the previous token from UserDefaults or wherever you store it
        let previousToken = Helper.shared.getFirebaseToken()
        
        if let newToken = fcmToken, newToken != previousToken {
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("deviceToken : \(deviceToken)")
    }
    
    
}


extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("userInfo userInfo : \(userInfo)")
        // play sound
        // play sound
        var systemSoundID : SystemSoundID = 1007 // doesnt matter; edit path instead
        let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/sms-received1.caf")
        AudioServicesCreateSystemSoundID(url as CFURL, &systemSoundID)
        AudioServicesPlaySystemSound(systemSoundID)
        
        completionHandler([.alert, .badge , .sound])
    }
}

//MARK: --- Localization ---
extension AppDelegate{
    func LocalizationInit() {
        LocalizationManager.shared.setLanguage(Helper.shared.getLanguage()) { _ in }

//        let currentLanguage = Locale.current.languageCode ?? "en" // Detect user's language
//        LocalizationManager.shared.fetchTranslations(language: currentLanguage) { success in
//            if success {
//                print("✅ Localization updated successfully")
//            } else {
//                print("❌ Failed to update localization")
//            }
//        }
    }
}
