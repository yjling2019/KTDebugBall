//
//  VVLogSystemTableViewMoreCell.m
//  Vova
//
//  Created by fwzhou on 2019/2/13.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "VVLogSystemTableViewMoreCell.h"
#import <Masonry/Masonry.h>
#import "ConsoleHttpModel.h"
#import "KTDebugBallUtils.h"

@interface VVLogSystemTableViewMoreCell ()

@property (nonatomic, strong) UIButton *getDetailButton;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) id model;
@end

@implementation VVLogSystemTableViewMoreCell

- (void)getDetailButtonTapped
{
	if ([self.model isKindOfClass:ConsoleHttpModel.class]) {
		ConsoleHttpModel *httpModel = (ConsoleHttpModel *)self.model;
	
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		pasteboard.string = httpModel.curlString;

		UILabel *label = [[UILabel alloc] init];
		label.backgroundColor = [UIColor blackColor];
		label.textColor = [UIColor whiteColor];
		label.text = @"\n    已复制到粘贴板    \n";
		label.numberOfLines = 0;
		label.layer.cornerRadius = 8;
		label.layer.masksToBounds = YES;
		[self.superview.superview addSubview:label];
		[label mas_updateConstraints:^(MASConstraintMaker *make) {
			make.center.mas_equalTo(0);
		}];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[label removeFromSuperview];
		});
	}
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self setUpUI];
		[self setUpConstraints];
	}
	return self;
}

- (void)setUpUI
{
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.accessoryType = UITableViewCellAccessoryNone;
	[self.contentView addSubview:self.detailLabel];
	[self.contentView addSubview:self.iconImageView];
	[self.contentView addSubview:self.getDetailButton];
}

- (void)setUpConstraints
{
	[self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self).offset((10));
		make.leading.equalTo(self).offset((2.5));
		make.width.height.mas_equalTo((10));
	}];
	
	[self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.insets(UIEdgeInsetsMake(10, 15, 10, 15));
	}];
	
	[self.getDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self).offset((0));
		make.trailing.equalTo(self).offset((-10));
	}];
}

- (void)updateCellWithDetail:(NSAttributedString *)detail
{
	_detailLabel.attributedText = detail;
}

- (void)updateWihtModel:(id)model
{
	self.model = model;
	self.getDetailButton.hidden = ![self.model isKindOfClass:ConsoleHttpModel.class];
}

#pragma mark - GETTER

- (UIButton *)getDetailButton
{
	if (!_getDetailButton) {
		_getDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_getDetailButton.hidden = YES;
		[_getDetailButton setTitle:@"复制curl" forState:UIControlStateNormal];
		[_getDetailButton setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
		[_getDetailButton addTarget:self action:@selector(getDetailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	}
	return _getDetailButton;
}

- (UIImageView *)iconImageView
{
	if (!_iconImageView) {
		_iconImageView = [[UIImageView alloc] init];
		_iconImageView.image = DebugBallImageWithNamed(@"console_arrow_unfold");
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
	}
	return _detailLabel;
}

@end
