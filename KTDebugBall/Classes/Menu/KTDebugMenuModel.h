//
//  KTDebugMenuModel.h
//  DebugBall
//
//  Created by KOTU on 2022/7/13.
//

#import <Foundation/Foundation.h>
@class KTDebugMenuItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface KTDebugMenuModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray <KTDebugMenuItemModel *> *items;

@end

@interface KTDebugMenuItemModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;

@property (nonatomic, assign) BOOL isShowMore;
@property (nonatomic, assign) BOOL isSwitch;

@end

NS_ASSUME_NONNULL_END
