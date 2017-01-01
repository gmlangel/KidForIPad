//  加载器
//  CTLoader.swift
//  KidForIPad
//
//  Created by guominglong on 16/12/30.
//  Copyright © 2016年 KidForIPad. All rights reserved.
//

import Foundation
class CTLoader: NSObject {
    func loadFile(_ file:String,onComplete:@escaping (Data?)->Void){
        if let url = URL(string: file){
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
                let nd = try? Data(contentsOf: url);
                DispatchQueue.main.async(execute: {
                    onComplete(nd);
                })
            }
        }
    }

}
