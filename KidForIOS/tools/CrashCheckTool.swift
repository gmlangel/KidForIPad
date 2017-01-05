//  ios崩溃捕获工具
//  CrashCheckTool.swift
//  CrashDemo
//
//  Created by Choi on 16/12/29.
//  Copyright © 2016年 51Talk. All rights reserved.
//

import UIKit

class CrashCheckTool: NSObject {

    /**
    单例
    */
   static let instance: CrashCheckTool = CrashCheckTool()
    //Crash处理函数
    let exceptionHandler:@convention(c) (value:Int32)->Void={(value) in
        //上传阿里云崩溃数量报告
        RunningDataUploadProxy.instance.sendAliyunCrashLog(CrashEntity(isPull: 0))
        CustomTool.saveISCrash(true)
        let stackSymbols = NSThread.callStackSymbols()
        
        AppRunLogTool.collectCrashLog(stackSymbols)
        
        CustomTool.localNoticefication()

        NSThread.sleepForTimeInterval(0.5);
        exit(0);
    }
   
    //捕获异常信号量
     func start() {
        
        self.setExceptionHanler()

        //以下的操作用来捕获swift发生的crash
        signal(SIGABRT, exceptionHandler);
        signal(SIGFPE, exceptionHandler);
        signal(SIGILL, exceptionHandler);
        signal(SIGINT, exceptionHandler);
        signal(SIGSEGV, exceptionHandler);
        signal(SIGTRAP, exceptionHandler);
        signal(SIGTERM, exceptionHandler);

    }
    
    //捕捉oc的Crash和swift数组越界
    private func setExceptionHanler() {

        NSSetUncaughtExceptionHandler {  ex in
            
            AppRunLogTool.collectCrashLog(ex.callStackSymbols, reason: ex.reason)

        }

    }
    
    

}
