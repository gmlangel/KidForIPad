//  viewController基础类
//  BaseViewController.swift
//  KidForIPad
//
//  Created by guominglong on 2017/2/6.
//  Copyright © 2017年 KidForMac. All rights reserved.
//

import Foundation
class BaseViewController: NSViewController {
    override func viewWillAppear() {
        这句话不好用，得自己写居中
        self.view.window?.center();
    }
    
    override func viewDidAppear() {
    }
}
