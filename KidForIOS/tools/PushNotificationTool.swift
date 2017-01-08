//  推送通知工具类
//  PushNotificationTool.swift
//  KidForIPad
//
//  Created by guominglong on 2017/1/2.
//  Copyright © 2017年 KidForMac. All rights reserved.
//

import Foundation
import UserNotifications
class PushNotificationTool: NSObject,UNUserNotificationCenterDelegate {

    static var instance:PushNotificationTool{
        get{

            struct PushNotificationToolStruc{
                static var _ins:PushNotificationTool = PushNotificationTool();
            }
            return PushNotificationToolStruc._ins;
        }
    }
    
    /**
     初始化推送通知工具
     options 在10.0系统以上（含10.0），使用UNAuthorizationOptions。在10.0系统以下，使用UIUserNotificationType
     */
    func ginit(_ options:PNOption){
        let iosSys = Double(UIDevice.current.systemVersion)!;
        do{
            if iosSys >= 10.0{
                try self.notification_10_Later(options);
            }else if iosSys > 8.0{
                self.notification_8_10(options);
            }else{
                NSLog("要注册推送通知的系统是不被支持的:\(iosSys)");
            }
            
        }catch{
            NSLog("\(error.localizedDescription)");
        }
        
    }
    
    /**
     10.0以后的通知处理
     */
    private func notification_10_Later(_ options:PNOption) throws -> Void{
        if #available(iOS 10.0, *) {
            //创建option
            var optionValue:UInt = 0;
            if options.needAlert {
                optionValue |= UNAuthorizationOptions.alert.rawValue;
            }
            
            if options.needSound {
                optionValue |= UNAuthorizationOptions.sound.rawValue;
            }
            
            if options.needbadge {
                optionValue |= UNAuthorizationOptions.badge.rawValue;
            }
            
            if options.needCarPlay {
                optionValue |= UNAuthorizationOptions.carPlay.rawValue;
            }
            let option = UNAuthorizationOptions(rawValue: optionValue);
            //创建推送处理中心
            let center = UNUserNotificationCenter.current()
            center.delegate = self;
            center.requestAuthorization(options: option, completionHandler: { (isCompleted, err) in
                if err != nil{
                    NSLog("errDescription:\(err.debugDescription)");
                }else{
                    if isCompleted == true{
                        //用户点击了 允许
                        center.getNotificationSettings(completionHandler: { (notifySetting) in
                            NSLog("\(notifySetting)");
                        })
                    }else{
                        //用户点击了 拒绝
                        NSLog("[notification_10]用户拒绝开启通知");
                    }
                }
            })
            //注册device push token
            UIApplication.shared.registerForRemoteNotifications();
        } else {
            // Fallback on earlier versions
            throw NSError(domain: "org.gml.err", code: CTErrorEnum.pushNotification_Err.rawValue, userInfo: ["errorInfo":"notification_10函数处理错误"]);
        }
    }
    
    /**
     8.0 - 10.0之间的处理函数
     */
    private func notification_8_10(_ options:PNOption) -> Void{
        //创建option
        var optionValue:UInt = 0;
        if options.needAlert {
            optionValue |= UIUserNotificationType.alert.rawValue
        }
        
        if options.needSound {
            optionValue |= UIUserNotificationType.sound.rawValue;
        }
        
        if options.needbadge {
            optionValue |= UIUserNotificationType.badge.rawValue;
        }
        let option = UIUserNotificationType(rawValue: optionValue);
        //创建推送处理中心
        let app = UIApplication.shared;
        app.registerUserNotificationSettings(UIUserNotificationSettings(types: option, categories: nil));
        //注册device push token
        UIApplication.shared.registerForRemoteNotifications();
    }
    
//    /**
//     8.0以下的系统
//     */
//    private func notification_8_Before(_ options:PushNotificationOption) -> Void{
//        //创建option
//        var optionValue:UInt = 0;
//        if options.needAlert {
//            optionValue |= UIRemoteNotificationType.alert.rawValue
//        }
//        
//        if options.needSound {
//            optionValue |= UIRemoteNotificationType.sound.rawValue;
//        }
//        
//        if options.needbadge {
//            optionValue |= UIRemoteNotificationType.badge.rawValue;
//        }
//        let option = UIRemoteNotificationType(rawValue: optionValue);
//        //创建推送处理中心
//        let app = UIApplication.shared;
//        app.registerUserNotificationSettings(UIUserNotificationSettings(types: option, categories: nil));
//        //注册device push token
//        UIApplication.shared.registerForRemoteNotifications();
//    }
    
    /**
     创建一个本地推送
     //在规定的日期触发通知
     //UIApplication.shared.scheduleLocalNotification(localNotification);
     //立即触发一个通知
     //[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
     */
    func makeLocalNotification(_ notifyEntity:PNLocalEntity) throws -> UILocalNotification?{
        if notifyEntity.localNotifyKey == ""{
            throw NSError(domain: "org.gml.err", code: CTErrorEnum.pushNotification_NullNotifyKey.rawValue, userInfo: nil);
        }
        let localNotification = UILocalNotification();
        //设置本地通知的触发时间（如果要立即触发，无需设置），这里设置为5妙后
        localNotification.fireDate = Date(timeIntervalSinceNow: notifyEntity.delay);
        //设置本地通知的时区
        localNotification.timeZone = NSTimeZone.default;
        //设置通知的title
        if #available(iOS 8.2, *) {
            localNotification.alertTitle = notifyEntity.alertTitle
        } else {
            // Fallback on earlier versions
        };
        //设置通知的内容
        localNotification.alertBody = notifyEntity.alertContext;
        //设置通知动作按钮的标题
        localNotification.alertAction = notifyEntity.alertActionText;
        //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
        localNotification.userInfo = ["name":"郭明龙","age":13,"notifyKey":notifyEntity.localNotifyKey];
        return localNotification;
    }
    
    /**
     取消某个正在进行的本地通知
     */
    func cancelLocalNotification(localNotifyKey:String){
        if let arr = UIApplication.shared.scheduledLocalNotifications{
            for notify in arr{
                if let obj = notify.userInfo{
                    //找到对应的key，删除这个指定的本地通知
                    if obj["notifyKey"] != nil && obj["notifyKey"] as! String == localNotifyKey{
                        UIApplication.shared.cancelLocalNotification(notify);
                        break;
                    }
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //ios 10.0 处理用户点击推送面板时的操作
        let userInfo = response.notification.request.content.userInfo;
        let request = response.notification.request; // 收到推送的请求
        let content = request.content; // 收到推送的消息内容
        let badge = content.badge;  // 推送消息的角标
        let body = content.body;    // 推送消息体
        let sound = content.sound;  // 推送消息的声音
        let subtitle = content.subtitle;  // 推送消息的副标题
        let title = content.title;  // 推送消息的标题
        if let trigger = request.trigger{
            if trigger.isKind(of: UNPushNotificationTrigger.self){
                NSLog("iOS10 正要处理远程通知:\(userInfo)");
            }else{
                // 判断为本地通知
                NSLog("iOS10 正要处理本地通知\nbody:\(body)\ntitle:\(title)\nsubtitle:\(subtitle)\nbadge:\(badge)\nsound:\(sound)\nuserInfo:\(userInfo)");
            }
        }
        completionHandler();  // 系统要求执行这个方法
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //ios 10.0 收到一个推送通知
        let userInfo = notification.request.content.userInfo;
        let request = notification.request; // 收到推送的请求
        let content = request.content; // 收到推送的消息内容
        let badge = content.badge;  // 推送消息的角标
        let body = content.body;    // 推送消息体
        let sound = content.sound;  // 推送消息的声音
        let subtitle = content.subtitle;  // 推送消息的副标题
        let title = content.title;  // 推送消息的标题
        
        if let trigger = request.trigger{
            if trigger.isKind(of: UNPushNotificationTrigger.self){
                NSLog("iOS10 收到远程通知:\(userInfo)");
            }else{
                // 判断为本地通知
                NSLog("iOS10 收到本地通知\nbody:\(body)\ntitle:\(title)\nsubtitle:\(subtitle)\nbadge:\(badge)\nsound:\(sound)\nuserInfo:\(userInfo)");
            }
        }
        let option = UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.badge.rawValue|UNNotificationPresentationOptions.alert.rawValue|UNNotificationPresentationOptions.sound.rawValue);
        completionHandler(option); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    }
}

/**
 推送类型
 */
class PNOption: NSObject {
    var needAlert:Bool = false;
    var needSound:Bool = false;
    var needbadge:Bool = false;
    var needCarPlay:Bool = false;
}

/**
 本地推送通知结构体
 */
class PNLocalEntity: NSObject {
    /**
     alert显示标题
     */
    var alertTitle:String = "";
    
    /**
     alert显示内容
     */
    var alertContext:String = "";
    
    /**
     alert的按钮的text
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
}
