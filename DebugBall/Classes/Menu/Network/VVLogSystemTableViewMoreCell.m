//
//  VVLogSystemTableViewMoreCell.m
//  Vova
//
//  Created by fwzhou on 2019/2/13.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "VVLogSystemTableViewMoreCell.h"
#import <Masonry/Masonry.h>

@interface VVLogSystemTableViewMoreCell ()

@property (nonatomic, strong) UIButton *getDetailButton;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation VVLogSystemTableViewMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        [self setUpConstraints];
    }
    return self;
}

- (void)setUpConstraints
{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(2.5);
        make.width.height.mas_equalTo(10);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
    }];
}

- (void)updateCellWithDetail:(NSAttributedString *)detail
{
    _detailLabel.attributedText = detail;
}

- (void)getDetailButtonTapped
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _detailLabel.text;

#warning TODO 0713
//    [VVToast showErrorMsg:@"已复制到粘贴板" superView:[self _getToastSuperView:self]];
}

- (__kindof UIView *)_getToastSuperView:(__kindof UIView *)view
{
    __kindof UIView *_view = [view superview];
    if ([_view isKindOfClass:NSClassFromString(@"VVLogSystemView")]) {
        return _view;
    }else {
        return [self _getToastSuperView:_view];
    }
}

- (UIButton *)getDetailButton
{
    if (!_getDetailButton) {
        _getDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _getDetailButton.backgroundColor = [UIColor colorWithRed:74/255.f green:74/255.f blue:74/255.f alpha:1];
        [_getDetailButton setTitle:@"copy" forState:UIControlStateNormal];
        [_getDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _getDetailButton.layer.cornerRadius = 5;
        _getDetailButton.layer.masksToBounds = YES;
        [_getDetailButton addTarget:self action:@selector(getDetailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_getDetailButton];
    }
    return _getDetailButton;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"console_arrow_unfold"];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.numberOfLines = 0;
        _detailLabel.userInteractionEnabled = YES;
        [_detailLabel addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(getDetailButtonTapped)]];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

@end
