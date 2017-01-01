//  资源管理器
//  CTResourceManager.swift
//  KidForIPad
//
//  Created by guominglong on 2017/1/1.
//  Copyright © 2017年 KidForMac. All rights reserved.
//

import Foundation
class CTResourceManager: NSObject {
    var resourceMap:[String:CTResource];
    
    static var instance:CTResourceManager{
        get{
            struct CTResourceManagerStr{
                static let _ins:CTResourceManager = CTResourceManager();
            }
            return CTResourceManagerStr._ins
        }
    }
    override init() {
        resourceMap = [String:CTResource]();
        super.init();
    }
    
    /**
     创建资源
     resourceName 资源名称
     res 资源
     isLocked 是否强引用 默认为不强引用
     */
    func addResourceByName(_ resourceName:String,res:Any,isLocked:Bool = false){
        let r = CTResource();
        r.resName = resourceName;
        r.res = res;
        r.isLocked = isLocked;
        resourceMap[resourceName] = r;
    }
    
    /**
     根据资源名称，返回资源
     resourceName 资源名称
     */
    func getResourceByName(_ resourceName:String)->CTResource?{
        if resourceMap.keys.contains(resourceName){
            return resourceMap[resourceName];
        }else{
            return nil;
        }
    }
    
    /**
     根据资源名称，删除资源
     */
    func deleteResourceByName(_ resourceName:String){
        if resourceMap.keys.contains(resourceName){
            let ir = resourceMap.removeValue(forKey: resourceName)! as CTResource;
            ir.res = nil;
        }
    }

    
    /**
     删除所有资源
     */
    func deleteAllResource(){
        let arr = resourceMap.keys;
        for str in arr{
            resourceMap[str]?.res = nil;
        }
        resourceMap.removeAll();
    }
    
    /**
     删除所有没加锁的资源
     */
    func deleteUnLockImg(){
        let arr = resourceMap.keys;
        for str in arr{
            if let ir = resourceMap[str]{
                if ir.isLocked == false{
                    resourceMap[str]?.res = nil;
                    resourceMap.removeValue(forKey: str);
                }
            }
        }
    }
}


/**
 通用资源类型
 */
class CTResource: NSObject {
    private var _isLocked:Bool = false;
    /**
     资源的锁定状态
     */
    var isLocked:Bool{
        get{
            return _isLocked;
        }
        set{
            _isLocked = newValue;
            if _isLocked == false{
                //如果这个值被设置为false，则从资源管理器中删除self
                CTResourceManager.instance.deleteResourceByName(self.resName);
            }
        }
    }
    
    /**
     资源
     */
    var res:Any?;
    
    /**
     资源名称
     */
    var resName:String = "";
}
