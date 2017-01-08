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
        NSExceptionHandler.default().setDelegate(self);
        NSExceptionHandler.default().setExceptionHandlingMask(NSHandleUncaughtExceptionMask | NSHandleUncaughtSystemExceptionMask | NSHandleUncaughtRuntimeErrorMask | NSHandleTopLevelExceptionMask | NSHandleOtherExceptionMask);
        
      //  NSExceptionHandler.defaultExceptionHandler().setExceptionHandlingMask(NSLogUncaughtExceptionMask | NSLogUncaughtSystemExceptionMask | NSLogUncaughtRuntimeErrorMask | NSLogTopLevelExceptionMask | NSLogOtherExceptionMask);
    }
    
    
    override func exceptionHandler(_ sender: NSExceptionHandler!, shouldLogException exception: NSException!, mask aMask: Int) -> Bool {
        let dic = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);
        let path = dic[0] + String(format: "/51talkAC-%d.crash",Int(NSDate().timeIntervalSince1970));
        let arr = Thread.callStackSymbols;//得到当前调用栈信息
        let reason = exception.reason;//非常重要，就是崩溃的原因
        let name = exception.name;//异常类型
        let userInfo = exception.userInfo;
        //暂时先不处理某些异常
        if(name == NSExceptionName.genericException || name == NSExceptionName.accessibilityException || name == NSExceptionName.internalInconsistencyException || name == NSExceptionName.portTimeoutException)
        {
            
        }else{
            let bundleInfo = Bundle.main;
            let obj =  ProcessInfo.processInfo.operatingSystemVersion;
            let osInfo = String(format:"os:%d.%d.%d",obj.majorVersion,obj.minorVersion,obj.patchVersion)
            let appBundleId = String(format:"bundleId:%@",bundleInfo.bundleIdentifier!);
            let appVersionStr = String(format:"version:%@(%@)",bundleInfo.infoDictionary!["CFBundleShortVersionString"] as! String,bundleInfo.infoDictionary!["CFBundleVersion"] as! String);
            let resultStr = String(format: "%@\n%@\n%@\nexception type : %@ \n crash reason : %@ \n call stack info : %@ \n userinfo:%@",osInfo,appBundleId,appVersionStr, name as CVarArg,reason == nil ? "" : reason!,arr,userInfo == nil ? "" : userInfo!);
            do{
                try resultStr.write(toFile: path, atomically: true, encoding: String.Encoding.utf8);
            }catch{
                
            }
            
            NSLog("程序发生崩溃，崩溃类型:\(name),app关闭");
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
