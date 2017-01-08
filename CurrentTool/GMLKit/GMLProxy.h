//  GMLKit处理各种事物的委托基类
//  GMLProxy.h
//  MyTalk
//
//  Created by guominglong on 16/5/10.
//  Copyright © 2016年 guominglong. All rights reserved.
//

#import "GMLExtension.h"
#import "GMLCoreDispatcher.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@interface GMLProxy : UIResponder
{
    GMLCoreDispatcher * _gmlDis;
}
#elif (TARGET_OS_MAC && !TARGET_OS_SIMULATOR)
#import <AppKit/AppKit.h>
@interface GMLProxy : NSResponder
{
    GMLCoreDispatcher * _gmlDis;
}
#elif(TARGET_OS_IOS || (TARGET_OS_MAC && TARGET_OS_SIMULATOR))
#import <UIKit/UIKit.h>
@interface GMLProxy : UIResponder
{
    GMLCoreDispatcher * _gmlDis;
}
#endif



/**
 销毁，等待ARC。
 必须做的事
 1.调用removeAllEventlistener(这部分已经由GMLProxy类处理了)
 */
-(void)gml_destroy;


/**
 执行一个没有返回值得同步或者异步函数
 */
-(void)execFun:(SEL __nonnull)exeSel arg:(id __nullable)_arg;

/**
 执行一个有返回值的函数
 */
-(id __nullable)execHasCallbackFun:(NSString * __nonnull)funcName arg:(id __nullable)_arg;
@end







