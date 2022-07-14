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
- (void)checkDebugBallStatus;
- (void)updateDebugBallUnenabled;

@end

@interface KTDebugManager (Network)

@property (nonatomic, strong, readonly) NSArray *requests;

- (void)initNetworkConfig;
- (void)uninitNetworkConfig;
- (void)startNetworkListening;
- (void)stopNetworkListening;

- (void)clearRequestLogs;

@end

@interface KTDebugManager (DevControl)
- (void)didReciveAction:(NSString *)actionName;
- (void)resetActions;
@end


NS_ASSUME_NONNULL_END
