//
//  KTDebugManager.m
//  DebugBall
//
//  Created by KOTU on 2022/7/13.
//

#import "KTDebugManager.h"
#import "KTDebugView.h"
#import "KTDebugViewMacros.h"
#import "KTDebugBallUtils.h"
#import "KTDebugMenuController.h"

#import <Aspects/Aspects.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "NSURLSessionTask+KTHelp.h"
#import "KTHttpLogModel.h"
#import <YYModel/YYModel.h>

NSNotificationName const kDisplayBorderEnabled              = @"kDisplayBorderEnabled";
NSNotificationName const kDebugBallAutoHidden               = @"kDebugBallAutoHidden";

static NSString * kDomainListKey            = @"kDomainListKey";
static NSString * kH5DomainListKey          = @"kH5DomainListKey";
static NSString * kCurrentDomainKey         = @"kCurrentDomainKey";
static NSString * kCurrentH5DomainKey       = @"kCurrentH5DomainKey";
static NSString * kHasInstalledDebugBall    = @"kHasInstalledDebugBall";

NSString * const kRequestDatasCacheKey = @"com.kotu.debugball.data.RequestDatasCacheKey";

@interface KTDebugManager ()

@property (nonatomic, strong) NSMutableArray *requestDatas;

@property (nonatomic, strong) KTDebugMenuController *menu;
@property (nonatomic, strong) UINavigationController *nav;

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray<__kindof UIView *> *> *cachedRenderingViews;
@property (nonatomic, copy) dispatch_queue_t dataRegistryQueue;


// HTTP
@property (nonatomic, strong) NSArray <id <AspectToken>> *httpHooks;
@property (nonatomic, assign) BOOL isNetworkListening;

@end

@implementation KTDebugManager

+ (instancetype)sharedManager
{
	static dispatch_once_t onceToken;
	static KTDebugManager *manager = nil;
	dispatch_once(&onceToken, ^{
		manager = [KTDebugManager new];
	});
	return manager;
}

static BOOL __show = NO;
static NSMutableDictionary<NSNotificationName,NSDictionary<NSString *,NSString *> *> * __data = nil;

+ (void)presentDebugActionMenuController
{
	if (!__show) {
		UIViewController *vc = DebugSharedManager.nav;
		[[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:vc animated:YES completion:^{
			__show = YES;
		}];
	} else {
		[self dismissDebugActionMenuController];
	}
}

+ (void)dismissDebugActionMenuController
{
	if (__data != nil) {
		for (NSNotificationName name in __data.allKeys) {
			[[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:__data[name]];
		}
		__data = nil;
	}
	[DebugSharedManager.nav dismissViewControllerAnimated:YES completion:^{
		__show = NO;
	}];
}

- (UINavigationController *)nav
{
	if (!_nav) {
		_nav = [[UINavigationController alloc] initWithRootViewController:self.menu];
		_nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		UINavigationBar *bar = _nav.navigationBar;
		[bar setTintColor:[UIColor whiteColor]];
		bar.translucent = NO;
		[bar setBackgroundImage:imageWithColor([UIColor colorWithRed:0 green:120/255.f blue:255/255.f alpha:1]) forBarMetrics:UIBarMetricsDefault];
		bar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
		if (@available(iOS 15.0, *)) {
			UINavigationBarAppearance * appearance = [[UINavigationBarAppearance alloc] init];
			[appearance setBackgroundImage:imageWithColor([UIColor colorWithRed:0 green:120/255.f blue:255/255.f alpha:1])];
			[appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
			bar.standardAppearance = appearance;
			bar.scrollEdgeAppearance = appearance;
		}
	}
	return _nav;
}

- (KTDebugMenuController *)menu
{
	if (!_menu) {
		_menu = [[KTDebugMenuController alloc] init];
		_menu.title = @"Project Configuration";
		_menu.hidesBottomBarWhenPushed = YES;
	}
	return _menu;
}

- (NSMutableDictionary<NSString *,NSMutableArray<UIView *> *> *)cachedRenderingViews
{
	if (!_cachedRenderingViews) {
		_cachedRenderingViews = [NSMutableDictionary dictionary];
	}
	return _cachedRenderingViews;
}

+ (BOOL)isDebugBallAutoHidden
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kDebugBallAutoHidden];
}

+ (BOOL)setDebugBallAutoHidden:(BOOL)enabled
{
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kDebugBallAutoHidden];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation KTDebugManager (DataRegistry)

@end

@implementation KTDebugManager (DebugView)

+ (void)installDebugView
{
	if (![[[NSUserDefaults standardUserDefaults] valueForKey:kHasInstalledDebugBall] boolValue]) {
		[self setDebugBallAutoHidden:YES];
		[[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:kHasInstalledDebugBall];
	}
	
	KTDebugView.debugView.autoHidden([self isDebugBallAutoHidden]).commitTapAction(kKTDebugViewTapActionDisplayActionMenu).show();

	[[NSNotificationCenter defaultCenter] addObserverForName:kDisplayBorderEnabled object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
		@autoreleasepool {
			[DebugSharedManager.cachedRenderingViews enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<__kindof UIView *> * _Nonnull objs, BOOL * _Nonnull stop) {
				[objs enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					dispatch_async(dispatch_get_main_queue(), ^{
						displayBorder(obj, [note.object boolValue], YES);
					});
				}];
			}];
		}
	}];
}

+ (void)uninstallDebugView
{
	dispatch_async(dispatch_get_main_queue(), ^{
		KTDebugView.debugView.dismiss();
	});
}

+ (void)resetDebugBallAutoHidden
{
	KTDebugView.debugView.autoHidden([self isDebugBallAutoHidden]);
	[[NSNotificationCenter defaultCenter] postNotificationName:kDebugBallAutoHidden object:@([self isDebugBallAutoHidden])];
}

@end

@implementation KTDebugManager (Network)

- (void)initNetworkConfig
{
	NSArray *datas = [[NSUserDefaults standardUserDefaults] valueForKey:kRequestDatasCacheKey];
	NSArray *models = [NSArray yy_modelArrayWithClass:[KTHttpLogModel class] json:datas];
	self.requestDatas = [NSMutableArray arrayWithArray:models];
	
	NSMutableArray *array = [NSMutableArray array];
	
	{
		SEL selector = sel_registerName("addDelegateForDataTask:uploadProgress:downloadProgress:completionHandler:");
		//        SEL selector = @selector(addDelegateForDataTask:uploadProgress:downloadProgress:completionHandler:);
		id <AspectToken> token =
		[AFURLSessionManager aspect_hookSelector:selector
									 withOptions:AspectPositionAfter
									  usingBlock:^(id<AspectInfo> aspectInfo, NSURLSessionDataTask *dataTask) {
			if (!self.isNetworkListening) {
				return;
			}
			
			dataTask.kt_requestBeginDate = [NSDate date];
		} error:nil];
		[array addObject:token];
	}
	
	{
		id <AspectToken> token =
		[AFURLSessionManager aspect_hookSelector:@selector(URLSession:dataTask:didReceiveData:)
									 withOptions:AspectPositionAfter
									  usingBlock:^(id<AspectInfo> aspectInfo, NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data) {
			if (!self.isNetworkListening) {
				return;
			}
			
			if (!dataTask.kt_mutableData) {
				dataTask.kt_mutableData = [NSMutableData data];
			}
			[dataTask.kt_mutableData appendData:data];
		} error:nil];
		[array addObject:token];
	}
	
	{
		id <AspectToken> token =
		[AFURLSessionManager aspect_hookSelector:@selector(URLSession:task:didCompleteWithError:)
									 withOptions:AspectPositionAfter
									  usingBlock:^(id<AspectInfo> aspectInfo, NSURLSession *session, NSURLSessionTask *dataTask, NSError *error) {
			if (!self.isNetworkListening) {
				return;
			}
			
			KTHttpLogModel *model = [[KTHttpLogModel alloc] init];
			model.url = [dataTask.currentRequest.URL.absoluteString componentsSeparatedByString:@"?"][0];
			model.type = dataTask.currentRequest.HTTPMethod;
			NSMutableDictionary *params = dictionaryFromUrl(dataTask.currentRequest.URL.absoluteString);
			if (![model.type isEqualToString:@"GET"]) {
				// Post/Put/Delete
				NSDictionary *bodyParams = [NSJSONSerialization JSONObjectWithData:[dataTask.originalRequest HTTPBody]
																	options:NSJSONReadingMutableContainers
																	  error:nil];
				
				[params addEntriesFromDictionary:bodyParams];
			}
			model.request = requestFromDict(params);
			model.header = headerFromDict(params);
			
			if (error) {
				model.response = [error localizedDescription];
			} else {
				NSString *responseStr = [[NSString alloc] initWithData:dataTask.kt_mutableData encoding:NSUTF8StringEncoding];
				model.response = responseStr;
			}
			
			NSDate *startDate = dataTask.kt_requestBeginDate;
			if (startDate) {
				NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
				formatter.dateFormat = @"MM-dd HH:mm:ss";
				model.time = [formatter stringFromDate:startDate];
				model.during = [NSString stringWithFormat:@"%.0fms", ([[NSDate new] timeIntervalSince1970] - [startDate timeIntervalSince1970]) * 1000.0];
			}
		
			[self.requestDatas insertObject:model atIndex:0];
			
			NSArray *datas = [self.requestDatas yy_modelToJSONObject];
			[[NSUserDefaults standardUserDefaults] setValue:datas forKey:kRequestDatasCacheKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:kRequestDataChangeNotification object:nil];
		} error:nil];
		[array addObject:token];
	}
	
	self.httpHooks = [NSArray arrayWithArray:array];
}

- (void)uninitNetworkConfig
{
	for (id <AspectToken> token in self.httpHooks) {
		[token remove];
	}
	self.httpHooks = nil;
}

- (void)startNetworkListening
{
	self.isNetworkListening = YES;
}

- (void)stopNetworkListening
{
	self.isNetworkListening = NO;
}

- (void)clearRequestLogs
{
	[self.requestDatas removeAllObjects];
	[[NSUserDefaults standardUserDefaults] setValue:self.requestDatas forKey:kRequestDatasCacheKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kRequestDataChangeNotification object:nil];
}

- (NSArray *)requests
{
	return self.requestDatas.copy;
}

@end
