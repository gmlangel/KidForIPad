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

}

