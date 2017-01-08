//
//  CTGTool.m
//  AC for mac OS
//
//  Created by guominglong on 15/3/27.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

#import "CTGTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
@implementation CTGTool

+(CGFloat)grandom:(uint32_t)arg1 arg2:(uint32_t)_arg2
{
    return (CGFloat)(arc4random_uniform(arg1)/(CGFloat)_arg2);
}

//+(NSString *)md5_str32:(NSString *)inputStr
//{
//    const char* str = [inputStr UTF8String];
//    unsigned char result[32];
//    CC_MD5(str, strlen(str), result);
//    NSMutableString *ret = [NSMutableString stringWithCapacity:32];//
//    
//    for(int i = 0; i<32; i++) {
//        [ret appendFormat:@"%02x",result[i]];
//    }
//    return ret;
//}

+(NSString *)md5_str32:(NSString *)inputStr
{
    const char* str = [inputStr UTF8String];
    unsigned char result[16];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:16];//
    
    for(int i = 0; i<16; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
/**
 获取网卡的硬件地址
 */
+(NSString *) macaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}





/**
 获取外网能看到的IP地址
 */
+(NSString *) whatismyipdotcom
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"https://www.whatismyip.com/automation/n09230945.asp"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
    return ip ? ip : [error localizedDescription];
}

/**
 获得wifi地址
 */
+(NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}


/**
 NSString转Address
 */
+ (NSString *) stringFromAddress: (const struct sockaddr *) address
{
    if(address && address->sa_family == AF_INET) {
        const struct sockaddr_in* sin = (struct sockaddr_in*) address;
        return [NSString stringWithFormat:@"%@:%d", [NSString stringWithUTF8String:inet_ntoa(sin->sin_addr)], ntohs(sin->sin_port)];
    }
    
    return nil;
}

/**
 Address 转NSString
 */
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
    if (!IPAddress || ![IPAddress length]) {
        return NO;
    }
    
    memset((char *) address, sizeof(struct sockaddr_in), 0);
    address->sin_family = AF_INET;
    address->sin_len = sizeof(struct sockaddr_in);
    
    int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
    if (conversionResult == 0) {
        NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
        return NO;
    }
    
    return YES;
}


/**
 获取host的名称
 */
- (NSString *) hostname
{
    char baseHostName[256]; // Thanks, Gunnar Larisch
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '\0';
    
#if TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s", baseHostName];
#else
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}


/**
 从host获取地址
 */
- (NSString *) getIPAddressForHost: (NSString *) theHost
{
    struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
    return addressString;
}


/**
 这是本地host的IP地址
 */
- (NSString *) localIPAddress
{
    struct hostent *host = gethostbyname([[self hostname] UTF8String]);
    if (!host) {herror("resolv"); return nil;}
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}

//HmacSHA1加密；
+(NSString *)HmacSha1:(NSString *)key data:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];//将加密结果进行一次BASE64编码。
    return hash;
}

//密码加密方式：SHA1
+(NSString *)EncriptPassword_SHA1:(NSString *)password{
    const char *cstr = [password cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:password.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result uppercaseString];
}

+ (void)makeDeviceString
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/sbin/ioreg"];
    
    //ioreg -rd1 -c IOPlatformExpertDevice | grep -E '(UUID)'
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"-rd1", @"-c",@"IOPlatformExpertDevice",nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    deviceString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
}

+ (NSString *)createDeviceInfo
{
    if(deviceString == nil)
    {
        [CTGTool makeDeviceString];
    }
    return deviceString;
}

+ (NSString *)getUUID
{
    if(deviceString == nil)
    {
        [CTGTool makeDeviceString];
    }
    //NSLog (@"grep returned:n%@", string);
    
    NSString *key = @"IOPlatformUUID";
    
    if([deviceString containsString:key])
    {
        NSRange range = [deviceString rangeOfString:key];
        NSInteger location = range.location + [key length] + 5;
        NSInteger length = 32 + 4;
        range.location = location;
        range.length = length;
        if(range.length + range.location <= deviceString.length)
        {
            
            return [deviceString substringWithRange:range];
        }else{
            return @"meiyouUUID";
        }
    }else{
        return @"meiyouUUID";
    }
}

+ (NSString *)getOS{
    if(deviceString == nil)
    {
        [CTGTool makeDeviceString];
    }
    NSString *key = @"IOPlatformExpertDevice";
    if([deviceString containsString:key])
    {
        NSRange range = [deviceString rangeOfString:key];
        NSInteger location = range.location + [key length] + 7;
        NSInteger length = 18;
        range.location = location;
        range.length = length;
        if(range.length + range.location <= deviceString.length)
        {
            NSString *os = [deviceString substringWithRange:range];
            os = [os substringToIndex:[os rangeOfString:@","].location];
            int osInt = [os intValue];
            os = [NSString stringWithFormat:@"%d.%d.%d",(int)(osInt / 10000000),(int)((osInt % 10000000) / 10),(int)((osInt % 10000000) % 10)];
            return os;
        }else{
            return @"0.0.0";
        }
    }else{
        return @"0.0.0";
    }
    
}

//dic转化为jsonstring
+ (NSString *)convertDicToJsonString:(NSMutableDictionary *)dic
{
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    if (jsondata.length > 0) {
        NSString *jsonstr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        return jsonstr;
    }
 
    return @"";
}

//nsdate 转化为String
+ (NSString *)convertDateToStringWithFormat:(NSString *)format withDate:(NSDate *)date
{
    NSString *dateString = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    if ([dateFormatter stringFromDate:date].length>0) {
        dateString = [dateFormatter stringFromDate:date];
    }
    return dateString;
}
@end
