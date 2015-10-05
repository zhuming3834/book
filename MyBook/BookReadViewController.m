//
//  BookReadViewController.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "BookReadViewController.h"
#import "BookDetailModel.h"
#import "CoreDataModel.h"
#import "SetInfo.h"


@interface BookReadViewController ()

@property (weak, nonatomic) IBOutlet UITextView *readTextView;

@property (nonatomic,assign)BOOL isClick;

@property (nonatomic,strong)NSPersistentStoreCoordinator * coor;
@property (nonatomic,strong)NSManagedObjectContext * context;
@property (nonatomic,strong)NSPersistentStore * store;
@property (nonatomic,strong)NSPersistentStore * store1;

@property (nonatomic,assign)NSInteger backNum;
@property (nonatomic,assign)CGFloat fontSize;
@property (nonatomic,copy)NSArray *backImageArr;

@end

@implementation BookReadViewController

@synthesize title;

- (void)viewWillAppear:(BOOL)animated{
	[self getSqliteData];
	[self getUserData];
	[self setReadTextView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setMyNavigationBar];
	
//	[self setReadTextView];
	
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated{
	[self.readTextView removeFromSuperview];
}
- (void)getSqliteData{
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
	self.fontSize = set.fontSize.floatValue;
	//	NSLog(@"self.fontSize = %f",self.fontSize);
	self.backNum = set.readBackNum.intValue;
	[context save:nil];  //回写
}
- (void)getUserData{
	self.backImageArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"backImage"];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.backImageArr[self.backNum]]];
}

/**
 *  设置navigationBar
 */
- (void)setMyNavigationBar{
	self.navigationController.navigationBar.translucent = NO; //不透明
	self.navigationController.navigationBarHidden = NO; //不隐藏
	self.navigationItem.title = self.titleMeg;
	
	if (self.isMark == YES) {
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightButtonClick)];
		self.navigationItem.rightBarButtonItem = rightButton;
	}
}
- (void)rightButtonClick{
	if (self.isClick == NO) {
		self.isClick = YES;
		NSString *bookName = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookName"];
//		NSLog(@"name = %@",bookName);
		NSString *bookID = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookID"];
		NSString *chapName = [[NSUserDefaults standardUserDefaults] objectForKey:@"chapName"];
		NSString *chapID = [[NSUserDefaults standardUserDefaults] objectForKey:@"chapID"];
		
		CoreDataModel *model = [[CoreDataModel alloc] init];
		[model insterCoreDataBookMarkWithBookName:bookName chapeName:chapName bookID:[NSString stringWithFormat:@"%@",bookID] bookDetailID:chapID];
		
		UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"书签添加成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
		[al show];
	}
	else{
		UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"书签已经存在" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
		
		[al show];
	}
	
}

- (void)setReadTextView{
	self.readTextView.editable = NO;
	self.readTextView.backgroundColor = [UIColor clearColor];
	self.readTextView.font = [UIFont systemFontOfSize:self.fontSize];
	
	NSString * message =self.message;
	NSString * subStr = [message substringFromIndex:2];
	//去除文章里面的 <p> </p> &nbsp  <div>  </p> \n <p>  </p> \n <p></p> \n
	subStr = [subStr stringByReplacingOccurrencesOfString:@"\n <p></p> \n <p>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"</p> \n <p>" withString:@"\n"];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"</p> \n <p></p> \n" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"<div>;" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"&middot;" withString:@""];
	//去除文章开头的换行符
	subStr = [subStr substringFromIndex:5];
	self.readTextView.text = subStr;
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
