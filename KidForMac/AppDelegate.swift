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



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    //MARK:资源导出功能
    @IBAction func exportAssets(sender: AnyObject) {
        let story = NSStoryboard.init(name: "Main", bundle: NSBundle.mainBundle());
        let vc = story.instantiateControllerWithIdentifier("AssetsExportStory") as! NSViewController;
        NSApplication.sharedApplication().runModalForWindow(NSWindow(contentViewController: vc));
    }

}

