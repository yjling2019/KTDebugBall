//
//  KTDBUtils.h
//  Pods
//
//  Created by KOTU on 2017/8/24.
//
//

#ifndef KTDBUtils_h
#define KTDBUtils_h

#import <UIKit/UIKit.h>

#define kDebugBallRequestHeaderKeys @[@"uuid", @"uid", @"access_token", @"country_code", @"currency", @"s", @"idfa", @"organic_idfv", @"req_time", @"sign", @"timezone"];


NSBundle *DebugBallBundle(void) {
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"DebugView")];
    NSURL *bundleURL = [bundle URLForResource:@"DebugBall" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:bundleURL];
}

NSString * DebugBallPathForResource(NSString *name, NSString *ext) {
    return [DebugBallBundle() pathForResource:name ofType:ext];
}

UIImage * DebugBallImageWithNamed(NSString *name){
    return [UIImage imageNamed:name inBundle:DebugBallBundle() compatibleWithTraitCollection:nil];
}

void displayBorder (UIView *view, BOOL display, BOOL recursion) {
    if (![view isKindOfClass:UIView.class]) {
        return;
    }
    if (recursion) {
        if (view.superview) {
            displayBorder(view.superview, display, recursion);
        } else {
            displayBorder(view, display, !recursion);
        }
    } else {
        CALayer *layer = view.layer;
        if ([layer isMemberOfClass:CALayer.class]) {
            layer.borderColor = display?[UIColor redColor].CGColor:[UIColor clearColor].CGColor;
            layer.borderWidth = display?1/[UIScreen mainScreen].scale:0;
        }
        if (layer.animationKeys.count>0) {
            return;
        }
        if (view.subviews.count>0) {
            @autoreleasepool {
                [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    displayBorder(obj, display, recursion);
                }];
            }
        }
    }
}

NSMutableDictionary * dictionaryFromUrl(NSString *url) {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSArray *array = [url componentsSeparatedByString:@"?"];
	NSString *keyValueStr = array.count > 1 ? array[1] : url;
	NSArray *keyValues = [keyValueStr componentsSeparatedByString:@"&"];
	if(keyValues.count > 1) {
		for(int i = 0; i < keyValues.count; i++) {
			NSArray *keyAndValue = [keyValues[i] componentsSeparatedByString:@"="];
			if(keyAndValue.count > 1 && keyAndValue[0] && keyAndValue[1]) {
				[dict setObject:keyAndValue[1] forKey:keyAndValue[0]];
			}
		}
	}
	return dict;
}

NSString * headerFromDict(NSDictionary *dict) {
	NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
	
	NSArray *headerKeys = kDebugBallRequestHeaderKeys;
	for (id key in dict) {
		if([headerKeys containsObject:key]) {
			[headerDict setObject:[dict objectForKey:key] forKey:key];
		}
	}
	
	if (!headerDict) {
		return @"{}";
	}
	NSError *parseError = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:headerDict options:NSJSONWritingPrettyPrinted error:&parseError];
	return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

NSString * requestFromDict(NSDictionary *dict) {
	NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
	
	NSArray *headerKeys = kDebugBallRequestHeaderKeys;
	for (id key in dict) {
		if (![headerKeys containsObject:key]) {
			[requestDict setObject:[dict objectForKey:key] forKey:key];
		}
	}
	
	if (!requestDict) {
		return @"{}";
	}
	NSError *parseError = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:&parseError];
	return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#endif /* KTDBUtils_h */
