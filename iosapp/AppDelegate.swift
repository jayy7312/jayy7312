//
//  AppDelegate.swift
//  iosapp


import UIKit
import BMSCore
import BMSPush

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.usSouth)
        myBMSClient.requestTimeout = 10.0 // seconds

        

        if let contents = Bundle.main.path(forResource:"BMSCredentials", ofType: "plist"), let dictionary = NSDictionary(contentsOfFile: contents) {
            let push = BMSPushClient.sharedInstance
            let appGuid = (dictionary["push"] as! NSDictionary)["appGuid"] as! String
            let clientSecret = (dictionary["push"] as! NSDictionary)["clientSecret"] as! String
            push.initializeWithAppGUID(appGUID: appGuid, clientSecret: clientSecret)
        }

        
        return true
    }

    
    
    // Alerts the user of a received push notification when the app is running in the foreground.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // UserInfo dictionary will contain data sent from the server.
        var userPayload = String()
        let payload = ((((userInfo as NSDictionary).value(forKey:"aps") as! NSDictionary).value(forKey:"alert") as! NSDictionary).value(forKey:"body") as! NSString)
        let additionalPayload = (userInfo as NSDictionary).value(forKey:"payload")
        userPayload = additionalPayload.debugDescription

        let alert = UIAlertController(title: "Push Notification Received",
                                      message: payload as String,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        application.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

        print("Recieved IBM Cloud Push Notifications message: " + (payload as String) + ", payload: " + (userPayload as String))
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


}

