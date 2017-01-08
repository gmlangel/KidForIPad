//  推送通知工具类 mac版
//  PushNotificationTool_Mac.swift
//  MacLogAnalyze
//
//  Created by guominglong on 17/1/3.
//  Copyright © 2017年 MSC_Mac. All rights reserved.
//

import Foundation
import AppKit
/**
 被一个通知拉起的app
 */
let UserNotificationOpenNotificationKey:String = "UserNotificationOpenNotificationKey";
class PushNotificationTool_Mac: NSObject,NSUserNotificationCenterDelegate {
    var notifyCount = 0;
    static var instance:PushNotificationTool_Mac{
        get{
            struct PushNotificationTool_MacStruct{
                static var _ins = PushNotificationTool_Mac();
            }
            return PushNotificationTool_MacStruct._ins;
        }
    }
    /**
     初始化推送通知工具
     */
    func ginit(){
        //获得通知中心
        let center = NSUserNotificationCenter.default;
        //设置通知中心的代理
        center.delegate = self;
        //注册device push token
        let remoteType = NSRemoteNotificationType.badge.rawValue | NSRemoteNotificationType.alert.rawValue | NSRemoteNotificationType.sound.rawValue;
        //注册推送类型
        NSApplication.shared().registerForRemoteNotifications(matching: NSRemoteNotificationType(rawValue: remoteType));
    }
    
    /**
     检测是否由一个usernotification调起了应用。
     @param appDidFinishNotifycation 是一个app启动完毕时的系统级通知，从中可以判断出当前的app是否是由一个推送而启动的，并做响应处理
     */
    func checkIsOpenByUserNotification(appDidFinishNotifycation:Notification?)
    {
        //解析notify，判断app是否是由一个推送通知调起的。
        if let userNotify = appDidFinishNotifycation?.userInfo?[NSApplicationLaunchUserNotificationKey]{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserNotificationOpenNotificationKey), object: userNotify);
        }
    }
    
    /**
     手动创建一个本地通知
     注意事项，本地通知的显示样式（显示几个按钮或者不显示按钮，“回复”按钮除外）完全取决于用户的  系统偏好设置中的通知设置
     */
    func makeLocalNotification(notifyEntity:PNLocalEntity)->NSUserNotification{
        let localNotify = NSUserNotification();
        //设置通知的主标题
        localNotify.title = notifyEntity.alertTitle;
        //设置通知的子标题
        localNotify.subtitle = notifyEntity.alertSubTitle;
        //设置通知的主体内容
        localNotify.informativeText = notifyEntity.alertContext;
        //设置通知的按钮显示文本
        if notifyEntity.alertActionText != ""{
            localNotify.hasActionButton = true;
            localNotify.actionButtonTitle = notifyEntity.alertActionText;//太坑了，一定要手动设置 系统偏好设置中的  通知样式，才可以看得到
        }else{
            localNotify.hasActionButton = false;
        }
        //设置通知的必要的用户信息（用于取消）
        localNotify.userInfo = ["localNotifyKey":notifyEntity.localNotifyKey,"awaysShow":notifyEntity.awaysShow];
        localNotify.identifier = notifyEntity.id;
        //设置通知的延后显示时间
        localNotify.deliveryDate = Date(timeIntervalSinceNow: notifyEntity.delay);
        //设置通知发生的时区  默认为用户所在的时区
        localNotify.deliveryTimeZone = NSTimeZone.default;
        //设置通知的声音
        localNotify.soundName = NSUserNotificationDefaultSoundName;
        //NSLog(localNotify.soundName!);
        //自定义一些按钮事件
        localNotify.additionalActions = notifyEntity.customActions;
        return localNotify;
    }
    
    /**
     移除一个notifaction不论是否处理过它
     */
    func cancelNotifactionById(notifyId:String){
        var arr = NSUserNotificationCenter.default.scheduledNotifications;
        for noti in arr{
            if let id = noti.identifier{
                if id == notifyId{
                    NSUserNotificationCenter.default.removeScheduledNotification(noti);
                    break;
                }
            }
        }
        
        
        arr += NSUserNotificationCenter.default.deliveredNotifications;
        
        for not in arr{
            if let id = not.identifier{
                if id == notifyId{
                NSUserNotificationCenter.default.removeDeliveredNotification(not);
                    break;
                }
            }
        }
    }
    
    
    
    //MARK:NSUserNotificationCenterDelegate的实现
    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification){
        notifyCount += 1;
        NSApplication.shared().dockTile.badgeLabel = "\(notifyCount)";//显示app图标右上角的计数
        if notification.isRemote == true{
            NSLog("收到一条远程通知");
        }else{
            NSLog("收到一条本地通知");
        }
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        //收到一个推送通知，下面是处理代码
        NSLog("用户点击了通知面板，执行对应的处理");
        switch notification.activationType{
        case NSUserNotification.ActivationType.actionButtonClicked:NSLog("点击了通知的默认按钮");break;
        case NSUserNotification.ActivationType.additionalActionClicked:NSLog("点击了通知的用户自定义按钮");break;
        case NSUserNotification.ActivationType.contentsClicked:NSLog("点击了通知的内容面板");break;
        case NSUserNotification.ActivationType.replied:NSLog("点击了回复按钮");break;
        default:NSLog("用户什么都没点击");break;
        }
        if let uInfo = notification.userInfo{
            NSLog("userInfo：\(uInfo)")
        }
        
        if let id = notification.identifier{
            self.cancelNotifactionById(notifyId: id);
        }
        //还原app图标右上角的计数
        notifyCount = 0;
        NSApplication.shared().dockTile.badgeLabel = nil;
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        //如果return为true则app无论出于激活还是没激活，关闭状态都会提示通知。  如果设置为false则只有app处于未激活，关闭状态时才提示
        var b = false;
        if let uInfo = notification.userInfo{
            if let bValue = uInfo["awaysShow"] as? Bool{
                b = bValue;
            }
        }
        return b;
    }
}

/**
 本地推送通知结构体
 */
class PNLocalEntity: NSObject {
    
    /**
     是否app无论出于激活还是没激活，关闭状态都会提示通知，默认为不是所有状态都提示
     */
    var awaysShow:Bool = false;
    /**
     alert显示的主标题
     */
    var alertTitle:String = "";
    
    /**
     alert显示的子标题
     */
    var alertSubTitle:String = "";
    
    /**
     alert显示内容
     */
    var alertContext:String = "";
    
    /**
     alert的按钮的text
     太坑了，一定要手动设置 系统偏好设置中的  通知样式，才可以看得到
     */
    var alertActionText:String = "";
    
    /**
     推送的延迟时间
     */
    var delay:TimeInterval = 0;
    
    /**
     推送通知的唯一key
     */
    var localNotifyKey:String = "";
    
    /**
     用户自定义的按钮事件
     */
    var customActions:[NSUserNotificationAction]?;
    
    /**
     🆘这个属性慎用，会有很多问题
     设置这个属性，那么这个通知永远只会弹一次,除非从队列中移除这个通知
     */
    var id:String?;
}
