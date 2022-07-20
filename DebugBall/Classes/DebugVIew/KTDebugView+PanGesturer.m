//
//  KTDebugView+PanGesturer.m
//  mobile
//
//  Created by KOTU on 2017/7/25.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "KTDebugView+PanGesturer.h"
#import <objc/runtime.h>
#import "KTDebugViewMacros.h"

@interface KTDebugView (Hidden)
@property (nonatomic, assign) BOOL hidden;
@end

@implementation KTDebugView (PanGesturer)

static CGPoint origin;

- (void)gestureRecognizersConfig {
    if (self.gestureRecognizers.count>0) {
        [self clearConfiguration];
    } else {
        [self start];
    }
}

- (void)start {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
    pan.delaysTouchesBegan = NO;
    [self addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
    [self addGestureRecognizer:tap];
    origin = self.center;
    [self changeStatus];
    if ([[self valueForKey:@"_autoHidden"] boolValue]) {
        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
    }
}

- (void)clearConfiguration {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeGestureRecognizer:obj];
    }];
    [UIView animateWithDuration:animateDuration animations:^{
        self.alpha = 1;
        self.center = origin;
    } completion:^(BOOL finished) {
        self.hidden = NO;
        [self start];
    }];
}

- (void)tapViewAction:(UITapGestureRecognizer *)tap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
    if (self.hidden) {
        if (self.tapAction) {
            self.tapAction();
        }
    } else {
        [self changeStatus];
    }
    if ([[self valueForKey:@"_autoHidden"] boolValue]) {
        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
    }
}

- (void)changeStatus {
    [UIView animateWithDuration:animateDuration animations:^{
        self.alpha = self.hidden?sleepAlpha:1;
    }];
    [UIView animateWithDuration:animateDuration animations:^{
        CGFloat x = self.center.x < 20+VIEW_WIDTH/2 ? 0 :  self.center.x > [[UIScreen mainScreen] bounds].size.width - 20 -VIEW_WIDTH/2 ? [[UIScreen mainScreen] bounds].size.width : self.center.x;
        CGFloat y = self.center.y < 40 + VIEW_HEIGHT/2 ? 0 : self.center.y > [[UIScreen mainScreen] bounds].size.height - 40 - VIEW_HEIGHT/2 ? [[UIScreen mainScreen] bounds].size.height : self.center.y;
        if((x == 0 && y ==0) || (x == [[UIScreen mainScreen] bounds].size.width && y == 0) || (x == 0 && y == [[UIScreen mainScreen] bounds].size.height) || (x == [[UIScreen mainScreen] bounds].size.width && y == [[UIScreen mainScreen] bounds].size.height)){
            y = self.center.y;
        }
        CGPoint hd = CGPointMake(x, y);
        self.center = self.hidden?hd:origin;
    }];
    self.hidden = !self.hidden;
}

- (void)locationChange:(UIPanGestureRecognizer*)p
{
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(p.state == UIGestureRecognizerStateBegan)
    {
        self.hidden = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
        self.alpha = normalAlpha;
    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        [[self valueForKey:@"_autoHidden"] boolValue]?[self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration]:nil;
        if(panPoint.x <= [[UIScreen mainScreen] bounds].size.width/2)
        {
            if(panPoint.y <= 40+VIEW_HEIGHT/2 && panPoint.x >= 20+VIEW_WIDTH/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, VIEW_HEIGHT/2+gap);
                }];
            }
            else if(panPoint.y >= [[UIScreen mainScreen] bounds].size.height-VIEW_HEIGHT/2-40 && panPoint.x >= 20+VIEW_WIDTH/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, [[UIScreen mainScreen] bounds].size.height-VIEW_HEIGHT/2-gap);
                }];
            }
            else if (panPoint.x < VIEW_WIDTH/2+20 && panPoint.y > [[UIScreen mainScreen] bounds].size.height-VIEW_HEIGHT/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(VIEW_WIDTH/2+gap, [[UIScreen mainScreen] bounds].size.height-VIEW_HEIGHT/2-gap);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y < VIEW_HEIGHT/2 ? VIEW_HEIGHT/2+gap :panPoint.y;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(VIEW_WIDTH/2+gap, pointy);
                }];
            }
        }
        else if(panPoint.x > [[UIScreen mainScreen] bounds].size.width/2)
        {
            if(panPoint.y <= 40+VIEW_HEIGHT/2 && panPoint.x < [[UIScreen mainScreen] bounds].size.width-VIEW_WIDTH/2-20 )
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, VIEW_HEIGHT/2+gap);
                }];
            }
            else if(panPoint.y >= [[UIScreen mainScreen] bounds].size.height-40-VIEW_HEIGHT/2 && panPoint.x < [[UIScreen mainScreen] bounds].size.width-VIEW_WIDTH/2-20)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, [[UIScreen mainScreen] bounds].size.height-VIEW_HEIGHT/2-gap);
                }];
            }
            else if (panPoint.x > [[UIScreen mainScreen] bounds].size.width-VIEW_WIDTH/2-20 && panPoint.y < VIEW_HEIGHT/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake([[UIScreen mainScreen] bounds].size.width-VIEW_WIDTH/2-gap, VIEW_HEIGHT/2+gap);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y > [[UIScreen mainScreen] bounds].size.height-VIEW_HEIGHT/2 ? [[UIScreen mainScreen] bounds].size.height-VIEW_HEIGHT/2-gap :panPoint.y;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake([[UIScreen mainScreen] bounds].size.width-VIEW_WIDTH/2-gap, pointy);
                }];
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animateDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            origin = self.center;
        });
    }
}

- (BOOL)hidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(hidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
