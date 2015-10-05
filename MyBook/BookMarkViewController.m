//
//  BookMarkViewController.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "BookMarkViewController.h"
#import "BookReadViewController.h"
#import "AFNetWorkingDownload.h"
#import "CoreDataModel.h"
#import "MBProgressHUD.h"
#import "GetURLModel.h"
#import "SetInfo.h"

@interface BookMarkViewController ()<UITableViewDelegate,UITableViewDataSource,AFNetWorkingDownloadDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *bookMarkArr;
@property (nonatomic,copy)NSString *chapID;
@property (nonatomic,copy)NSString *chapName;
@property (nonatomic,retain)NSArray *backImageArr;

@property (nonatomic,strong)NSPersistentStoreCoordinator * coor;
@property (nonatomic,strong)NSManagedObjectContext * context;
@property (nonatomic,strong)NSPersistentStore * store;
@property (nonatomic,strong)NSPersistentStore * store1;
@property (nonatomic,strong)MBProgressHUD *HUD;

@end

@implementation BookMarkViewController

- (void)viewWillAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverUnknown) name:@"serverUnknown" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverUnknown) name:@"statusUnknown" object:nil];
	self.bookMarkArr = [[NSMutableArray alloc] init];

	[self getSqliteData];
	[self getSqliteData1];
	
	[self setMainView];
	[self.tableView reloadData];
}
- (void)serverUnknown{
	if (self.HUD != nil) {
		[self.HUD removeFromSuperview];
	}
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	[self setMyNavigationBar];
	
	[self setMainView];
    // Do any additional setup after loading the view from its nib.
}

- (void)getSqliteData{
	
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"BookMark" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	self.coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString * dbPath = [NSString stringWithFormat:@"%@/Documents/bookMark.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	self.store = [self.coor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	//制作一个操作对象
	self.context = [[NSManagedObjectContext alloc] init];
	self.context.persistentStoreCoordinator = self.coor;
	
	//创建一个查询  返回结果的对象
	NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"BookMark"];
	//获取sqlite里面的所有对象 相当于是查询
	NSArray *temp = [self.context executeFetchRequest:request error:nil];
	self.bookMarkArr = [[NSMutableArray alloc] initWithArray:temp];
	[self.context save:nil];  //回写
}

- (void)getSqliteData1{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"SetInfo" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	NSPersistentStoreCoordinator * coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString * dbPath = [NSString stringWithFormat:@"%@/Documents/setInfo.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	self.store1 = [coor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	//制作一个操作对象
	NSManagedObjectContext * context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = coor;
	
	//创建一个查询  返回结果的对象
	NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"SetInfo"];
	//获取sqlite里面的所有对象 相当于是查询
	NSArray *temp = [context executeFetchRequest:request error:nil];
	SetInfo *set = (SetInfo *)temp[0];
	NSString *bookMarkBackNum = set.bookMarkBackNum;
	self.backImageArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"backImage"];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.backImageArr[bookMarkBackNum.integerValue]]];
	[context save:nil];  //回写
}


/**
 *  设置navigationBar
 */
- (void)setMyNavigationBar{
	self.navigationItem.title = @"书签页";
	self.navigationController.navigationBar.translucent = NO; //不透明
	self.navigationController.navigationBarHidden = NO; //不隐藏
	
	UIImage *im = [UIImage imageNamed:@"navigationbar"];
	im = [im stretchableImageWithLeftCapWidth:im.size.width/2 topCapHeight:im.size.height/2];
	
	[self.navigationController.navigationBar setBackgroundImage:im forBarMetrics:UIBarMetricsDefault];
}

- (void)setMainView{
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.bookMarkArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identify = @"bookCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
	}
	BookMark *bk = self.bookMarkArr[indexPath.row];
	cell.textLabel.text = bk.bookName;
	cell.detailTextLabel.text = bk.chanpteName;
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		//		[self createCoreDataModel];
		NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"BookMark"];
		//获取sqlite里面的所有对象 相当于是查询
		NSArray * dataArr = [self.context executeFetchRequest:request error:nil];
		[self.context deleteObject:dataArr[indexPath.row]]; //删除一条数据
		[self.context save:nil];  //回写
		
		[self.tableView reloadData];
		
		[self.bookMarkArr removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	BookMark *bk = self.bookMarkArr[indexPath.row];
	self.chapID = bk.bookDetailID;
	self.chapName = bk.chanpteName;
	
	[self startDownloadWithURLString:[self getAchaperWithID:self.chapID] identity:@"1"];
	
	[self setShowHUD];
}
- (void)setShowHUD{
	self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
	
	self.HUD.labelText = @"Loading";
	[self.HUD show:YES];
}

- (NSString *)getAchaperWithID:(NSString *)chapID{
	GetURLModel *model = [[GetURLModel alloc] init];
	NSString *chapStr = [model getAchapterUrlStrWithchapterID:chapID];
	return chapStr;
}

/**
 *  开始下载数据
 *
 *  @param URLString 下载需要的URLString
 *  @param identity  identity
 */
- (void)startDownloadWithURLString:(NSString *)URLString identity:(NSString *)identity{
	AFNetWorkingDownload *afNet = [[AFNetWorkingDownload alloc] init];
	afNet.identity = identity;
	afNet.delegate = self;
	[afNet downloadDataFromURLString:URLString];
}

- (void)getDownloadData:(NSData *)recData withAFNetWorking:(id)AFNetWorking{
	NSDictionary *dice = [NSJSONSerialization JSONObjectWithData:recData options:NSJSONReadingMutableContainers error:nil];
	
	NSDictionary *dic = dice[@"showapi_res_body"][@"bookDetails"];
	
	[self.HUD removeFromSuperview];
	
	BookReadViewController *bVC = [[BookReadViewController alloc] init];
	bVC.message = dic[@"message"];
	bVC.titleMeg = self.chapName;
	bVC.isMark = NO;
	bVC.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:bVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
