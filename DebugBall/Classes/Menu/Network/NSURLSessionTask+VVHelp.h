//
//  NSURLSessionTask+VVHelp.h
//  Pods
//
//  Created by yjling on 2020/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionTask (VVHelp)

@property (strong, nonatomic) NSDate *vv_requestBeginDate;

@end

NS_ASSUME_NONNULL_END
