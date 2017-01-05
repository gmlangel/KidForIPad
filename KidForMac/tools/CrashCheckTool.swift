//  崩溃检测委托
//  CrashCheckTool.swift
//  51talkAC
//
//  Created by guominglong on 16/9/15.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
import ExceptionHandling
class CrashCheckTool: GMLProxy {
    static var instance:CrashCheckTool{
        get{
            struct CrashCheckToolStruct{
                static var _ins:CrashCheckTool = CrashCheckTool();
            }
            return CrashCheckToolStruct._ins;
        }
    }
    
    func start(){
        NSExceptionHandler.defaultExceptionHandler().setDelegate(self);
        NSExceptionHandler.defaultExceptionHandler().setExceptionHandlingMask(NSHandleUncaughtExceptionMask | NSHandleUncaughtSystemExceptionMask | NSHandleUncaughtRuntimeErrorMask | NSHandleTopLevelExceptionMask | NSHandleOtherExceptionMask);
        
      //  NSExceptionHandler.defaultExceptionHandler().setExceptionHandlingMask(NSLogUncaughtExceptionMask | NSLogUncaughtSystemExceptionMask | NSLogUncaughtRuntimeErrorMask | NSLogTopLevelExceptionMask | NSLogOtherExceptionMask);
    }
    
    
    override func exceptionHandler(sender: NSExceptionHandler!, shouldHandleException exception: NSException!, mask aMask: Int) -> Bool {
//        let dic = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        let path = GlobelInfo.getInstance().crashDic + String(format: "/51talkAC-%d.crash",Int(NSDate().timeIntervalSince1970));
        let arr = NSThread.callStackSymbols();//得到当前调用栈信息
        let reason = exception.reason;//非常重要，就是崩溃的原因
        let name = exception.name;//异常类型
        let userInfo = exception.userInfo;
        //暂时先不处理某些异常
        if(name == NSGenericException || name == NSAccessibilityException || name == NSInternalInconsistencyException || name == NSPortTimeoutException)
        {
            
        }else{
            let bundleInfo = NSBundle.mainBundle();
            let obj =  NSProcessInfo.processInfo().operatingSystemVersion;
            let osInfo = String(format:"os:%d.%d.%d",obj.majorVersion,obj.minorVersion,obj.patchVersion)
            let appBundleId = String(format:"bundleId:%@",bundleInfo.bundleIdentifier!);
            let appVersionStr = String(format:"version:%@(%@)",bundleInfo.infoDictionary!["CFBundleShortVersionString"] as! String,bundleInfo.infoDictionary!["CFBundleVersion"] as! String);
            let resultStr = String(format: "%@\n%@\n%@\nexception type : %@ \n crash reason : %@ \n call stack info : %@ \n userinfo:%@",osInfo,appBundleId,appVersionStr, name,reason == nil ? "" : reason!,arr,userInfo == nil ? "" : userInfo!);
            do{
                try resultStr.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding);
            }catch{
                
            }
            
            //如果当前正在上课，则缓存课程信息
            if GMLUserDefault.instance.moduleName == crVC{
                let moduleName = SDKProxy.instance.hasClassRoomPage();//获得当前的课程页面module名称
                let vc = VCFactroy.vcByModuleKey(moduleName) as! BaseController;
                let cos = vc.getCos()
                if(cos != nil)
                {
                    //缓存到本地
                    cos!.encodeAndSaveToFile(GlobelInfo.getInstance().courseSavePath);
                }
            }
            
            //如果app运行时间大于20秒，通知修复崩溃,这个逻辑已经在isCrash的setter中处理了
            GMLUserDefault.instance.isCrash = "1";
            
            //关闭日志服务
            GMLLog.instance.stop("程序发生崩溃，崩溃类型:\(name),app关闭");
        }
        
        return false;
    }
    
//    override func exceptionHandler(sender: NSExceptionHandler!, shouldLogException exception: NSException!, mask aMask: Int) -> Bool {
//        let dic = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
//        let path = dic[0] + "/gmlCrash2.txt";
//        let arr = exception.callStackSymbols;//得到当前调用栈信息
//        let reason = exception.reason;//非常重要，就是崩溃的原因
//        let name = exception.name;//异常类型
//        
//        let resultStr = String(format: "exception type : %@ \n crash reason : %@ \n call stack info : %@", name,reason == nil ? "" : reason!,arr);
//        do{
//            try resultStr.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding);
//        }catch{
//            
//        }
//        return false;
//    }
    

    
    deinit{
        NSLog("crash被释放")
    }
}