//
//  BookChapeViewController.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "BookChapeViewController.h"
#import "ChapetModel.h"
#import "BookReadViewController.h"
#import "GetURLModel.h"
#import "AFNetWorkingDownload.h"
#import "MBProgressHUD.h"
#import "SetInfo.h"

@interface BookChapeViewController ()<UITableViewDataSource,UITableViewDelegate,AFNetWorkingDownloadDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)MBProgressHUD *HUD;

@property (nonatomic,strong)NSPersistentStore * store;

@property (nonatomic,retain)NSArray *backImageArr;

@property (nonatomic,copy)NSNumber *chapID;
@property (nonatomic,copy)NSString *chapName;

@end

@implementation BookChapeViewController

- (void)viewWillAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverUnknown) name:@"serverUnknown" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverUnknown) name:@"statusUnknown" object:nil];
	[self setMyNavigationBar];
}
- (void)serverUnknown{
	if (self.HUD != nil) {
		[self.HUD removeFromSuperview];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTableView];
    // Do any additional setup after loading the view from its nib.
}
- (NSString *)getSqliteData{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"SetInfo" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	NSPersistentStoreCoordinator * coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString * dbPath = [NSString stringWithFormat:@"%@/Documents/setInfo.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	self.store = [coor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	//制作一个操作对象
	NSManagedObjectContext * context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = coor;
	
	//创建一个查询  返回结果的对象
	NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"SetInfo"];
	//获取sqlite里面的所有对象 相当于是查询
	NSArray *temp = [context executeFetchRequest:request error:nil];
	SetInfo *set = (SetInfo *)temp[0];
	NSString *chapeBackNum = set.chapeBackNum;
	[context save:nil];  //回写
	return chapeBackNum;
}

/**
 *  设置navigationBar
 */
- (void)setMyNavigationBar{
	self.navigationController.navigationBar.translucent = NO; //不透明
	self.navigationController.navigationBarHidden = NO; //不隐藏
	self.navigationItem.title = self.bookModel.name;
	
	NSString *n = [self getSqliteData];
	self.backImageArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"backImage"];
	NSString *backImage = self.backImageArr[n.intValue];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backImage]];
	
}
- (void)setTableView{
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identify = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
	if (cell == nil) {
		cell  =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
	}
	ChapetModel *cmodel = (ChapetModel *)self.bookModel.list[indexPath.row];
	cell.textLabel.text = cmodel.title;
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	ChapetModel *cmodel = (ChapetModel *)self.bookModel.list[indexPath.row];
	self.chapID = cmodel.id;
	self.chapName = cmodel.title;
	
	[self startDownloadWithURLString:[self getAchaperWithID:[NSString stringWithFormat:@"%@",self.chapID]] identity:@"1"];
	
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
	bVC.isMark = YES;
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.chapID] forKey:@"chapID"];
	[[NSUserDefaults standardUserDefaults] setObject:self.chapName forKey:@"chapName"];
	
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
