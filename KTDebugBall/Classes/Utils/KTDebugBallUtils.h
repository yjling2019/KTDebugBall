//
//  KTDebugBallUtils.h
//  Pods
//
//  Created by KOTU on 2017/8/24.
//
//

#ifndef KTDebugBallUtils_h
#define KTDebugBallUtils_h

#import <UIKit/UIKit.h>

#define kDebugBallRequestHeaderKeys @[@"uuid", @"uid", @"access_token", @"country_code", @"currency", @"s", @"idfa", @"organic_idfv", @"req_time", @"sign", @"timezone"];

static inline NSBundle *DebugBallBundle(void) {
	NSString *podName = @"KTDebugBall";
	
	NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(podName)];
	NSURL * url = [bundle URLForResource:podName withExtension:@"bundle"];
	if (!url) {
		NSArray *frameWorks = [NSBundle allFrameworks];
		for (NSBundle *tempBundle in frameWorks) {
			url = [tempBundle URLForResource:podName withExtension:@"bundle"];
			if (url) {
				bundle =[NSBundle bundleWithURL:url];
				if (!bundle.loaded) {
					[bundle load];
				}
				return bundle;
			}
		}
	} else {
		bundle =[NSBundle bundleWithURL:url];
		return bundle;
	}
	
    return bundle;
}

static inline NSString * DebugBallPathForResource(NSString *name, NSString *ext) {
    return [DebugBallBundle() pathForResource:name ofType:ext];
}

static inline UIImage * DebugBallImageWithNamed(NSString *name){
    return [UIImage imageNamed:name inBundle:DebugBallBundle() compatibleWithTraitCollection:nil];
}

static inline void displayBorder (UIView *view, BOOL display, BOOL recursion) {
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

static inline NSMutableDictionary * dictionaryFromUrl(NSString *url) {
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

static inline NSString * headerFromDict(NSDictionary *dict) {
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

static inline NSString * requestFromDict(NSDictionary *dict) {
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

static inline UIImage * imageWithColor(UIColor *color) {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

#endif /* KTDebugBallUtils_h */
