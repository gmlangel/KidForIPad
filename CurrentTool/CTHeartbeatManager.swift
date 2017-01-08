//  心跳控制器
//  CTHeartbeatManager.swift
//  AC for swift
//
//  Created by guominglong on 15/5/20.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation

public class CTHeartbeatManager: NSObject {
    
    public var taskArr:NSMutableDictionary;
    public class var instance:CTHeartbeatManager{
        get{
            struct CTHeartbeatManagerStruct{
                static var _ins = CTHeartbeatManager();
            }
            return CTHeartbeatManagerStruct._ins;
        }
    }
    
    public override init() {
        taskArr = NSMutableDictionary();
        super.init();
    }
    
    public func hasTask(taskName:String)->Bool
    {
        return taskArr.value(forKey: taskName) != nil;
    }
    
    /**
    绑定任务
    sel 要绑定的函数
    ti  间隔时间
    tg  target
    taskName 绑定名称
    repeats 是否循环执行
    */
    public func addTask(sel:Selector,ti:TimeInterval,tg:AnyObject,taskName:String,repeats:Bool = true)
    {
        let nt:Timer = Timer.scheduledTimer(timeInterval: ti, target: tg, selector: sel, userInfo: nil, repeats: repeats);
        taskArr.setObject(nt, forKey: taskName as NSCopying);
    }
    
    /**
    删除绑定的任务
    */
    public func removeTask(taskName:String)
    {
        if(hasTask(taskName: taskName) == false)
        {
            return;
        }
        let nt:Timer = taskArr.object(forKey: taskName)as! Timer;
        nt.invalidate();
        taskArr.removeObject(forKey: taskName);
    }
    
    /**
    移除所有任务
    */
    public func removeAllTask()
    {
        var arr:Array = taskArr.allKeys;
        var nt:Timer;
        let j = arr.count
        for i:Int in 0 ..< j
        {
            nt = taskArr.object(forKey: arr[i]) as! Timer;
            nt.invalidate();
            taskArr.removeObject(forKey: arr[i]);
        }
    }
    

    
}
