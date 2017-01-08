//
//  AppDelegate.swift
//  KidForMac
//
//  Created by guominglong on 16/12/30.
//  Copyright © 2016年 KidForIPad. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        CTResourceManager.instance.deleteAllResource();
        PushNotificationTool_Mac.instance.ginit();
        PushNotificationTool_Mac.instance.checkIsOpenByUserNotification(appDidFinishNotifycation: aNotification);

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    //MARK:资源导出功能
    @IBAction func exportAssets(_ sender: AnyObject) {
        let story = NSStoryboard.init(name: "Main", bundle: Bundle.main);
        let vc = story.instantiateController(withIdentifier: "AssetsExportStory") as! NSViewController;
        NSApplication.shared().mainWindow?.contentViewController?.presentViewControllerAsModalWindow(vc);
    }

    private func application(application: NSApplication, didReceiveRemoteNotification userInfo: [String : AnyObject]) {
        NSLog("收到一条远程通知")
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/test.txt";
        let str = "\(userInfo)";
        do{
            try str.write(toFile: path, atomically: true, encoding: String.Encoding.utf8);
        }catch{
        
        }
    }
    
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("成功获得了device push token:\(deviceToken)");
        //一定要将deviceToken传给服务器，否则远程通知不生效
    }
    
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("获取device push token失败，原因:%@",error.localizedDescription);
    }
}

