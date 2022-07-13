//
//  VVLogSystemTableViewCell.h
//  Vova
//
//  Created by fwzhou on 2019/2/13.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VVLogSystemTableViewCellType) {
    VVLogSystemTableViewCellTypeTrackAndApi = 0,  /// 打点、Api
    VVLogSystemTableViewCellTypeRegression, /// 回归
};

@interface VVLogSystemTableViewCell : UITableViewCell

- (void)setUpConstraintsWithType:(VVLogSystemTableViewCellType)cellType;

- (void)updateCellWithDesc:(NSString *)desc time:(NSString *)time;

- (void)updateCellWithPageCode:(NSString *)pageCode
                   elementName:(NSString *)elementName
                          type:(NSString *)type
                          time:(NSString *)time
                        detail:(NSAttributedString *)detail
                       warning:(NSString *)warning
                isMatchService:(BOOL)isMatchService;

- (void)updateRegressionCellWithParam:(NSDictionary *)param
                            trackType:(NSString *)type
                       isMatchService:(BOOL)isMatchService;

@end

NS_ASSUME_NONNULL_END
