//
//  KTDebugManager.h
//  DebugBall
//
//  Created by KOTU on 2022/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define DebugSharedManager [KTDebugManager sharedManager]

static NSString * const kRequestDataChangeNotification = @"kRequestDataChangeNotification";

@interface KTDebugManager : NSObject

+ (instancetype)sharedManager;
+ (void)presentDebugActionMenuController;

@end


@interface KTDebugManager (DebugView)

+ (void)installDebugView;

+ (void)uninstallDebugView;

+ (void)resetDebugBallAutoHidden;

@end


@interface KTDebugManager (Network)

@property (nonatomic, strong, readonly) NSArray *requests;

- (void)initNetworkConfig;
- (void)uninitNetworkConfig;
- (void)startNetworkListening;
- (void)stopNetworkListening;

@end

NS_ASSUME_NONNULL_END
