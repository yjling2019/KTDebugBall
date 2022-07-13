//
//  NSURLSessionTask+VVHelp.m
//  Pods
//
//  Created by yjling on 2020/6/10.
//

#import "NSURLSessionTask+VVHelp.h"
#import <objc/runtime.h>

static char kVVRequestBeginDate;

@implementation NSURLSessionTask (VVHelp)

- (void)setVv_requestBeginDate:(NSDate *)vv_requestBeginDate
{
	objc_setAssociatedObject(self, &kVVRequestBeginDate, vv_requestBeginDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)vv_requestBeginDate
{
    return objc_getAssociatedObject(self, &kVVRequestBeginDate);
}

@end
