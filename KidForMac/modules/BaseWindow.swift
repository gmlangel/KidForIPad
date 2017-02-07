//  window基础类
//  BaseWindow.swift
//  KidForIPad
//
//  Created by guominglong on 2017/2/6.
//  Copyright © 2017年 KidForMac. All rights reserved.
//

import Foundation

/**
 默认的window窗口样式
 */
let WINDOW_STYLE_MASK_DEFAULT:NSWindowStyleMask = NSWindowStyleMask(rawValue: NSWindowStyleMask.closable.rawValue|NSWindowStyleMask.miniaturizable.rawValue|NSWindowStyleMask.fullSizeContentView.rawValue|NSWindowStyleMask.resizable.rawValue|NSWindowStyleMask.texturedBackground.rawValue)

class BaseWindow:NSWindow,NSWindowDelegate{
    
    /**
     window唯一标识
     */
    open var windowIdentifier:String = "";
    override init(contentRect: NSRect, styleMask style: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: bufferingType, defer: flag);
    }

}
