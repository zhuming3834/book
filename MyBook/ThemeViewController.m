//
//  ThemeViewController.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "ThemeViewController.h"
#import "BookListTableViewCell.h"
#import "AtypeBooks.h"
#import "BookChapeViewController.h"
#import "AFNetWorkingDownload.h"
#import "AbookModel.h"
#import "GetURLModel.h"
#import "BookChapeViewController.h"
#import "MBProgressHUD.h"

@interface ThemeViewController ()<UITableViewDataSource,UITableViewDelegate,AFNetWorkingDownloadDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)AbookModel *aBkkoModel;
@property (nonatomic,strong)MBProgressHUD *HUD;

@property (nonatomic,copy)NSNumber *bookID;
@property (nonatomic,copy)NSString *bookName;


@end

@implementation ThemeViewController

- (void)viewWillAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverUnknown) name:@"serverUnknown" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverUnknown) name:@"statusUnknown" object:nil];
}
- (void)serverUnknown{
	if (self.HUD != nil) {
		[self.HUD removeFromSuperview];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setMyNavigationBar];
	
	[self setTableView];
	
    // Do any additional setup after loading the view from its nib.
}
/**
 *  设置navigationBar
 */
- (void)setMyNavigationBar{
	self.navigationController.navigationBar.translucent = NO; //不透明
	self.navigationController.navigationBarHidden = NO; //不隐藏
	self.navigationItem.title = self.typeName;
	
	UIImage *im = [UIImage imageNamed:@"navigationbar"];
	im = [im stretchableImageWithLeftCapWidth:im.size.width/2 topCapHeight:im.size.height/2];
	
	[self.navigationController.navigationBar setBackgroundImage:im forBarMetrics:UIBarMetricsDefault];
}

- (void)setTableView{
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.booksArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identify = @"BookList1";
	BookListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identify];
	if (cell == nil) {
		cell = [[BookListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
	}
	AtypeBooks *bks = (AtypeBooks *)self.booksArr[indexPath.row];
	[cell setBookListCellWith:bks];
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	AtypeBooks *bks = (AtypeBooks *)self.booksArr[indexPath.row];
	self.bookID = bks.id;
	[self startDownloadWithURLString:[self getAbookURLStringWithID:[NSString stringWithFormat:@"%@",self.bookID]] identity:@"1"];
	[self setShowHUD];
}


- (void)setShowHUD{
	self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
	
	self.HUD.labelText = @"Loading";
	[self.HUD show:YES];
}

/**
 *  获取一本书的URLString
 *
 *  @return 返回需要的URLString
 */
- (NSString *)getAbookURLStringWithID:(NSString *)bookID{
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
- (void)getDownloadData:(NSData *)recData withAFNetWorking:(id)AFNetWorking{
	AFNetWorkingDownload * download = (AFNetWorkingDownload *)AFNetWorking;
	NSDictionary *dice = [NSJSONSerialization JSONObjectWithData:recData options:NSJSONReadingMutableContainers error:nil];
	
	if ([download.identity isEqualToString:@"1"]) {
		NSNumber * ret_code = dice[@"showapi_res_body"][@"ret_code"];
		if ([ret_code isEqualToNumber:@0]) { //数据加载成功
			[self.HUD removeFromSuperview];
			self.aBkkoModel = [AbookModel  setAbookModelWithDictionary:dice];
			BookChapeViewController *bVC = [[BookChapeViewController alloc] init];
			bVC.bookModel = self.aBkkoModel;
			
			[[NSUserDefaults standardUserDefaults] setObject:self.aBkkoModel.name forKey:@"bookName"];
			[[NSUserDefaults standardUserDefaults] setObject:self.aBkkoModel.id forKey:@"bookID"];
			
			[self.navigationController pushViewController:bVC animated:YES];
		}
		else{ //数据加载失败 重新加载 直到加载成功为止
			[self startDownloadWithURLString:[self getAbookURLStringWithID:[NSString stringWithFormat:@"%@",self.bookID]] identity:@"1"];
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
