//  url调起，的委托
//  URLOpenTool.swift
//  51talkAC
//
//  Created by guominglong on 16/9/12.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
class URLOpenTool:GMLProxy{
    var urlData:[String:AnyObject]!;
    
    static var instance:URLOpenTool{
        get{
            struct URLOpenToolStruc{
                static var _ins:URLOpenTool = URLOpenTool();
            }
            return URLOpenToolStruc._ins;
        }
    }
    
    
    
    func start(){
        urlData = [String:AnyObject]();
        let appEventManager = NSAppleEventManager();
        appEventManager.setEventHandler(self, andSelector: #selector(onByURLOpen), forEventClass: UInt32(kInternetEventClass), andEventID: UInt32(kAEGetURL))
    }
    
    /**
     当被URL调起时
     */
    func onByURLOpen(event:NSAppleEventDescriptor,replyEvent:NSAppleEventDescriptor){
        let sourceData = event.data;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            //解析数据
            var args:[String] = [String]();
            let j = sourceData.length;
            var resultdata = NSMutableData();
            var ran = NSRange(location: 0, length: 1);
            var d = 0;
            for i:Int in 0 ..< j{
                ran.location = i;
                sourceData.getBytes(&d, range: ran);
                if(d != 0)
                {
                    resultdata.appendBytes(&d, length: 1);
                }
            }
            let str = String(data: resultdata,encoding: NSASCIIStringEncoding)
            if(str != nil && str!.containsString("://") && str!.containsString("justend"))
            {
                //可以解析出参数来
                var tempnsstring = NSString(string: str!);
                var argrange = tempnsstring.rangeOfString("://");
                var argStr = tempnsstring.substringWithRange(NSRange(location: argrange.location + argrange.length, length: tempnsstring.rangeOfString("justend").location - argrange.location - argrange.length))
                args = argStr.componentsSeparatedByString("&");
                dispatch_async(dispatch_get_main_queue(), {
                    self.execURLArgs(args)
                })
            }
        }
    }
    
    /**
     根据URL吊起时的参数来执行
     */
    func execURLArgs(args:[String])
    {
        if(args.count > 0)
        {
            GPrinter.print("被URL调起，有参数");
            let j = args.count;
            for i:Int in 0 ..< j{
                let str = NSString(string:args[i]);
                if(str.containsString("="))
                {
                    let runag = str.rangeOfString("=");
                    let key = str.substringToIndex(runag.location);
                    let value = str.substringFromIndex(runag.location + 1);
                    urlData[key] = value;
                }else{
                    continue;
                }
            }
        }
        
//        GMLUserDefault.instance.moduleName = nil;
//        GMLUserDefault.instance.courseId = nil;
//        GMLUserDefault.instance.courseTypeId = nil;
//        if(urlData.keys.contains("moduleName"))
//        {
//            GMLUserDefault.instance.moduleName = urlData["moduleName"] as? String;
//        }
//        
//        if(urlData.keys.contains("courseId"))
//        {
//            GMLUserDefault.instance.courseId = urlData["courseId"] as? String;
//        }
//        
//        
//        if(urlData.keys.contains("courseTypeId"))
//        {
//            GMLUserDefault.instance.courseTypeId = urlData["courseTypeId"] as? String;
//        }
//        
//        
//        if(urlData.keys.contains("auth"))
//        {
//            let decodeStr = decodeLoginAuth(urlData["auth"] as! String);
//            if(decodeStr != nil && decodeStr!.containsString("\n"))
//            {
//                let arr = decodeStr!.componentsSeparatedByString("\n");
//            }
//        }
//        
//        if(GMLUserDefault.instance.courseId != nil)
//        {
//            //强行进入教室
//            SDKProxy.instance.forceJoinClassRoom();
//        }
        
    }
    
    func decodeLoginAuth(base64Str:String)->String?{
        var tempstr = NSString(string: base64Str);
        let j = tempstr.length;
        var tttt = "";
        for i:Int in 0 ..< j{
            tttt = tempstr.substringWithRange(NSRange(location: i, length: 1)) + tttt;
        }
        let data = NSData(base64EncodedString: tttt, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters);
        if(data == nil)
        {
            return nil;
        }
        return String(data:data!,encoding:NSUTF8StringEncoding);
    }
    
}

