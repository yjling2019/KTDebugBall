//
//  ConsoleHttpModel.m
//  Vova
//
//  Created by Meade on 2019/2/12.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "ConsoleHttpModel.h"

@implementation ConsoleHttpModel

- (void)setUpCurlStringWithRequest:(NSURLRequest *)request
{
    __block NSMutableString *displayString = [NSMutableString stringWithFormat:@"curl -X %@", request.HTTPMethod];
    
    [displayString appendFormat:@" --compressed \'%@\'",  request.URL.absoluteString];
    
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
        [displayString appendFormat:@" -H \'%@: %@\'", key, val];
    }];
    
    if ([request.HTTPMethod isEqualToString:@"POST"] ||
        [request.HTTPMethod isEqualToString:@"PUT"] ||
        [request.HTTPMethod isEqualToString:@"PATCH"]) {
        
        [displayString appendFormat:@" -d \'%@\'",
         [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
    }
    
    self.curlString = [displayString copy];
}

@end
