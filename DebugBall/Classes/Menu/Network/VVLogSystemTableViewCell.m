//
//  VVLogSystemTableViewCell.m
//  Vova
//
//  Created by fwzhou on 2019/2/13.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "VVLogSystemTableViewCell.h"
#import <Masonry/Masonry.h>

@interface VVLogSystemTableViewCellLabel : UILabel

@end

@implementation VVLogSystemTableViewCellLabel

- (void)drawTextInRect:(CGRect)rect {//文字距离上下左右边框都有10单位的间隔
    CGRect newRect = CGRectMake(rect.origin.x + 10, rect.origin.y + 10, rect.size.width - 20, rect.size.height -20);
    [super drawTextInRect:newRect];
}

@end

@interface VVLogSystemTableViewCell ()

@property (nonatomic, assign) VVLogSystemTableViewCellType cellType;

@property (nonatomic, strong) UIView *headerContentView; // 头内容容器

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *label1;  // 打点 pageCodeLb
@property (nonatomic, strong) UILabel *label2;  // 打点 elementNameLb
@property (nonatomic, strong) UILabel *label3;  // 打点 typeLb
@property (nonatomic, strong) UILabel *warningLb;

@property (nonatomic, strong) UIView *verticalView1; // 竖线1
@property (nonatomic, strong) UIView *verticalView2; // 竖线2

@property (nonatomic, strong) UILabel *detailLabel; // 详情label

@property (nonatomic, strong) UIImageView *regressionStateIV;   /// 回归结果状态

@end

@implementation VVLogSystemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        //        [self setUpConstraints];
    }
    return self;
}

- (void)setUpConstraintsWithType:(VVLogSystemTableViewCellType)cellType
{
    self.cellType = cellType;
    
    __weak typeof(self) __weakSelf = self;
    
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@3);
        make.height.mas_equalTo(30);
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@-3);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerContentView);
        make.left.equalTo(self.headerContentView).offset(4);
        make.width.height.mas_equalTo(10);
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(__weakSelf.iconImageView.mas_trailing).offset(8);
        make.height.equalTo(@18);
        make.centerY.equalTo(__weakSelf.headerContentView);
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(__weakSelf.label1.mas_trailing).offset(10);
        make.height.equalTo(@18);
        make.centerY.equalTo(__weakSelf.headerContentView);
    }];
    
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(__weakSelf.label2.mas_trailing).offset(10);
        make.height.equalTo(@18);
        make.centerY.equalTo(__weakSelf.headerContentView);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerContentView).offset(15);
        make.centerY.equalTo(__weakSelf.headerContentView);
        make.width.mas_lessThanOrEqualTo(260);
    }];
    
    if (self.cellType == VVLogSystemTableViewCellTypeTrackAndApi) {
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.headerContentView).offset(-8);
            make.top.equalTo(@0);
            make.height.equalTo(@10);
        }];
        
        [self.warningLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-2);
            make.bottom.equalTo(@-2);
            make.width.equalTo(@30);
            make.height.equalTo(@18);
        }];
    }else {
        //        [self.regressionStateIV mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.equalTo(self);
        //            make.size.mas_offset(CGSizeMake(15, 15));
        //            make.trailing.equalTo(@5);
        //        }];
        
        [self.warningLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-2);
            make.centerY.equalTo(__weakSelf.headerContentView);
            make.width.equalTo(@18);
            make.height.equalTo(@18);
        }];
    }
    
    [self.verticalView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@14);
        make.width.equalTo(@2);
        make.centerY.equalTo(__weakSelf.headerContentView);
    }];
    
    [self.verticalView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@14);
        make.width.equalTo(@2);
        make.centerY.equalTo(__weakSelf.headerContentView);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.headerContentView).offset(3);
    }];
}

- (void)updateCellWithDesc:(NSString *)desc time:(NSString *)time
{
    _descLabel.text = desc;
    _timeLabel.text = time;
    _descLabel.hidden = NO;
    _label1.hidden = YES;
    _label2.hidden = YES;
    _label3.hidden = YES;
    _warningLb.hidden = YES;
}

- (void)updateCellWithPageCode:(NSString *)pageCode
                   elementName:(NSString *)elementName
                          type:(NSString *)type
                          time:(NSString *)time
                        detail:(NSAttributedString *)detail
                       warning:(NSString *)warning
                isMatchService:(BOOL)isMatchService
{
    _descLabel.hidden = YES;
    _label1.hidden = NO;
    _label2.hidden = NO;
    _label3.hidden = NO;
    
    _label1.text = [NSString stringWithFormat:@" %@ ",pageCode];
    _label2.text = [NSString stringWithFormat:@" %@ ",type];
    _label3.text = [NSString stringWithFormat:@" %@ ",elementName];
    _timeLabel.text = time;
    _warningLb.text = @"重复";
    
    if ([type isEqualToString:@"data"]) {
        _label1.text = [NSString stringWithFormat:@" data | %@ ",elementName];
        _label1.textColor = [UIColor colorWithRed:50/255.f green:50/255.f blue:50/255.f alpha:1];
        _label2.hidden = YES;
        _label3.hidden = YES;
    }else if (!elementName || !elementName.length) {
        _label1.textColor = [UIColor colorWithRed:229/255.f green:129/255.f blue:1/255.f alpha:1];
        _label2.hidden = NO;
        _label3.hidden = YES;
    }else {
		_label1.textColor = [UIColor colorWithRed:229/255.f green:129/255.f blue:1/255.f alpha:1];
        _label2.hidden = NO;
        _label3.hidden = NO;
    }
    
    self.detailLabel.attributedText = detail;
    
    if (detail) {
        self.iconImageView.image = [UIImage imageNamed:@"console_arrow_unfold"];
        
        [self.headerContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@3);
            make.height.mas_equalTo(30);
            make.leading.trailing.equalTo(@0);
            //            make.bottom.equalTo(@-3);
        }];
        
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self.headerContentView.mas_bottom).offset(5);
            make.bottom.equalTo(self).offset(-5);
        }];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"console_arrow_fold"];
        
        [self.headerContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@3);
            make.height.mas_equalTo(30);
            make.leading.trailing.equalTo(@0);
            make.bottom.equalTo(@-3);
        }];
        
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
        }];
    }
    
	_warningLb.backgroundColor = [UIColor colorWithRed:224/255.f green:32/255.f blue:32/255.f alpha:1];
    if (warning) {
        _warningLb.hidden = NO;
        _warningLb.text = warning;
    } else {
        _warningLb.hidden = YES;
    }
    
    [self _addVerticalView];
}

- (void)updateRegressionCellWithParam:(NSDictionary *)param trackType:(NSString *)type isMatchService:(BOOL)isMatchService
{
    type = @"common_impression";
    param = @{@"list_uri" : @"ffffff", @"list_name": @"ffffsssssss"};
    _descLabel.hidden = YES;
    _label1.hidden = NO;
    _label2.hidden = NO;
    _label3.hidden = NO;
    _warningLb.hidden = NO;
    
    self.label1.text = param[@"event"];
    
    if ([type isEqualToString:@"pageview"]) {
        self.label2.text = param[@"page_code"];
    }
    
    else if ([type isEqualToString:@"common_click-link_click"]) {
        self.label2.text = param[@"element_name"];
    }
    
    else if ([type isEqualToString:@"common_impression"]) {
        self.label2.text = param[@"list_uri"];
        self.label3.text = param[@"list_name"];
    }
    
    else if ([type isEqualToString:@"goods_click-link_click"]) {
        self.label2.text = param[@"list_uri"];
    }
    
    else if ([type isEqualToString:@"goods_impression"]) {
        self.label2.text = param[@"list_uri"];
    }
    
    else if ([type isEqualToString:@"impression"]) {
        self.label2.text = param[@"element_name"];
    }
    
    else if ([type isEqualToString:@"data"]) {
        self.label2.text = param[@"element_name"];
    }
    
    _warningLb.backgroundColor = [UIColor clearColor];
    if (isMatchService) {
        _warningLb.text = @"✅";
    }else {
        _warningLb.text = @"❌";
    }
}

- (void)_addVerticalView
{
    NSMutableArray <UILabel *>*marrView = [NSMutableArray array];
    if (!self.label1.hidden) [marrView addObject:self.label1];
    if (!self.label2.hidden) [marrView addObject:self.label2];
    if (!self.label3.hidden) [marrView addObject:self.label3];
    
    self.verticalView1.hidden = YES;
    self.verticalView2.hidden = YES;
    __block UIView *verticalView = self.verticalView1;
    
    int diff = (int)marrView.count - 2;
    
    [marrView enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // iOS 中NSUInteger和NSInterger的比较，底层会根据前后顺序进行类型逆变
        
        if ((int)idx <= diff) {
            verticalView.hidden = NO;
            [verticalView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@14);
                make.width.equalTo(@2);
                make.centerY.equalTo(self.headerContentView);
                make.leading.equalTo(obj.mas_trailing).offset(4);
            }];
            
            verticalView = self.verticalView2;
        }
    }];
}

- (void)_getDetailButtonTapped
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _detailLabel.text;
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

- (UIView *)headerContentView
{
    if (!_headerContentView) {
        _headerContentView = [[UIView alloc] init];
        [self addSubview:_headerContentView];
    }
    return _headerContentView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"console_arrow_fold"];
        [self.headerContentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:10];
        [self.headerContentView addSubview:_descLabel];
    }
    return _descLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:8];
        [self.headerContentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)label1
{
    if (!_label1) {
        _label1 = [UILabel new];
        _label1.font = [UIFont systemFontOfSize:10];
		_label1.textColor = [UIColor colorWithRed:229/255.f green:129/255.f blue:1/255.f alpha:1];
        [self.headerContentView addSubview:_label1];
    }
    return _label1;
}

- (UILabel *)label2
{
    if (!_label2) {
        _label2 = [UILabel new];
        _label2.font = [UIFont systemFontOfSize:10];
		_label2.textColor = [UIColor colorWithRed:50/255.f green:50/255.f blue:50/255.f alpha:1];
        [self.headerContentView addSubview:_label2];
    }
    return _label2;
}

- (UILabel *)label3
{
    if (!_label3) {
        _label3 = [UILabel new];
        _label3.font = [UIFont systemFontOfSize:10];
		_label3.textColor = [UIColor colorWithRed:50/255.f green:50/255.f blue:50/255.f alpha:1];
        [self.headerContentView addSubview:_label3];
    }
    return _label3;
}

- (UILabel *)warningLb
{
    if (!_warningLb) {
        _warningLb = [UILabel new];
        _warningLb.font = [UIFont systemFontOfSize:10];
        _warningLb.textColor = [UIColor whiteColor];
		_warningLb.backgroundColor = [UIColor colorWithRed:224/255.f green:32/255.f blue:32/255.f alpha:1];
        if (self.cellType == VVLogSystemTableViewCellTypeTrackAndApi) {
			_warningLb.backgroundColor = [UIColor colorWithRed:224/255.f green:32/255.f blue:32/255.f alpha:1];
        }
        _warningLb.textAlignment = NSTextAlignmentCenter;
        [self.headerContentView addSubview:_warningLb];
    }
    return _warningLb;
}

- (UIView *)verticalView1
{
    if (!_verticalView1) {
        _verticalView1 = [UIView new];
		_verticalView1.backgroundColor = [UIColor colorWithRed:232/255.f green:234/255.f blue:239/255.f alpha:1];
        [self.headerContentView addSubview:_verticalView1];
        _verticalView1.hidden = YES;
    }
    return _verticalView1;
}

- (UIView *)verticalView2
{
    if (!_verticalView2) {
        _verticalView2 = [UIView new];
		_verticalView2.backgroundColor = [UIColor colorWithRed:232/255.f green:234/255.f blue:239/255.f alpha:1];
        [self.headerContentView addSubview:_verticalView2];
        _verticalView2.hidden = YES;
    }
    return _verticalView2;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.numberOfLines = 0;
        _detailLabel.userInteractionEnabled = YES;
        [_detailLabel addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(_getDetailButtonTapped)]];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIImageView *)regressionStateIV
{
    if (!_regressionStateIV) {
        _regressionStateIV = [UIImageView new];
        [self.headerContentView addSubview:_regressionStateIV];
    }
    return _regressionStateIV;
}

@end
