//
//  NSURLSessionTask+KTHelp.m
//  Pods
//
//  Created by KOTU on 2020/6/10.
//

#import "NSURLSessionTask+KTHelp.h"
#import <objc/runtime.h>

static char kKTMutableData;
static char kKTRequestBeignDate;

@implementation NSURLSessionTask (KTHelp)

- (void)setKt_mutableData:(NSMutableData *)kt_mutableData
{
	objc_setAssociatedObject(self, &kKTMutableData, kt_mutableData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableData *)kt_mutableData
{
	return objc_getAssociatedObject(self, &kKTMutableData);
}

- (void)setKt_requestBeginDate:(NSDate *)kt_requestBeginDate
{
	objc_setAssociatedObject(self, &kKTRequestBeignDate, kt_requestBeginDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)kt_requestBeginDate
{
    return objc_getAssociatedObject(self, &kKTRequestBeignDate);
}

@end
