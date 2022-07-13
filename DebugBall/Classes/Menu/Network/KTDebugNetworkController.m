//
//  KTDebugNetworkController.m
//  DebugBall
//
//  Created by 凌永剑 on 2022/7/13.
//

#import "KTDebugNetworkController.h"
#import <Masonry/Masonry.h>
#import "ConsoleHttpModel.h"
#import "VVLogSystemTableViewCell.h"
#import "VVLogSystemTableViewMoreCell.h"

static NSString *const VVLogSystemTableViewCellId = @"VVLogSystemTableViewCellId";
static NSString *const VVLogSystemTableViewMoreCellId = @"VVLogSystemTableViewMoreCellId";

static NSString *const VVLogSystemRequestType = @"#type#";
static NSString *const VVLogSystemHeader = @"#request-public#";
static NSString *const VVLogSystemRequest = @"#request-other#";
static NSString *const VVLogSystemResponse = @"#response#";
static NSString *const VVLogSystemTime = @"#time#";
static NSString *const VVLogSystemDuring = @"#during#";
//static NSString *const VVLogSystemParams = @"#params#";
//static NSString *const VVLogSystemCommon = @"#common#";
//static NSString *const VVLogSystemAppCommon = @"#appCommon#";
static NSString *const VVLogSystemError = @"#error#";

@interface KTDebugNetworkController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation KTDebugNetworkController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(0);
	}];
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
	ConsoleHttpModel *model = self.datas[indexPath.row];
	if (model.spread) {
		NSString *detail = [self compomentDetailWithUrl:model.url
												   type:model.type
												 header:model.header
												request:model.request
											   response:model.response
												   time:model.time
												 during:model.during];
		
		UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 30, 0)];
		tempLabel.numberOfLines = 0;
		tempLabel.font = [UIFont systemFontOfSize:10];
		tempLabel.text = detail;
		CGFloat height = [tempLabel sizeThatFits:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30, 0)].height + 1;
		return height + 50;// 文字高度 + 按钮高度
	} else {
		return 25;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ConsoleHttpModel *model = self.datas[indexPath.row];
	if (model.spread) {
		// 已展开
		VVLogSystemTableViewMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:VVLogSystemTableViewMoreCellId];
		NSString *detail = [self compomentDetailWithUrl:model.url
												   type:model.type
												 header:model.header
												request:model.request
											   response:model.response
												   time:model.time
												 during:model.during];
		
		NSMutableAttributedString *attrDetail = [[NSMutableAttributedString alloc] initWithString:detail attributes: @{NSFontAttributeName : [UIFont systemFontOfSize:10]}];
		NSDictionary *attributes = @{
									 NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.f green:138/255.f blue:0 alpha:1],
									 };
		
		[attrDetail addAttributes:attributes range:[detail rangeOfString:VVLogSystemRequestType]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:VVLogSystemHeader]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:VVLogSystemRequest]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:VVLogSystemResponse]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:VVLogSystemTime]];
		[attrDetail addAttributes:attributes range:[detail rangeOfString:VVLogSystemDuring]];
		
		[cell updateCellWithDetail:attrDetail];
		return cell;
	} else {
		// 已收起
		VVLogSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VVLogSystemTableViewCellId];
		[cell setUpConstraintsWithType:VVLogSystemTableViewCellTypeTrackAndApi];
		[cell updateCellWithDesc:model.url time:model.time];
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ConsoleHttpModel *model = self.datas[indexPath.row];
#warning TODO
//	[VVStoreTool updateInCacheRealm:^(RLMRealm * _Nonnull realm) {
		if (model.spread) {
			model.spread = !model.spread;
		} else {
			model.spread = YES;
		}
//	}];
	[self.tableView reloadData];
}

- (NSString *)compomentDetailWithUrl:(NSString *)url
								type:(NSString *)type
							  header:(NSString *)header
							 request:(NSString *)request
							response:(NSString *)response
								time:(NSString *)time
							  during:(NSString *)during
{
	NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:jsonData
														options:NSJSONReadingMutableContainers
														  error:nil];
	NSString *detail = url;
	detail = [detail stringByAppendingString:@"\n"];
	if (type) {
		detail = [detail stringByAppendingFormat:@"%@ %@\n", VVLogSystemRequestType, type];
	}
	if (header) {
		detail = [detail stringByAppendingFormat:@"%@ %@\n", VVLogSystemHeader, header];
	}
	if (request) {
		detail = [detail stringByAppendingFormat:@"%@ %@\n", VVLogSystemRequest, request];
	}
	if (response) {
		detail = [detail stringByAppendingFormat:@"%@ %@\n", VVLogSystemResponse, dicResponse];
	}
	if (time) {
		detail = [detail stringByAppendingFormat:@"%@ %@\n", VVLogSystemTime, time];
	}
	if (during) {
		detail = [detail stringByAppendingFormat:@"%@ %@", VVLogSystemDuring, during];
	}
	
	return detail;
}

- (void)reloadDataWithArray:(NSArray *)array
{
	self.datas = array;
	
	[self.tableView reloadData];
}

#pragma mark - lazy load
- (UITableView *)tableView
{
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[_tableView registerClass:[VVLogSystemTableViewCell class] forCellReuseIdentifier:VVLogSystemTableViewCellId];
		[_tableView registerClass:[VVLogSystemTableViewMoreCell class] forCellReuseIdentifier:VVLogSystemTableViewMoreCellId];
	}
	return _tableView;
}

@end
