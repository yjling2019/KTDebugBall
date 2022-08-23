//
//  KTDebugNetwrokDurationMonitorVC.m
//  AAChartKit
//
//  Created by KOTU on 2022/8/23.
//

#import "KTDebugNetwrokDurationMonitorVC.h"
#import <Masonry/Masonry.h>
#import "KTHttpLogModel.h"
#import "KTLogSystemTableViewCell.h"
#import "KTLogSystemTableViewMoreCell.h"
#import "KTDebugManager.h"
#import "KTDebugViewMacros.h"

static NSString *const KTLogSystemTableViewCellId = @"KTLogSystemTableViewCellId";
static NSString *const KTLogSystemTableViewMoreCellId = @"KTLogSystemTableViewMoreCellId";

static NSString *const KTLogSystemRequestType = @"#type#";
static NSString *const KTLogSystemHeader = @"#request-header#";
static NSString *const KTLogSystemRequest = @"#request-params#";
static NSString *const KTLogSystemResponse = @"#response#";
static NSString *const KTLogSystemStatusCode = @"#http_code#";
static NSString *const KTLogSystemTime = @"#time#";
static NSString *const KTLogSystemDuring = @"#during#";
//static NSString *const KTLogSystemParams = @"#params#";
//static NSString *const KTLogSystemCommon = @"#common#";
//static NSString *const KTLogSystemAppCommon = @"#appCommon#";
static NSString *const KTLogSystemError = @"#error#";

@interface KTDebugNetwrokDurationMonitorVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation KTDebugNetwrokDurationMonitorVC

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Request duration monitoring";
	
	[self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(0);
	}];
	
	[self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.datas.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView *footView = [[UIView alloc] init];
	return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	KTHttpLogModel *model = self.datas[indexPath.row];
	if (model.spread) {
		if (model.textHeight == 0) {
			NSString *detail = [self compomentDetailWithUrl:model.url
													   type:model.type
													 header:model.header
													request:model.request
												   response:model.response
												 statusCode:model.statusCode
													   time:model.time
													 during:model.during];
			
			UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - (30), 0)];
			tempLabel.numberOfLines = 0;
			tempLabel.font = [UIFont systemFontOfSize:(10)];
			tempLabel.text = detail;
			CGFloat height = [tempLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - (30), 0)].height + 1;
			model.textHeight = height;
		}
		return model.textHeight + 50;// 文字高度 + 按钮高度
	} else {
		return 40;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	KTHttpLogModel *model = self.datas[indexPath.row];
	if (model.spread) {
		// 已展开
		KTLogSystemTableViewMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:KTLogSystemTableViewMoreCellId];
		NSString *detail = [self compomentDetailWithUrl:model.url
												   type:model.type
												 header:model.header
												request:model.request
											   response:model.response
											 statusCode:model.statusCode
												   time:model.time
												 during:model.during];
		
		NSMutableAttributedString *attrDetail = [[NSMutableAttributedString alloc] initWithString:detail attributes: @{NSFontAttributeName : [UIFont systemFontOfSize:(10)]}];
		NSDictionary *attributes = @{
									 NSForegroundColorAttributeName: RGB_HEX(0xFF8A00),
									 };
		
		[attrDetail addAttributes:attributes range:[detail rangeOfString:KTLogSystemRequestType]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:KTLogSystemHeader]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:KTLogSystemRequest]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:KTLogSystemResponse]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:KTLogSystemStatusCode]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:KTLogSystemTime]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:KTLogSystemDuring]];
		[cell updateCellWithDetail:attrDetail];
		[cell updateWihtModel:model];
		return cell;
	} else {
		// 已收起
		KTLogSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KTLogSystemTableViewCellId];
		[cell setUpConstraintsWithType:KTLogSystemTableViewCellTypeTrackAndApi];
//		[cell updateCellWithDesc:model.url time:model.time];
		[cell updateHttpLogModel:model type:KTLogSystemTableViewRequestCellTypeDuration];
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	KTHttpLogModel *model = self.datas[indexPath.row];
	if (model.spread) {
		model.spread = !model.spread;
	} else {
		model.spread = YES;
	}
	[tableView reloadData];
}

- (NSString *)compomentDetailWithUrl:(NSString *)url
								type:(NSString *)type
							  header:(NSString *)header
							 request:(NSString *)request
							response:(NSString *)response
						  statusCode:(NSString *)statusCode
								time:(NSString *)time
							  during:(NSString *)during
{
	NSData *requestData = [request dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *dicRequest = [NSJSONSerialization JSONObjectWithData:requestData
															   options:NSJSONReadingMutableContainers
															  error:nil];

	NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:responseData
														options:NSJSONReadingMutableContainers
														  error:nil];
	
	NSString *detail = url;
	detail = [detail stringByAppendingString:@"\n"];
	if (type) {
		detail = [detail stringByAppendingFormat:@"%@ %@\n", KTLogSystemRequestType, type];
	}
	if (header) {
		detail = [detail stringByAppendingFormat:@"%@ %@\n", KTLogSystemHeader, header];
	}
	if (request) {
		detail = [detail stringByAppendingFormat:@"%@ %@\n", KTLogSystemRequest, dicRequest];
	}
	if (response) {
		if (dicResponse) {
			detail = [detail stringByAppendingFormat:@"%@ %@\n", KTLogSystemResponse, dicResponse];
		} else {
			detail = [detail stringByAppendingFormat:@"%@ %@\n", KTLogSystemResponse, response];
		}
	}
	detail = [detail stringByAppendingFormat:@"%@ %@\n", KTLogSystemStatusCode, statusCode?:@""];
	
	if (time) {
		detail = [detail stringByAppendingFormat:@"%@ %@\n", KTLogSystemTime, time];
	}
	if (during) {
		detail = [detail stringByAppendingFormat:@"%@ %@", KTLogSystemDuring, during];
	}
	
	NSMutableString *convertedString = [detail mutableCopy];
	[convertedString replaceOccurrencesOfString:@"\\U"
									 withString:@"\\u"
										options:0
										  range:NSMakeRange(0, convertedString.length)];
	CFStringRef transform = CFSTR("Any-Hex/Java");
	CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
	
	return convertedString;
}

- (void)reloadData
{
	NSMutableArray *requests = [NSMutableArray array];
	
	int standard = 1000;
	if (DebugSharedManager.networkUtils && [DebugSharedManager.networkUtils respondsToSelector:@selector(requestTimeDurationStandard)]) {
		standard = [DebugSharedManager.networkUtils requestTimeDurationStandard];
	}
	
	NSArray *array = [NSArray arrayWithArray:DebugSharedManager.requests];
	for (KTHttpLogModel *model in array) {
		if (model.during.integerValue > standard) {
			[requests addObject:model];
		}
	}
	
	self.datas = requests;
	[self.tableView reloadData];
}

#pragma mark - lazy load
- (UITableView *)tableView
{
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[_tableView registerClass:[KTLogSystemTableViewCell class] forCellReuseIdentifier:KTLogSystemTableViewCellId];
		[_tableView registerClass:[KTLogSystemTableViewMoreCell class] forCellReuseIdentifier:KTLogSystemTableViewMoreCellId];
	}
	return _tableView;
}

@end

