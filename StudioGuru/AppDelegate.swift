//
//  AppDelegate.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/10/23.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate
{



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("launchOptions---->",launchOptions)
        
        
        if(launchOptions != nil)
        {
            //SharedData.sharedInstance.showMessage(title: "Alert", message: "yes")
        }
        
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil
        {
            //launchOptions![UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]
            
           // SharedData.sharedInstance.showMessage(title: "Alert", message: "yes!")
        }
        
        UNUserNotificationCenter.current().delegate = self
               UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
                   // Handle the user's response to the request, if needed.
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           // Check if the notification contains a JSON payload
        print("RECIEVE_NOTIFICATION")
        
        //SharedData.sharedInstance.showMessage(title: "Alert", message: "Received Notification1")
        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
               // Handle the JSON payload here
               print("Received notification with payload: \(userInfo)")
            
            if let type = userInfo["type"] as? String
            {
                       //do something with url here
                print("type---->",type)
                
                if(SharedData.sharedInstance.member_id == "")
                {
                    SharedData.sharedInstance.didOpenFromPush = true
                    return
                }
                
                if(type == "chat")
                {
                    let chat_id = userInfo["chat_id"] as! String
                    
                    if(chat_id == SharedData.sharedInstance.chat_id)
                    {
                        SharedData.sharedInstance.postEvent(event: "RELOAD_CURRENT_CHAT")
                    }else{
                        SharedData.sharedInstance.tmp_chat_id = chat_id
                        SharedData.sharedInstance.tmp_chat_title = userInfo["chat_name"] as! String
                        SharedData.sharedInstance.postEvent(event: "UPDATE_BADGE_COUNT")
                        SharedData.sharedInstance.postEvent(event: "SHOW_CHAT_BANNER")
                        SharedData.sharedInstance.checkChatCount()
                    }
                }
                
               // SharedData.sharedInstance.showMessage(title: "Alert", message: "Type")
                }
           }

           // Call the completion handler when done
           completionHandler()
       }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
           // Check if the notification contains a JSON payload
        //SharedData.sharedInstance.showMessage(title: "Alert", message: "Did Recieve!")
        print("userInfo--->",userInfo)
        if(((userInfo["type"] as! AnyHashable) as! String) == "chat")
        {
           // SharedData.sharedInstance.showMessage(title: "Alert", message: "Chat!")
        }
        
        if let type = userInfo[AnyHashable("type")] as? String
        {
                   //do something with url here
            print("type---->",type)
            
            if(type == "chat")
            {
                let chat_id = userInfo[AnyHashable("chat_id")] as! String
                
                if(chat_id == SharedData.sharedInstance.chat_id)
                {
                    SharedData.sharedInstance.postEvent(event: "RELOAD_CURRENT_CHAT")
                }else{
                    SharedData.sharedInstance.tmp_chat_id = chat_id
                    SharedData.sharedInstance.tmp_chat_title = userInfo[AnyHashable("chat_name")] as! String
                    SharedData.sharedInstance.postEvent(event: "UPDATE_BADGE_COUNT")
                    SharedData.sharedInstance.postEvent(event: "SHOW_CHAT_BANNER")
                    SharedData.sharedInstance.checkChatCount()
                }
            }
            
           // SharedData.sharedInstance.showMessage(title: "Alert", message: "Type")
            }
        
//        if((userInfo["AnyHashable(\"type\")"] as! String) == "chat")
//        {
//            SharedData.sharedInstance.showMessage(title: "Alert", message: "Chat!!")
//        }
        
        //AnyHashable("type")
        
           if let jsonPayload = userInfo["payload"] as? [String: Any] {
               // Handle the JSON payload here
               print("Received notification with payload: \(jsonPayload)")
           }
       }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // Convert the device token to a string.
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        
        SharedData.sharedInstance.device_token = token
        // Print the device token to the console.
        print("Device token1: \(token)")
        
        SharedData.sharedInstance.postEvent(event: "TOKEN_LOADED")
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        
    }


}

