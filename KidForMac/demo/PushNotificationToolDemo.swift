//
//  PushNotificationToolDemo.swift
//  MacLogAnalyze
//
//  Created by guominglong on 17/1/5.
//  Copyright © 2017年 MSC_Mac. All rights reserved.
//

import Foundation
class PushNotificationToolDemo: NSObject {
    /**
     创建一个本地通知， 有一个注意事项。  本地通知的显示样式完全取决于系统的偏好设置， 如果想显示多按钮，则必须手动修改系统的通知样式
     */
    func createLocalUserNotify(){
        let notifyEntity = PNLocalEntity();
        notifyEntity.alertActionText = "知道了";
        notifyEntity.alertContext = "你收到通知了吗？收到了就给爷回话你收到通知了吗";
        notifyEntity.alertSubTitle = "小标题";
        notifyEntity.alertTitle = "大标题";
        notifyEntity.delay = 5;
        notifyEntity.localNotifyKey = "myNotify2";
        notifyEntity.awaysShow = true;
        let notify = PushNotificationTool_Mac.instance.makeLocalNotification(notifyEntity);
        NSUserNotificationCenter.defaultUserNotificationCenter().scheduleNotification(notify);
        return;
    }
}