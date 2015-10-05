//
//  FirstViewController.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "FirstViewController.h"
#import "AFNetWorkingDownload.h"
#import "GetURLModel.h"
#import "AbookModel.h"
#import "ChapetModel.h"
#import "BookClassfy.h"
#import "ThemeTableViewCell.h"
#import "MBProgressHUD.h"
#import "AtypeBooks.h"
#import "ThemeViewController.h"
#import "BookChapeViewController.h"
#import "CoreDataModel.h"
#import "SetInfo.h"

#define BACKCOLOR  @"bg22.png"
#define ARC_NUM    [NSString stringWithFormat:@"%u",arc4random()%

@interface FirstViewController ()<AFNetWorkingDownloadDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UILabel *jpLabel;
@property (nonatomic,strong)UIImageView * photoView;
@property (nonatomic,strong)UITextView * summaryTextView;
@property (nonatomic,strong)UIButton * currentButton;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UITapGestureRecognizer * tap;
@property (nonatomic,strong)UIButton * swipButton;
@property (nonatomic,strong)UIActivityIndicatorView * myAct;
@property (nonatomic,strong)AbookModel *aBkkoModel;
@property (nonatomic,strong)MBProgressHUD *HUD;
@property (nonatomic,strong)NSPersistentStore * store;



@property (nonatomic,copy)NSArray *booksArr;
@property (nonatomic,copy)NSArray *typeArray;
@property (nonatomic,copy)NSDictionary *dataDice;
@property (nonatomic,assign)BOOL flag;
@property (nonatomic,assign)NSInteger rowNum;
@property (nonatomic,copy)NSString *typeNamee;
@property (nonatomic,copy)NSNumber *bookID;
@property (nonatomic,strong)NSMutableArray *backImageArr;


@end

@implementation FirstViewController

- (void)viewWillAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverUnknown) name:@"serverUnknown" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverUnknown) name:@"statusUnknown" object:nil];
	//statusUnknown
	[self startDownloadWithURLString:[self getBookTypeURLString] identity:@"2"];
//	[self startDownloadWithURLString:[self getAbookURLString] identity:@"1"];

	self.navigationController.navigationBarHidden = YES;
	[self setUserDefaultData];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.backImageArr[[self getSqliteData].integerValue]]];
}
- (void)serverUnknown{
	if (self.HUD != nil) {
		[self.HUD removeFromSuperview];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self startDownloadWithURLString:[self getAbookURLString] identity:@"1"];
//	[self startDownloadWithURLString:[self getBookTypeURLString] identity:@"2"];
	
	[self setBackgroundColor];
	
	[self setMainView];
	[self setLeftSwipGestureRecognizer];
	[self setRightSwipGestureRecognizer];
	
	[self setLeftView];
	[self setSwipButton];
	
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
	NSString *firstBackNum = set.firstBackNum;
	[context save:nil];  //回写
	return firstBackNum;
}

- (void)setUserDefaultData{
	self.backImageArr = [[NSMutableArray alloc] init];
	for (int i = 0; i < 24; i ++) {
		NSString *nameStr = [NSString stringWithFormat:@"bg%d.png",i];
		[self.backImageArr addObject:nameStr];
	}
	[[NSUserDefaults standardUserDefaults] setObject:self.backImageArr forKey:@"backImage"];
}
/**
 *  设置self.view的背景图片
 */
- (void)setBackgroundColor{
	self.navigationItem.title = @"首页";
}

- (void)setMainView{
	
	self.jpLabel = [[UILabel alloc] init];
	self.jpLabel.frame = CGRectMake1(80, 90, 160, 50);
	self.jpLabel.text = @"每日推荐";
	self.jpLabel.textAlignment = NSTextAlignmentCenter;
	self.jpLabel.font = [UIFont systemFontOfSize:30];
	[self.view addSubview:self.jpLabel];
	
	self.photoView = [[UIImageView alloc] init];
	self.photoView.frame = CGRectMake1(80, 140, 160, 180);
//	self.photoView.backgroundColor = [UIColor orangeColor];
	self.photoView.userInteractionEnabled = YES;
	[self.view addSubview:self.photoView];
	
	self.summaryTextView = [[UITextView alloc] init];
	self.summaryTextView.frame = CGRectMake1(60, 325, 200, 140);
	self.summaryTextView.font = [UIFont systemFontOfSize:13];
	self.summaryTextView.showsVerticalScrollIndicator = NO;
	self.summaryTextView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.summaryTextView];
}

- (void)currentButtonClick{
	BookChapeViewController *bVC = [[BookChapeViewController alloc] init];
	bVC.bookModel = self.aBkkoModel;
	[self.navigationController pushViewController:bVC animated:YES];
}
- (void)setLeftView{
	self.tableView = [[UITableView alloc] init];
	self.tableView.frame = CGRectMake(-180, 20, 180, self.view.frame.size.height - 49);
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"theme2.png"]];
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.bounces = NO;
	self.tableView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:self.tableView];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"ThemeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ThemeCell"];
	
	UILabel *tuijian = [[UILabel alloc] init];
	tuijian.frame = CGRectMake(0, 0, 180, 44);
	tuijian.text = @"书籍分类";
	tuijian.textAlignment = NSTextAlignmentCenter;
	self.tableView.tableHeaderView = tuijian;
}
/**
 *  设置左侧边显示按钮的箭头
 */
- (void)setSwipButton{
	self.swipButton = [[UIButton alloc] init];
	self.swipButton.frame = CGRectMake(0, 300, 15, 60);
	[self.swipButton setImage:[UIImage imageNamed:@"swipL@2x.png"] forState:UIControlStateNormal];
	self.swipButton.selected = NO;
	[self.swipButton addTarget:self action:@selector(changeDirection) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.swipButton];
}
- (void)changeDirection{
	self.swipButton.selected = !self.swipButton.selected;
	if (self.swipButton.selected) {
		[self rightHandleSwipes];//弹出
	}
	else{
		[self leftHandleSwipes]; //收起
	}
}
/**
 *  设置左边滑动手势  增加滑动事件
 */
- (void)setLeftSwipGestureRecognizer{
	UISwipeGestureRecognizer * leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipes)];
	leftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:leftGestureRecognizer];
}
/**
 *  实现左滑手势 事件
 */
- (void)leftHandleSwipes{
	[UIView animateWithDuration:0.25 animations:^{
		self.tableView.frame = CGRectMake(-180, 20, 180, self.view.frame.size.height - 49);
		self.swipButton.frame = CGRectMake(0, 300, 15, 60);
		
	}];
	
	//改变按钮箭头方向
	[self.swipButton setImage:[UIImage imageNamed:@"swipL@2x.png"] forState:UIControlStateNormal];
	//开启图片按钮用户交互
	self.currentButton.userInteractionEnabled = YES;
	self.flag = NO;
}
/**
 *  设置右滑动手势  增加手势事件
 */
- (void)setRightSwipGestureRecognizer{
	UISwipeGestureRecognizer * rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandleSwipes)];
	rightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:rightGestureRecognizer];
}
/**
 *  实现右滑手势 事件
 */
- (void)rightHandleSwipes{
	
	[UIView animateWithDuration:0.25 animations:^{
		self.tableView.frame = CGRectMake(0, 20, 180, self.view.frame.size.height - 49);
		self.swipButton.frame = CGRectMake(180, 300, 15, 60);
		
	}];
	//改变按钮箭头方向
	[self.swipButton setImage:[UIImage imageNamed:@"swipR@2x.png"] forState:UIControlStateNormal];
	//开启图片按钮用户交互
	self.currentButton.userInteractionEnabled = NO;
	self.flag = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.typeArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return (self.tableView.frame.size.height - 60)/self.typeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identify = @"ThemeCell";
	ThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"ThemeTableViewCell" owner:self options:nil] firstObject];
	}
	[cell setTypeLabelTextWith:self.typeArray[indexPath.row]];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	self.rowNum = indexPath.row;
	BookClassfy *bk = (BookClassfy *)self.typeArray[indexPath.row];
	self.typeNamee = bk.name;
	[self startDownloadWithURLString:[self getAtypeBooksURLStringWithTypeID:bk.id] identity:@"3"];
	[self setShowHUD];
}

- (void)setShowHUD{
	self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
	
	self.HUD.labelText = @"Loading";
	[self.HUD show:YES];
}

- (NSString *)getAtypeBooksURLStringWithTypeID:(NSString *)typeID{
	GetURLModel *urlModel = [[GetURLModel alloc] init];
	NSString *firstStr = [urlModel getATypeBookSUrlStrWithTypeID:typeID];
	return firstStr;
}

/**
 *  获取图书分类的URLString
 *
 *  @return 返回需要的URLString
 */
- (NSString *)getBookTypeURLString{
	GetURLModel *urlModel = [[GetURLModel alloc] init];
	NSString *firstStr = [urlModel getTypesUrlStr];
	return firstStr;
}
/**
 *  获取一本书的URLString
 *
 *  @return 返回需要的URLString
 */
- (NSString *)getAbookURLString{
	NSString *bookID = [NSString stringWithFormat:@"%u",arc4random()%2000];
	GetURLModel *urlModel = [[GetURLModel alloc] init];
	NSString *firstStr = [urlModel getABookUrlStrWithBookID:bookID];
	return firstStr;
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

/**
 *  获取到下载的数据后,加载数据并显示
 *
 *  @param dice 下载后的数据解析后的字典
 */
- (void)loadDataWithBookModel:(AbookModel *)aBookModel{
	[[NSUserDefaults standardUserDefaults] setObject:aBookModel.name forKey:@"bookName"];
	[[NSUserDefaults standardUserDefaults] setObject:aBookModel.id forKey:@"bookID"];
	
	NSString * imageStr = aBookModel.img;  //load-image.png
	[self.photoView setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"load-image.png"]];
	self.photoView.userInteractionEnabled = YES; //开启图片的用户交互
	
	NSString * autherStr = aBookModel.author;
	NSString * summaryStr = aBookModel.summary;
	summaryStr = [summaryStr stringByReplacingOccurrencesOfString:@"&#" withString:@""];
	//summary开头存在一个 "\r\n"需要剔除掉
	NSString * subStr = [summaryStr substringFromIndex:2];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"&#" withString:@""];
	NSString * textStr = [NSString stringWithFormat:@"作者：%@\n%@",autherStr,subStr];
	//summary.txt
	
	CoreDataModel *core = [[CoreDataModel alloc] init];
	NSString *summary = [core getSummaryModell];
//	NSLog(@"summary = %@",summary);
	if ([summary isEqualToString:textStr]) {
		self.summaryTextView.text = summary;
	}
	else{
		self.summaryTextView.text = textStr;
		[core modeifySummaryModell:textStr];
	}
	//数据加载成功就增加一个一个按钮点击可以进入详情页
	//先移除当前的按钮
	[self.currentButton removeFromSuperview];
	//设置一个按钮并添加点击事件
	UIButton * butt = [[UIButton alloc] initWithFrame:self.photoView.frame];
	butt.backgroundColor = [UIColor clearColor];
	[butt addTarget:self action:@selector(currentButtonClick) forControlEvents:UIControlEventTouchUpInside];
	self.currentButton = butt; //重新给 self.currentButton赋值
	[self.view addSubview:butt];
}


- (void)getDownloadData:(NSData *)recData withAFNetWorking:(id)AFNetWorking{
	
	AFNetWorkingDownload * download = (AFNetWorkingDownload *)AFNetWorking;
	NSDictionary *dice = [NSJSONSerialization JSONObjectWithData:recData options:NSJSONReadingMutableContainers error:nil];
	
//获取首页显示内容
	if ([download.identity isEqualToString:@"1"]) {
		NSNumber * ret_code = dice[@"showapi_res_body"][@"ret_code"];
		if ([ret_code isEqualToNumber:@0]) { //数据加载成功
			self.aBkkoModel = [AbookModel  setAbookModelWithDictionary:dice];
			[self loadDataWithBookModel:self.aBkkoModel];
		}
		else{ //数据加载失败 重新加载 直到加载成功为止
			[self startDownloadWithURLString:[self getAbookURLString] identity:@"1"];
		}
	}
//获取图书类别
	if ([download.identity isEqualToString:@"2"]) {
		NSNumber * ret_code = dice[@"showapi_res_body"][@"ret_code"];
		if ([ret_code isEqualToNumber:@0]) { //数据加载成功
			
			BookClassfy *bk = [[BookClassfy alloc] init];
			self.typeArray = [bk setBookClassfyWith:dice];
			[self.tableView reloadData];
		}
		else{ //数据加载失败 重新加载 直到加载成功为止
			[self startDownloadWithURLString:[self getBookTypeURLString] identity:@"2"];
		}
	}
//获取一类图书
	if ([download.identity isEqualToString:@"3"]) {
		NSNumber * ret_code = dice[@"showapi_res_body"][@"ret_code"];
		if ([ret_code isEqualToNumber:@0]) { //下载成功
			[self.HUD removeFromSuperview];
			AtypeBooks *bks = [[AtypeBooks alloc] init];
			self.booksArr = [bks setAtypeBooksModelWithDictionary:dice];
			
			ThemeViewController *tVC = [[ThemeViewController alloc] init];
			tVC.booksArr = self.booksArr;
			tVC.typeName = self.typeNamee;
			[self.navigationController pushViewController:tVC animated:YES];
			[self performSelector:@selector(leftHandleSwipes) withObject:nil afterDelay:1];
		}
		else{  //下载失败
			
			[self startDownloadWithURLString:[self getAtypeBooksURLStringWithTypeID:[NSString stringWithFormat:@"%ld",(long)self.rowNum]] identity:@"3"];
		}
	}
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
