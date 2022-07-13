//
//  KTDebugManager.h
//  DebugBall
//
//  Created by KOTU on 2022/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define DebugSharedManager [KTDebugManager sharedManager]


@interface KTDebugManager : NSObject

+ (void)presentDebugActionMenuController;

@end


@interface KTDebugManager (DebugView)

+ (void)installDebugView;

+ (void)uninstallDebugView;

+ (void)resetDebugBallAutoHidden;

@end


@interface KTDebugManager (Network)

- (void)initNetworkConfig;
- (void)uninitNetworkConfig;
- (void)startNetworkListening;
- (void)stopNetworkListening;

@end

NS_ASSUME_NONNULL_END
