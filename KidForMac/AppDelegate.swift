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
        let targetPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] + "/KidForIpadAssets/";
        AssetsExportTool.instance.exportAssetsByPath("/Users/guominglong/Desktop/ACSwift/IGS_Pro/TK_IGS_iPad_Swift/Assets.xcassets", targetPath: targetPath, onComplete: { 
            NSLog("资源导出成功");
            }) { (ne) in
                NSLog("\(ne.code)");
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

