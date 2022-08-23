//
//  KTDebugNetworkMissingInspectionVC.m
//  AAChartKit
//
//  Created by KOTU on 2022/8/22.
//

#import "KTDebugNetworkMissingInspectionVC.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import "KTHttpDocModel.h"
#import "KTDebugBallUtils.h"
#import "KTDebugManager.h"

static NSArray <KTHttpDocListModel *> *filteredDocModels;

@interface KTDebugNetworkMissingInspectionVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) NSArray <KTHttpDocListModel *> *docModels;

@end

@implementation KTDebugNetworkMissingInspectionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	[self.view addSubview:self.tableView];
	[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(0);
	}];
	
	[self.view addSubview:self.indicatorView];
	[self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.mas_equalTo(0);
	}];
	
	if (filteredDocModels.count) {
		[self.indicatorView startAnimating];
		[self loadDatas];
		[self.tableView reloadData];
		[self.indicatorView stopAnimating];
	} else if (DebugSharedManager.networkUtils &&
			   [DebugSharedManager.networkUtils respondsToSelector:@selector(apiJsonFileUrl)] &&
			   [DebugSharedManager.networkUtils apiJsonFileUrl]) {
		[self loadApiJson];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (filteredDocModels.count) {
		[self.indicatorView startAnimating];
		[self loadDatas];
		[self.tableView reloadData];
		[self.indicatorView stopAnimating];
	}
}

- (void)loadApiJson
{
	[self.indicatorView startAnimating];
	__weak typeof(self) weakSelf = self;
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	[manager GET:[DebugSharedManager.networkUtils apiJsonFileUrl]
	  parameters:nil
		 headers:nil
		progress:nil
		 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			NSString *content = responseObject[@"content"];
			NSData *data = [[NSData alloc] initWithBase64EncodedString:content options:0];
	
			NSArray *list = [NSJSONSerialization JSONObjectWithData:data
																 options:NSJSONReadingMutableContainers
																   error:nil];
			weakSelf.docModels = [NSArray yy_modelArrayWithClass:[KTHttpDocListModel class] json:list];
			[weakSelf filterDocModels];
			[weakSelf loadDatas];
			[weakSelf.indicatorView stopAnimating];
			[weakSelf.tableView reloadData];
	}
		 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			[weakSelf.indicatorView stopAnimating];
		}];
}

- (void)filterDocModels
{
	if (DebugSharedManager.networkUtils &&
		[DebugSharedManager.networkUtils respondsToSelector:@selector(filterDocModels:)]) {
		filteredDocModels = [DebugSharedManager.networkUtils filterDocModels:self.docModels];
	} else {
		filteredDocModels = self.docModels;
	}
}

- (void)loadDatas
{
	NSArray *array = [NSArray arrayWithArray:DebugSharedManager.requests];
	
	NSMutableSet *urlSet = [NSMutableSet set];
	for (KTHttpLogModel *model in array) {
		[urlSet addObject:model.url];
	}
	
	NSMutableSet *pathSet = [NSMutableSet set];
	for (NSString *url in urlSet.allObjects) {
		NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
		[pathSet addObject:components.path];
	}
	
	for (KTHttpDocListModel *model in filteredDocModels) {
		for (KTHttpDocRequestModel *rm in model.list) {
			NSString *path;
			if (DebugSharedManager.networkUtils &&
				[DebugSharedManager.networkUtils respondsToSelector:@selector(apiBasicPath)] &&
				[DebugSharedManager.networkUtils apiBasicPath]) {
				path = [NSString stringWithFormat:@"%@%@", [DebugSharedManager.networkUtils apiBasicPath], rm.path];
			} else {
				path = rm.path;
			}
			
			if ([pathSet containsObject:path]) {
				rm.checked = YES;
			}
		}
	}
}

#pragma mark - gesture
- (void)tapHeaderView:(UIGestureRecognizer *)ges
{
	UIView *view = ges.view;
	NSInteger index = view.tag - 10000;
	KTHttpDocListModel *model = filteredDocModels[index];
	model.isOpen = !model.isOpen;
	[self.tableView reloadData];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return filteredDocModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	KTHttpDocListModel *model = filteredDocModels[section];
	if (!model.isOpen) {
		return 0;
	}
	return model.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
	view.tag = 10000+section;
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 60)];
	[view addSubview:label];
	[label mas_updateConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(20);
		make.trailing.mas_equalTo(-60);
		make.centerY.mas_equalTo(0);
	}];
	
	UIImageView *imageView = [[UIImageView alloc] init];
	[view addSubview:imageView];
	[imageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(20);
		make.trailing.mas_equalTo(-22);
		make.centerY.mas_equalTo(0);
	}];
	
	UIView *separatorView = UIView.new;
	[view addSubview:separatorView];
	separatorView.backgroundColor = [UIColor colorWithRed:243/255.f green:243/255.f blue:243/255.f alpha:1];
	[separatorView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.bottom.mas_equalTo(0);
		make.height.mas_equalTo(1);
	}];
	
	KTHttpDocListModel *model = filteredDocModels[section];
	label.text = model.name;
		
	if (!model.isOpen) {
		imageView.image = DebugBallImageWithNamed(@"console_arrow_fold");
	} else {
		imageView.image = DebugBallImageWithNamed(@"console_arrow_unfold");
	}

	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView:)];
	[view addGestureRecognizer:tap];
	
	return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
		cell.textLabel.textColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
		cell.detailTextLabel.textColor = [UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1];
	}
	
	KTHttpDocListModel *model = filteredDocModels[indexPath.section];
	KTHttpDocRequestModel *rm = model.list[indexPath.row];
	
	cell.textLabel.text = rm.title;
	cell.detailTextLabel.text = rm.path;
	if (rm.checked) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

#pragma mark - lazyload
- (UITableView *)tableView
{
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.backgroundColor = [UIColor whiteColor];
	}
	return _tableView;
}

- (UIActivityIndicatorView *)indicatorView
{
	if (!_indicatorView) {
		_indicatorView = UIActivityIndicatorView.new;
	}
	return _indicatorView;
}

@end
