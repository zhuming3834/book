//
//  SearchViewController.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "SearchViewController.h"
#import "BookChapeViewController.h"
#import "AFNetWorkingDownload.h"
#import "BookListTableViewCell.h"
#import "MBProgressHUD.h"
#import "GetURLModel.h"
#import "SearchBookModel.h"
#import "AbookModel.h"


@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,AFNetWorkingDownloadDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)SearchBookModel *searchBookModel;
@property (nonatomic,strong)MBProgressHUD *HUD;

@property (nonatomic,copy)NSArray *booksArr;
@property (nonatomic,assign)NSInteger rowNum;

@end

@implementation SearchViewController

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
	
	[self setShowHUD];
	
	NSArray *temp =  @[@"你",@"我",@"他",@"宝宝",@"健康",@"一",@"家",@"美食",@"食"];
	NSInteger num = arc4random()%(temp.count);
	
	[self startDownloadWithURLString:[self getSearchURLStringWithKeyword:temp[num]] identity:@"1"];
	
	[self setMyNavigationBar];
	
	[self setMainView];
	
    // Do any additional setup after loading the view.
}

/**
 *  设置navigationBar
 */
- (void)setMyNavigationBar{
	self.navigationController.navigationBar.translucent = NO; //不透明
	self.navigationController.navigationBarHidden = NO; //不隐藏
	self.navigationItem.title = @"搜索页";
	UIImage *im = [UIImage imageNamed:@"navigationbar"];
	im = [im stretchableImageWithLeftCapWidth:im.size.width/2 topCapHeight:im.size.height/2];
		
	[self.navigationController.navigationBar setBackgroundImage:im forBarMetrics:UIBarMetricsDefault];
}

- (void)setMainView{
	self.searchBar.placeholder = @"千本图书免费看";
	self.searchBar.delegate = self;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.tableHeaderView = self.searchBar;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
	return YES;
}// return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	self.searchBar.showsCancelButton = YES;
	for (id cc in [searchBar.subviews[0] subviews]) {
		if ([cc isKindOfClass:[UIButton class]]) {
			UIButton * cancelButton = (UIButton *)cc;
			[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
		}
	}
}
//键盘搜索按钮按下 就会调用这个方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[self setShowHUD];
	[self startDownloadWithURLString:[self getSearchURLStringWithKeyword:searchBar.text] identity:@"1"];
	[searchBar resignFirstResponder];
}// called when keyboard search button pressed

//取消按钮按下调用这个方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
	self.searchBar.showsCancelButton = NO;
}// called when cancel button pressed

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.booksArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identify = @"Cell";
	BookListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
	if (cell == nil) {
		cell = [[BookListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
	}
	SearchBookModel *smodel = (SearchBookModel *)self.booksArr[indexPath.row];
	[cell setBookListCellWithSearchBookModel:smodel];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	SearchBookModel *smodel = (SearchBookModel *)self.booksArr[indexPath.row];
	
	[self startDownloadWithURLString:[self getAbookURLStringWithID:[NSString stringWithFormat:@"%@",smodel.id]]identity:@"2"];
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

- (NSString *)getSearchURLStringWithKeyword:(NSString *)Keyword{
	GetURLModel *model = [[GetURLModel alloc] init];
	NSString *chapStr = [model getSearchUrlStr:Keyword];
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
	AFNetWorkingDownload *download = (AFNetWorkingDownload *)AFNetWorking;
	NSString *identify = download.identity;
	
	if ([identify isEqualToString:@"1"]) {
		NSNumber * total = dice[@"showapi_res_body"][@"total"];
		//		NSLog(@"total = %@",total);
		if ([total isEqualToNumber:@0]) { //数据加载失败
			UIAlertView * errAl = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有搜索到数据，请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
			[errAl show];
			[self.HUD removeFromSuperview];
			self.searchBar.text = @""; //清空搜索栏 以输入的内容
		}
		else{ //数据加载成功
			[self.HUD removeFromSuperview];
			self.searchBookModel = [[SearchBookModel alloc] init];
			self.booksArr = [self.searchBookModel setSearchBookModelWithDictionary:dice];
			[self.tableView reloadData];
		}
	}	
	if ([identify isEqualToString:@"2"]) {
		[self.HUD removeFromSuperview];
		AbookModel *abook = [AbookModel setAbookModelWithDictionary:dice];
		
		[[NSUserDefaults standardUserDefaults] setObject:abook.name forKey:@"bookName"];
		[[NSUserDefaults standardUserDefaults] setObject:abook.id forKey:@"bookID"];
		
		BookChapeViewController *bvc = [[BookChapeViewController alloc] init];
		bvc.bookModel = abook;
		[self.navigationController pushViewController:bvc animated:YES];
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
