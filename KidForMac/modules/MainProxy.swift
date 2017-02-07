//  主业务逻辑入口
//  MainProxy.swift
//  KidForIPad
//
//  Created by guominglong on 2017/2/6.
//  Copyright © 2017年 KidForMac. All rights reserved.
//

import Foundation
class MainProxy: GMLProxy {
    
    private var wcArr:[BaseWindowController] = [BaseWindowController]();
    /**
     单例
     */
    static open var instance:MainProxy{
        get{
            struct MainProxyStruct{
                static public var _ins:MainProxy = MainProxy();
            }
            return MainProxyStruct._ins;
        }
    }
    /**
     创建一个窗口
     */
    func makeWindow(_ id:String,vc:BaseViewController,style:NSWindowStyleMask = WINDOW_STYLE_MASK_DEFAULT) -> BaseWindow{
        let winRect = vc.view.bounds;
        let win = BaseWindow(contentViewController: vc);
        win.styleMask = style;
            //BaseWindow(contentRect: winRect, styleMask: style, backing: NSBackingStoreType.buffered, defer: false);
        win.windowIdentifier = id;
        win.contentView = vc.view;
        win.contentViewController = vc;
        return win;
    }
    
    /**
     创建一个窗口控制器
     */
    func makeWindowController(win:BaseWindow) -> BaseWindowController{
        let wc = BaseWindowController(window: win);
        win.makeKeyAndOrderFront(nil);
        if win.canBecomeMain == true{
            win.makeMain();
        }
        wc.showWindow(win);
        return wc;
    }
    
    /**
     主流程开始
     */
    func start(){
        let vc = BaseViewController();
        vc.view = BaseView(frame: NSRect(x: 0, y: 0, width: 500, height: 500));
        vc.viewDidLoad();
        let win = makeWindow("wook", vc: vc);
        let wc = makeWindowController(win: win);
        wcArr.append(wc);
    }
}
