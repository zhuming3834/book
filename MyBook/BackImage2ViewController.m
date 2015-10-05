//
//  BackImage2ViewController.m
//  MyBook
//
//  Created by qf on 15/9/30.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "BackImage2ViewController.h"
#import "SettingTableViewCell.h"

@interface BackImage2ViewController ()<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic,strong)UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,retain)NSArray *imageArr;

@end

@implementation BackImage2ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setUserDefaultData];
	
	[self setMyNavigationBar];
	
	[self setMainView];
	
	// Do any additional setup after loading the view from its nib.
}

- (void)setUserDefaultData{
	NSMutableArray *backImageArr = [[NSMutableArray alloc] init];
	for (int i = 0; i < 24; i ++) {
		NSString *nameStr = [NSString stringWithFormat:@"bg%d.png",i];
		[backImageArr addObject:nameStr];
	}
	[[NSUserDefaults standardUserDefaults] setObject:backImageArr forKey:@"backImage"];
	
	self.imageArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"backImage"];
}
/**
 *  设置navigationBar
 */
- (void)setMyNavigationBar{
	self.navigationItem.title = self.navTitle;
}
- (void)setMainView{
//	NSLog(@"%@",self.test);
	//	self.tableView = [[UITableView alloc] init];
	//	self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - 64);
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	//	[self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identify = @"setcell";
	SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
	if (cell == nil) {
		cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
	}
	cell.rightButton.tag = indexPath.row;
	[cell setCellWithImageName:self.imageArr[indexPath.row]];
	return cell;
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
