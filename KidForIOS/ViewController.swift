//
//  ViewController.swift
//  KidForIPad
//
//  Created by guominglong on 2017/1/1.
//  Copyright © 2017年 KidForMac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let btn = UIButton(type: UIButtonType.custom);
        btn.frame = CGRect(x: 0, y: 50, width: 100, height: 30);
        btn.addTarget(self, action: #selector(ontestClick), for: UIControlEvents.touchDown);
        btn.setTitle("测试", for: UIControlState.normal);
        btn.setTitleColor(UIColor.red, for: UIControlState.normal);
        self.view.addSubview(btn);
    }
    
    func ontestClick(sender:AnyObject)
    {
        let notify = PNLocalEntity();
        notify.alertActionText = "我知道了";
        notify.alertTitle = "测试用";
        notify.alertContext = "hahahah";
        notify.localNotifyKey = "mykey";
        notify.delay = 5;
        do{
            //发起一个本地推送
            if let notify = try PushNotificationTool().makeLocalNotification(notify){
                UIApplication.shared.scheduleLocalNotification(notify);
            }
        }catch{
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

