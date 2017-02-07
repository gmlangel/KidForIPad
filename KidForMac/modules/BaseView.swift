//  view基础类
//  BaseView.swift
//  KidForIPad
//
//  Created by guominglong on 2017/2/6.
//  Copyright © 2017年 KidForMac. All rights reserved.
//

import Foundation
class BaseView: NSView,GMLViewProtocal {
    
    //MARK:GMLCoreDispatcher相关扩展
    private var gmlCoreDis:GMLCoreDispatcher? = nil;
    override func gml_delegate() -> GMLCoreDispatcher? {
        if gmlCoreDis == nil{
            gmlCoreDis = GMLCoreDispatcher();
        }
        return gmlCoreDis;
    }
    
    //MARK:GMLViewProtocal协议的实现
    /**
     初始化页面所需的所有UI控件
     */
    func gml_initialUI() {
        
    }
    
    /**
     将界面还原为初始状态
     */
    func gml_resetState() {
        
    }
    
    /**
     填充数据
     @param userInfo 用户自定义数据
     */
    func gml_fillUserInfo(_ userInfo: [AnyHashable : Any]? = nil) {
        
    }
    
    /**
     屏幕自适应
     */
    func gml_resize(_ w: CGFloat, height h: CGFloat) {
        
    }
    
    /**
     添加事件
     */
    func gml_addEvents() {
        
    }
    
    /**
     移除所有事件,尽量不要在这个函数中调用removeAllEventListener，因为有一些监听是类的外部添加的。避免错删
     */
    func gml_removeEvents() {
        
    }
    
    /**
     清空所有与自己有关的引用，等待ARC。
     必须做的事
     @param 1.调用gml_removeEvents
     @param 2.调用removeAllEventlistener
     @param 3.制空已知的delegate为nil
     @param 4.移除所有子视图
     */
    func gml_destroy() {
        
    }
}
