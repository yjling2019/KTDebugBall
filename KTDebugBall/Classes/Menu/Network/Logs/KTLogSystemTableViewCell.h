//
//  KTLogSystemTableViewCell.h
//
//  Created by KOTU on 2019/2/13.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTHttpLogModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KTLogSystemTableViewCellType) {
    KTLogSystemTableViewCellTypeTrackAndApi = 0,  /// 打点、Api
    KTLogSystemTableViewCellTypeRegression, /// 回归
};

typedef NS_ENUM(NSUInteger, KTLogSystemTableViewRequestCellType) {
	KTLogSystemTableViewRequestCellTypeNone,
	KTLogSystemTableViewRequestCellTypeFail,
	KTLogSystemTableViewRequestCellTypeDuration,
};

@interface KTLogSystemTableViewCell : UITableViewCell

- (void)setUpConstraintsWithType:(KTLogSystemTableViewCellType)cellType;

- (void)updateHttpLogModel:(KTHttpLogModel *)model type:(KTLogSystemTableViewRequestCellType)type;

//- (void)updateCellWithDesc:(NSString *)desc time:(NSString *)time;
//
//- (void)updateCellWithPageCode:(NSString *)pageCode
//                   elementName:(NSString *)elementName
//                          type:(NSString *)type
//                          time:(NSString *)time
//                        detail:(NSAttributedString *)detail
//                       warning:(NSString *)warning
//                isMatchService:(BOOL)isMatchService;
//
//- (void)updateRegressionCellWithParam:(NSDictionary *)param
//                            trackType:(NSString *)type
//                       isMatchService:(BOOL)isMatchService;

@end

NS_ASSUME_NONNULL_END
