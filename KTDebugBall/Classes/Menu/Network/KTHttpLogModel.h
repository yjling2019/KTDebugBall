//
//  KTHttpLogModel.h
//
//  Created by KOTU on 2019/2/12.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTHttpLogModel : NSObject

@property NSString *url;
@property NSString *type;
@property NSString *header;
@property NSString *http_header;
@property NSString *request;
@property NSString *statusCode;
@property NSString *response;
@property NSString *time;
@property NSString *during;
@property NSString *create_time;

@property BOOL spread;
@property CGFloat textHeight;

@property NSString *business_error;

@property (nonatomic, copy) NSString * curlString;

- (void)setUpCurlStringWithRequest:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END


