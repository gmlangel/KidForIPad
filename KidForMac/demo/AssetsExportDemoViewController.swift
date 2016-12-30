//  AssetsExportTool的使用demo
//  AssetsExportDemoViewController.swift
//  KidForIPad
//
//  Created by guominglong on 16/12/30.
//  Copyright © 2016年 KidForIPad. All rights reserved.
//

import Foundation

class AssetsExportDemoViewController: NSViewController {
    @IBOutlet weak var tb_sourceTextfield: NSTextField!
    override func viewDidLoad() {
        self.title = "AssetsExportTool的使用demo";
    }
    /**
     开始导出资源
     */
    @IBAction func beginExportAssets(sender: AnyObject) {
        
        if tb_sourceTextfield.stringValue != "" && tb_targetTextfield.stringValue != "" && tb_sourceTextfield.stringValue != tb_targetTextfield.stringValue{
            AssetsExportTool.instance.exportAssetsByPath(tb_sourceTextfield.stringValue, targetPath: tb_targetTextfield.stringValue, onComplete: { [weak self] in
                self?.alert("操作成功")
                }, onError: { (ne) in
                    NSLog("\(ne.code)");
                    self.alert("操作失败")
            })
        }else{
            alert("路径不能为空");
        }
    }
    
    func alert(str:String){
        let story = NSStoryboard.init(name: "Main", bundle: NSBundle.mainBundle());
        let vc = story.instantiateControllerWithIdentifier("TishiPanelStory") as! Tishi;
        vc.tishiStr = str;
        self.presentViewControllerAsModalWindow(vc);
    }
    @IBOutlet weak var tb_targetTextfield: NSTextField!
}