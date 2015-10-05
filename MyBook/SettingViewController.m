//
//  SettingViewController.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "SettingViewController.h"
#import "BackImage2ViewController.h"
#import <CoreData/CoreData.h>
#import "SetInfo.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *fontLabel;
@property (nonatomic,strong)UISlider *sliderView;

@property (nonatomic,strong)NSPersistentStore * store1;
@property (nonatomic,strong)NSPersistentStoreCoordinator * coor;
@property (nonatomic,strong)NSManagedObjectContext * context;

@property (nonatomic,copy)NSArray *titleArr;
@property (nonatomic,copy)NSArray *backImageArr;

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
	[self getSqliteData1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self getSqliteData1];
	[self setMyNavigationBar];
	
	[self setMainView];
	
	[self setFontLabel];
    // Do any additional setup after loading the view.
}

- (void)getSqliteData1{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"SetInfo" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	self.coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString * dbPath = [NSString stringWithFormat:@"%@/Documents/setInfo.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	self.store1 = [self.coor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	//制作一个操作对象
	self.context = [[NSManagedObjectContext alloc] init];
	self.context.persistentStoreCoordinator = self.coor;
	
	//创建一个查询  返回结果的对象
	NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"SetInfo"];
	//获取sqlite里面的所有对象 相当于是查询
	NSArray *temp = [self.context executeFetchRequest:request error:nil];
	SetInfo *set = (SetInfo *)temp[0];
	NSString *settingBackNum = set.settingBackNum;
	self.backImageArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"backImage"];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.backImageArr[settingBackNum.integerValue]]];
	[self.context save:nil];  //回写
}

/**
 *  设置navigationBar
 */
- (void)setMyNavigationBar{
	self.navigationItem.title = @"设置页";
	self.navigationController.navigationBar.translucent = NO; //不透明
	self.navigationController.navigationBarHidden = NO; //不隐藏
	
	UIImage *im = [UIImage imageNamed:@"navigationbar"];
	im = [im stretchableImageWithLeftCapWidth:im.size.width/2 topCapHeight:im.size.height/2];
	
	[self.navigationController.navigationBar setBackgroundImage:im forBarMetrics:UIBarMetricsDefault];
}

- (void)setMainView{
	
	self.titleArr = @[@"设置首页面背景图片",@"设置章节页面背景图片",@"设置书签页面背景图片",@"设置读书页面背景图片",@"设置设置页面背景图片",];
	
	self.tableView = [[UITableView alloc] init];
	self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
	self.tableView.bounces = NO;
	self.tableView.scrollEnabled = NO;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identify = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
	}
	cell.textLabel.text = self.titleArr[indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
	[[NSUserDefaults standardUserDefaults] setObject:row forKey:@"cellRow"];
	BackImage2ViewController *bvc = [[BackImage2ViewController alloc] init];
	bvc.cellRow = indexPath.row;
	bvc.navTitle = self.titleArr[indexPath.row];
	[self.navigationController pushViewController:bvc animated:YES];
}

- (void)setFontLabel{
	
	//获取字体大小
	//创建一个查询  返回结果的对象
	NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"SetInfo"];
	//获取sqlite里面的所有对象 相当于是查询
	NSArray *temp = [self.context executeFetchRequest:request error:nil];
	SetInfo *set = (SetInfo *)temp[0];
	NSString *fontStr = set.fontSize;
	[self.context save:nil];  //回写
	
	self.fontLabel = [[UILabel alloc] init];
	self.fontLabel.frame = CGRectMake(0, 255, 200, 50);
	self.fontLabel.text = [NSString stringWithFormat:@"   设置读书页字体大小  %@",fontStr];
	self.fontLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.fontLabel];
	
	self.sliderView = [[UISlider alloc] init];
	self.sliderView.frame = CGRectMake(202, 255, 100, 50);
	self.sliderView.minimumValue = 0;
	self.sliderView.maximumValue = 30;
	self.sliderView.value = fontStr.intValue;
	self.sliderView.backgroundColor = [UIColor clearColor];
	[self.sliderView setThumbImage:[UIImage imageNamed:@"scrubslider_btn@2x.png"] forState:UIControlStateNormal];
	
	[self.sliderView addTarget:self action:@selector(moveSlider) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.sliderView];
}

- (void)moveSlider{
	
	float fontSlider = self.sliderView.value + 1;
	NSString *fontStr = [NSString stringWithFormat:@"%f",fontSlider];
	NSArray *strArr = [fontStr componentsSeparatedByString:@"."];
	fontStr = strArr[0];
	//修改字体大小
	//创建一个查询  返回结果的对象
	NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"SetInfo"];
	//获取sqlite里面的所有对象 相当于是查询
	NSArray *temp = [self.context executeFetchRequest:request error:nil];
	SetInfo *set = (SetInfo *)temp[0];
	set.fontSize = fontStr;
	[self.context save:nil];  //回写
	
	self.fontLabel.text = [NSString stringWithFormat:@"   设置读书页字体大小  %@",fontStr];
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
