//  有道翻译工具
//  CTYouDaoTranslateTool.swift
//  51talkAC
//
//  Created by guominglong on 16/7/1.
//  Copyright © 2016年 guominglong. All rights reserved.
//

import Foundation
enum TranslateType:Int{
    case Term_ZhToEn = 0  /*词语翻译 汉译英*/
    case Term_EnToZh = 1  /*词语翻译 英译汉*/
    case Sentence = 2 /*句子翻译*/
    case TranslateErr = 3 /*翻译失败*/
}


class TranslateEntity:NSObject{
    
    /*
    翻译前的文本
    */
    var beforeText:NSMutableAttributedString!;
    
    /*
    翻译后的文本
    */
    var afterText:NSMutableAttributedString!;
    
    var type:TranslateType!;
}

class CTYouDaoTranslateTool:GMLProxy {
    
    private var urlstr:String!;
    private var completeFunc:((TranslateEntity)->Void)?;//完成请求后的回调
    var isTranslating:Bool = false;
    override init() {
        super.init();
        urlstr = "fanyi.youdao.com/openapi.do?keyfrom=51talk&key=1566149960&type=data&doctype=json&version=1.1&q=%@";
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func translateStr(str:String,_completeFunc:((TranslateEntity)->Void))
    {
        if(isTranslating)
        {
            return;
        }
        isTranslating = true;
        completeFunc = _completeFunc;
        let url = NSURL(string: String(format: urlstr, str).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!);
        let uq = NSMutableURLRequest(URL: url!);
        uq.HTTPMethod = "POST";
        NSURLConnection.sendAsynchronousRequest(uq, queue: NSOperationQueue.mainQueue(), completionHandler: onfanyiCallBack);
    }
    
    private func onfanyiCallBack(urlresp:NSURLResponse?,nd:NSData?,ne:NSError?) ->Void
    {
        //解析JSON。
        if(ne == nil)
        {
            if(nd == nil)
            {
                showError("translateAbout_1");
                return;
            }
            
            do{
                let resultData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(nd!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary;
                
                fenxiJSON(resultData);
            }catch{
                showError("translateAbout_1");
            }
            
        }else{
            isTranslating = false;
        }
    }
    
    private func fenxiJSON(dic:NSDictionary)
    {
        let resultCode:Int = dic.valueForKey("errorCode") as! Int;
        switch(resultCode)
        {
        case 0:
            checkType(dic);
            break;
        case 20:
            showError("translateAbout_0");
            break;
        case 30:
            showError("translateAbout_1");
            break;
        case 40:
            showError("translateAbout_2");
            break;
        case 50:
            showError("translateAbout_3");
            break;
        case 60:
            showError("translateAbout_1");
            break;
        default:
            isTranslating = false;
            break;
        }
        
    }
    
    private func showError(str:String)
    {
        
        let enti = TranslateEntity()
        enti.type = .TranslateErr;
        enti.beforeText = NSMutableAttributedString(string: LanguageManager.instance().getLanguageStr(str));
        enti.afterText = NSMutableAttributedString(string: "");
        completeFunc!(enti);
        completeFunc = nil;
        isTranslating = false;
    }
    
    private func checkType(dic:NSDictionary)
    {
        var dataBase = dic as! [String:AnyObject];
        let enti = TranslateEntity();
        if(dataBase.keys.contains("basic"))
        {
            let data = dataBase["basic"] as! [String:AnyObject];
            //词语翻译
            if(data.keys.contains("uk-phonetic"))
            {
                enti.type = TranslateType.Term_EnToZh;
                //英译汉
                enti.beforeText = NSMutableAttributedString(string: "\(dataBase["query"] as! String)\t[\(data["uk-phonetic"] as! String)]");
            }else
            {
                enti.type = TranslateType.Term_ZhToEn;
                //汉译英
                enti.beforeText = NSMutableAttributedString(string: dataBase["query"] as! String);
                if(data.keys.contains("phonetic"))
                {
                    enti.beforeText.appendAttributedString(NSAttributedString(string: "\t[\(data["phonetic"] as! String)]"));
                }
            }
            
            enti.afterText = NSMutableAttributedString(string:"");
            if(data.keys.contains("explains"))
            {
                let arr = data["explains"] as! [String];
                let j = arr.count
                for i:Int in 0 ..< j
                {
                    enti.afterText.appendAttributedString(NSAttributedString(string: arr[i] + "\n"));
                }
                enti.afterText.deleteCharactersInRange(NSRange(location: enti.afterText.length - 1, length: 1));
            }else
            {
                enti.afterText.appendAttributedString(NSAttributedString(string: (data["translation"] as! String)));
            }
            //enti.afterText.appendAttributedString(weizhui);
        }else
        {
            enti.type = TranslateType.Sentence;
            //语句翻译
            enti.beforeText = NSMutableAttributedString(string: dataBase["query"] as! String);
            if((dataBase["errorCode"] as! Int) == 0)
            {
                //如果没发生错误
                enti.afterText = NSMutableAttributedString(string: (dataBase["translation"] as! [String])[0]);
            }else{
                enti.afterText = NSMutableAttributedString(string:"");
            }
            //enti.afterText.appendAttributedString(weizhui);
        }
        
        completeFunc!(enti);
        completeFunc = nil;
        isTranslating = false;
    }

}