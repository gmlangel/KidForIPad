//  加载器
//  CTLoader.swift
//  KidForIPad
//
//  Created by guominglong on 16/12/30.
//  Copyright © 2016年 KidForIPad. All rights reserved.
//

import Foundation
class CTLoader: NSObject {
    /**
     记载资源， 自动适配网络资源和本地资源
     */
    func loadFile(_ filePath:String,onComplete:@escaping (Data?)->Void){
        DispatchQueue.global().async {
            var nd = self.loadLocalFile(filePath);//先加载本地资源
            if nd == nil{
                //如果本地资源不存在，则加载网络资源
                nd = self.loadNetFile(filePath);
            }
            DispatchQueue.main.async(execute: {
                onComplete(nd);
            })
        }
    }
    
    /**
     加载本地图片
     */
    private func loadLocalFile(_ filePath:String)->Data?{
        let url = URL(fileURLWithPath: filePath);
        return try? Data(contentsOf: url);
    }
    
    /**
     加载网络图片
     */
    private func loadNetFile(_ filePath:String)->Data?{
        if let url = URL(string: filePath){
            return try? Data(contentsOf:url);
        }
        return nil;
    }

}
