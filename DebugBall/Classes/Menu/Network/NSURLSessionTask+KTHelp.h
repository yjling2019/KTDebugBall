//
//  NSURLSessionTask+VVHelp.h
//  Pods
//
//  Created by KOTU on 2020/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionTask (KTHelp)

@property (nonatomic, strong) NSDate *kt_requestBeginDate;
@property (nonatomic, strong) NSMutableData *kt_mutableData;

@end

NS_ASSUME_NONNULL_END
