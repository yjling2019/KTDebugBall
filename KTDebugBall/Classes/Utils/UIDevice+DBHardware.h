//
//  UIDevice+Hardware.h
//  mobile
//
//  Created by KOTU on 2017/7/26.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSNotificationName const kUsedMemoryDidChanged;
FOUNDATION_EXPORT NSNotificationName const kAvailableMemoryDidChanged;

@interface UIDevice (DBHardware)
- (double)db_getAvailableMemory;
- (double)db_getUsedMemory;
-(NSString *)db_getOperationSystem;
-(NSString *)db_getAppVersion;
-(NSString *)db_getMacAddress;
-(NSString *)db_getIPAddress;
-(NSString *)db_getDeviceType;
-(NSString *)db_getDeviceOSVersion;
-(NSString *)db_getSystemLanguage;
-(NSString *)db_getSystemArea;
-(NSString *)db_getSystemTimeZone;
-(NSString *)db_getNetworkType;
-(NSString *)db_getWifiMacAddress;
-(NSString *)db_deviceIsRoot;
-(NSString *)db_getIDFV;
-(NSString *)db_getIDFA;
@end
