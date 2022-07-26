//
//  KTLogSystemTableViewMoreCell.h
//
//  Created by KOTU on 2019/2/13.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTLogSystemTableViewMoreCell : UITableViewCell

- (void)updateWihtModel:(id)model;
- (void)updateCellWithDetail:(NSAttributedString *)detail;

@end

NS_ASSUME_NONNULL_END
