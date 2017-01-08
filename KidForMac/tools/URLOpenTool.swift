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
    @objc func onByURLOpen(event:NSAppleEventDescriptor,replyEvent:NSAppleEventDescriptor){
        let sourceData = event.data;
        DispatchQueue.global().async {
            //解析数据
            var args:[String] = [String]();
            let j = sourceData.count;
            let resultdata = NSMutableData();
            let byte:UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: 1);
            for i:Int in 0 ..< j{
                let ran = Range(uncheckedBounds: (lower: i, upper: i + 1));
                sourceData.copyBytes(to: byte, from: ran);
                if(UInt8(byte[0]) != 0)
                {
                    resultdata.append(byte, length: 1);
                }
            }
            let str = String(data: resultdata as Data,encoding: String.Encoding.ascii)
            if(str != nil && str!.contains("://") && str!.contains("justend"))
            {
                //可以解析出参数来
                let tempnsstring = NSString(string: str!);
                let argrange = tempnsstring.range(of: "://");
                let argStr = tempnsstring.substring(with: NSRange(location: argrange.location + argrange.length, length: tempnsstring.range(of: "justend").location - argrange.location - argrange.length))
                args = argStr.components(separatedBy: "&");
                
                DispatchQueue.global().async {
                    self.execURLArgs(args: args)
                }
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
            Swift.print("被URL调起，有参数");
            let j = args.count;
            for i:Int in 0 ..< j{
                let str = NSString(string:args[i]);
                if(str.contains("="))
                {
                    let runag = str.range(of: "=");
                    let key = str.substring(to: runag.location);
                    let value = str.substring(from: runag.location + 1);
                    urlData[key] = value as AnyObject?;
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
        let tempstr = NSString(string: base64Str);
        let j = tempstr.length;
        var tttt = "";
        for i:Int in 0 ..< j{
            tttt = tempstr.substring(with: NSRange(location: i, length: 1)) + tttt;
        }
        let data = NSData(base64Encoded: tttt, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters);
        if(data == nil)
        {
            return nil;
        }
        return String(data:data! as Data,encoding:String.Encoding.utf8);
    }
    
}

