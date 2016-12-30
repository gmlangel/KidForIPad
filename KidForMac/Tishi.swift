//
//  Tishi.swift
//  KidForIPad
//
//  Created by guominglong on 16/12/30.
//  Copyright © 2016年 KidForMac. All rights reserved.
//

import Foundation
class Tishi: NSViewController {
    var tishiStr:String = "";
    override func viewDidLoad() {
        tb_tishi.stringValue = tishiStr;
    }
    @IBOutlet weak var tb_tishi: NSTextField!
    @IBAction func ongClose(sender: AnyObject) {
        
        self.dismissController(self);
    }
}