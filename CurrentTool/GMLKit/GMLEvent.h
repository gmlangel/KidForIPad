//  自定义事件的基类
//  GMLEvent.h
//  MyTalk
//
//  Created by guominglong on 16/5/9.
//  Copyright © 2016年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif (TARGET_OS_MAC && !TARGET_OS_SIMULATOR)
#import <AppKit/AppKit.h>
#elif(TARGET_OS_IOS || (TARGET_OS_MAC && TARGET_OS_SIMULATOR))
#import <UIKit/UIKit.h>
#endif
@interface GMLEvent : NSObject
{
    NSString * _eventType;
    id _data;
    NSObject * _target;
}
/**
 事件类型
 */
@property (readonly) NSString * __nonnull eventType;

/**
 事件携带的数据
 */
@property (readonly) id __nullable data;

/**
 事件的发起者
 */
@property (readonly) NSObject * __nullable target;


-(instancetype __nonnull)initWithEventType:(NSString * __nonnull)_eventType target:(NSObject * __nullable)_tg data:(id __nullable) _da;
@end


@interface GMLProgressEvent:GMLEvent
{
    CGFloat _loadedBytes;
    CGFloat _totalBytes;
}

/**
 已经加载的字节数
 */
@property (readonly) CGFloat loadedBytes;


/**
 总字节数
 */
@property (readonly) CGFloat totalBytes;


-(instancetype __nonnull)initWithBytesState:(NSString * __nonnull)_eventType loadedBytes:(CGFloat)_lb totalBytes:(CGFloat)_tb;
@end
