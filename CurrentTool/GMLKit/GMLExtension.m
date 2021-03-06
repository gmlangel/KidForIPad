//
//  GMLExtension.m
//  51talkAC
//
//  Created by guominglong on 16/6/21.
//  Copyright © 2016年 guominglong. All rights reserved.
//

#import "GMLExtension.h"
#import "GMLCoreDispatcher.h"
#import "GMLEvent.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@implementation UIResponder (GMLKitExtension)
#elif (TARGET_OS_MAC && !TARGET_OS_SIMULATOR)
#import <AppKit/AppKit.h>
@implementation NSResponder (GMLKitExtension)
#elif(TARGET_OS_IOS || (TARGET_OS_MAC && TARGET_OS_SIMULATOR))
#import <UIKit/UIKit.h>
@implementation UIResponder (GMLKitExtension)
#endif

-(GMLCoreDispatcher * __nullable)gml_delegate{
    return nil;
}

-(void)addEventListener:(NSString * __nonnull)eventName execFunc:(void(^ __nullable)(GMLEvent * __nonnull e))_execFunc{
    if([self gml_delegate])
    {
        [[self gml_delegate] addEventListener:eventName execFunc:_execFunc];
    }
}

-(void)removeEventListener:(NSString * __nonnull)eventName{
    if ([self gml_delegate]) {
        [[self gml_delegate] removeEventListener:eventName];
    }
}

-(void)removeAllEventListener{
    if([self gml_delegate])
    {
        [[self gml_delegate] removeAllEventListener];
    }
}

-(void)dispatchEvent:(GMLEvent * __nonnull)e{
    if([self gml_delegate])
    {
        [[self gml_delegate] dispatchEvent:e];
    }
}



@end
