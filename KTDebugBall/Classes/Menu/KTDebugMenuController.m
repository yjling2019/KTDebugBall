//
//  KTDebugMenuController.m
//  DebugBall
//
//  Created by KOTU on 2022/7/13.
//

#import "KTDebugMenuController.h"
#import "KTDebugManager.h"
#import <Masonry/Masonry.h>
#import "KTDebugMenuModel.h"
#import "KTDebugNetworkController.h"
#import "KTDebugNetworkFailRequestVC.h"
#import "KTDebugNetwrokDurationMonitorVC.h"
#import "KTDebugNetworkMissingInspectionVC.h"

@interface KTDebugMenuController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <KTDebugMenuModel *> *datas;

@end

@implementation KTDebugMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(0);
	}];
	[self reloadDatas];
}

- (void)reloadDatas
{
	KTDebugMenuModel *m1 = ({
		KTDebugMenuModel *model = [[KTDebugMenuModel alloc] init];
		model.title = @"API Configuration";
		
		KTDebugMenuItemModel *item1 = [[KTDebugMenuItemModel alloc] init];
		item1.title = @"API Domain";
		item1.value = @"Not Set";
		
		KTDebugMenuItemModel *item2 = [[KTDebugMenuItemModel alloc] init];
		item2.title = @"H5-API Domain";
		item2.value = @"Not Set";
		
		model.items = @[item1, item2];
		model;
	});
	
	KTDebugMenuModel *m2 = ({
		KTDebugMenuModel *model = [[KTDebugMenuModel alloc] init];
		model.title = @"Device Hardware";
		
		KTDebugMenuItemModel *item1 = [[KTDebugMenuItemModel alloc] init];
		item1.title = @"Device Hardware";
		item1.value = @"Click to view details";
		item1.isShowMore = YES;
		
		model.items = @[item1];
		model;
	});
	
	KTDebugMenuModel *m3 = ({
		KTDebugMenuModel *model = [[KTDebugMenuModel alloc] init];
		model.title = @"Network";

		KTDebugMenuItemModel *item1 = [[KTDebugMenuItemModel alloc] init];
		item1.title = @"Logs";
		item1.isShowMore = YES;
		
		KTDebugMenuItemModel *item2 = [[KTDebugMenuItemModel alloc] init];
		item2.title = @"Failed requests";
		item2.isShowMore = YES;
		
		KTDebugMenuItemModel *item5 = [[KTDebugMenuItemModel alloc] init];
		item5.title = @"Request duration monitoring";
		item5.isShowMore = YES;
		
		KTDebugMenuItemModel *item3 = [[KTDebugMenuItemModel alloc] init];
		item3.title = @"Missing inspection";
		item3.isShowMore = YES;
		
		KTDebugMenuItemModel *item4 = [[KTDebugMenuItemModel alloc] init];
		item4.title = @"Filter";
		item4.isShowMore = YES;

		model.items = @[item1, item2, item5, item3, item4];
		model;
	});
	
	KTDebugMenuModel *m4 = ({
		KTDebugMenuModel *model = [[KTDebugMenuModel alloc] init];
		model.title = @"Tools";
		
//		KTDebugMenuItemModel *item1 = [[KTDebugMenuItemModel alloc] init];
//		item1.title = @"Display debug mask view for all visible views";
//		item1.isSwitch = YES;

//		KTDebugMenuItemModel *item2 = [[KTDebugMenuItemModel alloc] init];
//		item2.title = @"Display network sniffer";
//		item2.isShowMore = YES;
		
		KTDebugMenuItemModel *item3 = [[KTDebugMenuItemModel alloc] init];
		item3.title = @"Display crash asserts & stacks";
		item3.isShowMore = YES;

		KTDebugMenuItemModel *item4 = [[KTDebugMenuItemModel alloc] init];
		item4.title = @"Test Custom H5-WebView";
		
		KTDebugMenuItemModel *item5 = [[KTDebugMenuItemModel alloc] init];
		item5.title = @"Shortcut";
		item5.value = @"Display custom shortcut actions";
		item5.isShowMore = YES;

		model.items = @[item3, item4, item5];
		model;
	});
	
	KTDebugMenuModel *m5 = ({
		KTDebugMenuModel *model = [[KTDebugMenuModel alloc] init];
		model.title = @"DebugBall Configuration";
		
		KTDebugMenuItemModel *item1 = [[KTDebugMenuItemModel alloc] init];
		item1.title = @"DebugBall Enable";
		item1.isSwitch = YES;
		
		model.items = @[item1];
		model;
	});
	
	self.datas = @[m1, m2, m3, m4, m5];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	KTDebugMenuModel *model = [self.datas objectAtIndex:section];
	return model.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return 60;
	} else {
		return 40;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	KTDebugMenuModel *model = [self.datas objectAtIndex:section];

	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40)];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [[UIScreen mainScreen] bounds].size.width, 40)];
	label.textColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
	label.text = model.title;
	[view addSubview:label];
	
	if (section == 0) {
		view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 60);
		label.frame = CGRectMake(20, 20, [[UIScreen mainScreen] bounds].size.width, 40);
	}
	
	return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.textColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
		cell.detailTextLabel.textColor = [UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1];
	}
	
	KTDebugMenuModel *model = [self.datas objectAtIndex:indexPath.section];
	KTDebugMenuItemModel *item = [model.items objectAtIndex:indexPath.row];
	
	cell.textLabel.text = item.title;
	cell.detailTextLabel.text = item.value;
	
	if (item.isShowMore) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if (item.isSwitch) {
		UISwitch *sw = [[UISwitch alloc] init];
		cell.accessoryView = sw;
		[sw setOn:YES];
		[sw addTarget:self action:@selector(hideDebugBall) forControlEvents:UIControlEventValueChanged];
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	KTDebugMenuModel *model = [self.datas objectAtIndex:indexPath.section];
	KTDebugMenuItemModel *item = [model.items objectAtIndex:indexPath.row];
	
	if ([item.title isEqualToString:@"Logs"]) {
		[self.navigationController pushViewController:KTDebugNetworkController.new animated:YES];
	} else if ([item.title isEqualToString:@"Failed requests"]) {
		[self.navigationController pushViewController:KTDebugNetworkFailRequestVC.new animated:YES];
	} else if ([item.title isEqualToString:@"Missing inspection"]) {
		[self.navigationController pushViewController:KTDebugNetworkMissingInspectionVC.new animated:YES];
	} else if ([item.title isEqualToString:@"Request duration monitoring"]) {
		[self.navigationController pushViewController:KTDebugNetwrokDurationMonitorVC.new animated:YES];
	}
}

#pragma mark - action
- (void)hideDebugBall
{
	[DebugSharedManager updateDebugBallUnenabled];
}

#pragma mark - lazy load
- (UITableView *)tableView
{
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}

@end
