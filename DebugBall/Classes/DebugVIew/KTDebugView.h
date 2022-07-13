//
//  KTDebugView.h
//  mobile
//
//  Created by KOTU on 2017/7/25.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 KTDebugView,默认情况下，已用内存/(可用内存+已用内存)<=0.2f或FPS<=50时高亮显示
 */

@interface KTDebugView : UIView

@property (nonatomic, copy) dispatch_block_t tapAction;
/** 自动隐藏, 默认开启 */
- (KTDebugView* (^)(BOOL))autoHidden;
/** 水深占比，0 to 1; */
- (KTDebugView* (^)(CGFloat))waterDepth;
/** 波浪速度，默认 0.05f */
- (KTDebugView* (^)(CGFloat))speed;
/** 波浪幅度，默认1 */
- (KTDebugView* (^)(CGFloat))amplitude;
/** 波浪紧凑程度（角速度），默认 10.0 */
- (KTDebugView* (^)(CGFloat))angularVelocity;
/** 相位，默认0 */
- (KTDebugView* (^)(CGFloat))phase;
/** returns a global instance of KTDebugView configured to default */
+ (instancetype)debugView;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (KTDebugView* (^)())show;
- (KTDebugView* (^)())dismiss;
@end

typedef NSString Action;
/* Will add an action about displaying border with all subviews of visible controller */
FOUNDATION_EXTERN Action * const kKTDebugViewTapActionDisplayBorder;
/* Will add an action about displaying action menu view */
FOUNDATION_EXTERN Action * const kKTDebugViewTapActionDisplayActionMenu;

@interface KTDebugView (TapAction)

- (KTDebugView * (^)(Action *action))commitTapAction;

- (KTDebugView * (^)(Action *action))commitCallBackAction;

@end
