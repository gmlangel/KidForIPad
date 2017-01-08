//
//  AppDelegate.swift
//  KidForIPad
//
//  Created by guominglong on 2017/1/1.
//  Copyright © 2017年 KidForMac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let opt = PNOption();
        opt.needAlert = true;
        opt.needbadge = true;
        opt.needSound = true;
        opt.needCarPlay = true
        PushNotificationTool.instance.ginit(opt);
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /**
     收到了一个远程推送通知
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("iOS7及以上系统，收到通知:\(userInfo)");
        completionHandler(UIBackgroundFetchResult.newData);
    }

    /**
     收到了一个远程推送通知
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("iOS6及以下系统，收到通知:\(userInfo)");
    }
    
    /**
     收到了一个本地推送通知
     */
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        NSLog("收到一个本地推送通知")
    }
    
    /**
     获得Device Token成功
     */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("获取Device Token成功,token:\(String(data:deviceToken,encoding:String.Encoding.utf8))");
    }
    
    /**
     获得Device Token失败
     */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("获取Device Token失败,err:\(error.localizedDescription)");
    }
}

