//
//  DebugView+Ripple.h
//  mobile
//
//  Created by KOTU on 2017/7/25.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "KTDebugView.h"

@interface KTDebugView (Ripple)

@property (nonatomic, strong, readonly) CADisplayLink *rippleDL;

@property (nonatomic, strong, readonly) CADisplayLink *fpsDL;

@property (nonatomic, strong, readonly) CALayer *ripple;

@property (nonatomic, strong, readonly) UILabel *fpsLabel;

- (void)generalRippleConfiguration;

@end
