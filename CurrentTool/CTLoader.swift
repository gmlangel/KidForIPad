//  加载器
//  CTLoader.swift
//  KidForIPad
//
//  Created by guominglong on 16/12/30.
//  Copyright © 2016年 KidForIPad. All rights reserved.
//

import Foundation
class CTLoader: NSObject {
    func loadFile(file:String,onComplete:(NSData?)->Void){
        if let url = NSURL(string: file){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                let nd = NSData(contentsOfURL: url);
                dispatch_async(dispatch_get_main_queue(), {
                    onComplete(nd);
                })
            }
        }
    }

}