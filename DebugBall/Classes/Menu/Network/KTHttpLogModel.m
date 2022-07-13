//
//  KTHttpLogModel.m
//
//  Created by KOTU on 2019/2/12.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "KTHttpLogModel.h"

@implementation KTHttpLogModel

- (void)setUpCurlStringWithRequest:(NSURLRequest *)request
{
	NSMutableArray *components = @[@"curl "].mutableCopy;

	NSURL *URL = request.URL;
	NSString *host = URL.host;
	if (!URL || !host) {
		self.curlString = @"curl command could not be created";
		return;
	}

	NSString *HTTPMethod = request.HTTPMethod;
	if (HTTPMethod.length > 0 && ![HTTPMethod isEqualToString:@"GET"]) {
		[components addObject:[NSString stringWithFormat:@"-X %@",HTTPMethod]];
	}

//	NSURLSession *session = [KTNetworkAgent sharedAgent].sessionManager.session;
//	NSURLCredentialStorage *credentialStorage = session.configuration.URLCredentialStorage;
//	NSURLProtectionSpace *protectionSpace = [NSURLProtectionSpace.alloc initWithHost:host port:URL.port.integerValue protocol:URL.scheme realm:host authenticationMethod:NSURLAuthenticationMethodHTTPBasic];

//	NSArray <NSURLCredential *>*credentials = [credentialStorage credentialsForProtectionSpace:protectionSpace].allValues;
//	for (NSURLCredential *credential in credentials) {
//		if (credential.user.length > 0 && credential.password.length > 0) {
//			NSString *str = [NSString stringWithFormat:@"-u %@:%@",credential.user, credential.password];
//			[components addObject:str];
//		}
//	}

//	if (session.configuration.HTTPShouldSetCookies) {
//		NSHTTPCookieStorage *cookieStorage = session.configuration.HTTPCookieStorage;
//		NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:URL];
//		if (cookies.count > 0) {
//			NSMutableString *cookieString = NSMutableString.string;
//			for (NSHTTPCookie *cookie in cookies) {
//				[cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
//			}
//			if (cookieString.length > 0) {
//				NSString *str = [NSString stringWithFormat:@"-b \"%@\"",cookieString];
//				[components addObject:str];
//			}
//		}
//	}

	NSMutableDictionary *headers = NSMutableDictionary.dictionary;
//	NSDictionary *additionalHeaders = session.configuration.HTTPAdditionalHeaders;
	NSDictionary *headerFields = request.allHTTPHeaderFields;
//	[headers addEntriesFromDictionary:additionalHeaders];
	[headers addEntriesFromDictionary:headerFields];
	[headers removeObjectForKey:@"Cookie"];

	for (NSString *key in headers.allKeys) {
		if (![key isKindOfClass:[NSString class]] || key.length == 0) {
			continue;
		}
		
		NSString *value = headers[key];
		if (![value isKindOfClass:[NSString class]] || value.length == 0) {
			continue;
		}
		
		NSString *str = [NSString stringWithFormat:@"-H \"%@:%@\"",key, headers[key]];
		[components addObject:str];
	}

	NSData *HTTPBodyData = request.HTTPBody;
	NSString *HTTPBody = [[NSString alloc] initWithData:HTTPBodyData encoding:NSUTF8StringEncoding];
	if (HTTPBody) {
		NSString *escapedBody = [HTTPBody stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\\\\\""];
		escapedBody = [escapedBody stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
		NSString *str = [NSString stringWithFormat:@"-d \"%@\"",escapedBody];
		if (escapedBody.length > 0) {
			[components addObject:str];
		}
	}

	if (URL.absoluteString.length > 0) {
		NSString *str = [NSString stringWithFormat:@"--compressed \"%@\"",URL.absoluteString];
		[components addObject:str];
	}

	NSString *command = [components componentsJoinedByString:@" \\\n\t"];
	
    self.curlString = command;
}

@end
