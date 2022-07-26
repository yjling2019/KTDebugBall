//
//  UIDevice+Hardware.m
//  mobile
//
//  Created by KOTU on 2017/7/26.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "UIDevice+DBHardware.h"
#import <mach/mach.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#define GET_IP_URL_TXT                                              @"http://ipof.in/txt"
#define NULL_STR                                                    @""

NSNotificationName const kUsedMemoryDidChanged = @"kUsedMemoryDidChanged";
NSNotificationName const kAvailableMemoryDidChanged = @"kAvailableMemoryDidChanged";

@implementation UIDevice (DBHardware)

- (double)db_getAvailableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount =HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               
                                               HOST_VM_INFO,
                                               
                                               (host_info_t)&vmStats,
                                               
                                               &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) /1024.0) / 1024.0;
    
}

- (double)db_getUsedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount =TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn =task_info(mach_task_self(),
                                        
                                        TASK_BASIC_INFO,
                                        
                                        (task_info_t)&taskInfo,
                                        
                                        &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
        
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

- (NSString *)db_getOperationSystem
{
    NSString *operationSystem =[[UIDevice currentDevice] systemName];
    return operationSystem;
}

- (NSString *)db_getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion =[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

- (NSString *)db_getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
    }
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    return macAddressString;
}

- (NSString *)db_getIPAddress
{
    NSError *error;
    NSURL *getIpURL = [NSURL URLWithString:GET_IP_URL_TXT];
    NSString *ip = [NSString stringWithContentsOfURL:getIpURL encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        ip = @"Unable To Get";
    }
    return ip;
}

- (NSString *)db_getDeviceType
{
    NSString *deviceType = [[UIDevice currentDevice] model];
    struct utsname systemInfo;
    uname(&systemInfo);
    return deviceType;
}

- (NSString *)db_getDeviceOSVersion
{
    NSString *systemVersion =[[UIDevice currentDevice] systemVersion];
    return systemVersion;
}

- (NSString *)db_getSystemLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

- (NSString *)db_getSystemArea
{
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    return countryCode;
}

- (NSString *)db_getSystemTimeZone
{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    return timeZone.description;
}

- (NSString *)db_getNetworkType
{
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([typeStrings4G containsObject:accessString]) {
            return @"4G";
        } else if ([typeStrings3G containsObject:accessString]) {
            return @"3G";
        } else if ([typeStrings2G containsObject:accessString]) {
            return @"2G";
        } else {
            return @"Null";
        }
    } else {
        return @"Unknow";
    }
}

- (NSString *)db_getWifiMacAddress
{
    NSString *macIp = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        CFRelease(myArray);
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            macIp = [dict valueForKey:@"BSSID"];
        }
    }
    return macIp;
}

- (NSString *)db_deviceIsRoot
{
    return [[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]?@"YES":@"NO";
}

- (NSString *)db_getIDFV
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)db_getIDFA
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

@end
