//	一些比较杂的通用功能
//  CTGTool.h
//  AC for mac OS
//
//  Created by guominglong on 15/3/27.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>

#pragma mark MAC addy

static NSString * deviceString;
@interface CTGTool : NSObject

/**
 获得md5加密的32位字符串
 */
//+(NSString *)md5_str32:(NSString *)inputStr;

/**
 获得md5加密的16位字符串
 */
+(NSString *)md5_str32:(NSString *)inputStr;

/**
 获得随机数
 */
+(CGFloat)grandom:(uint32_t)arg1 arg2:(uint32_t)_arg2;

/**
 获取网卡的硬件地址
 */
+(NSString *) macaddress;





/**
 获取外网能看到的IP地址
 */
+(NSString *) whatismyipdotcom;

/**
 获得wifi地址
 */
+(NSString *) localWiFiIPAddress;


/**
 NSString转Address
 */
+ (NSString *) stringFromAddress: (const struct sockaddr *) address;

/**
 Address 转NSString
 */
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;


/**
 获取host的名称
 */
- (NSString *) hostname;


/**
 从host获取地址
 */
- (NSString *) getIPAddressForHost: (NSString *) theHost;


/**
 这是本地host的IP地址
 */
- (NSString *) localIPAddress;

//HmacSHA1加密；
+(NSString *)HmacSha1:(NSString *)key data:(NSString *)data;


//密码加密方式：SHA1
+(NSString *)EncriptPassword_SHA1:(NSString *)password;

+ (void)makeDeviceString;

//获取系统硬件信息
+ (NSString *)createDeviceInfo;
//取系统UUID
+ (NSString *)getUUID;

//获取当前系统OS
+ (NSString *)getOS;

//dic转化为jsonstring
+ (NSString *)convertDicToJsonString:(NSMutableDictionary *)dic;

//nsdate 转化为String
+ (NSString *)convertDateToStringWithFormat:(NSString *)format withDate:(NSDate *)date;

@end
