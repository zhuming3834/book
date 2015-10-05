//
//  SettingTableViewCell.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "SettingTableViewCell.h"
#import <CoreData/CoreData.h>
#import "SetInfo.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface SettingTableViewCell ()

@property (nonatomic,strong)NSPersistentStore * store1;
@property (nonatomic,strong)NSPersistentStoreCoordinator * coor;
@property (nonatomic,strong)NSManagedObjectContext * context;

@end

@implementation SettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:
				reuseIdentifier]) {
		[self creatCell];
	}
	return self;
}

- (void)creatCell{
	self.frame = CGRectMake(0, 0,  ScreenWidth, 120);
	
	self.backImageView = [[UIImageView alloc] init];
	self.backImageView.frame = CGRectMake(5, 5, ScreenWidth - 10, ScreenHeight - 10);
	[self addSubview:self.backImageView];
	
	self.backImageView = [[UIImageView alloc] init];
	self.backImageView.frame = CGRectMake(5, 5, ScreenWidth - 10, 110);
	[self addSubview:self.backImageView];
	
	self.leftImageView = [[UIImageView alloc] init];
	self.leftImageView.frame = CGRectMake(5, 5, 100, 110);
	[self addSubview:self.leftImageView];
	
	self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.rightButton.frame = CGRectMake(ScreenWidth - 100, 40, 80, 40);
	[self addSubview:self.rightButton];
	self.rightButton.layer.cornerRadius = 8;
	
	[self.rightButton setTitle:@"确认" forState:UIControlStateNormal];
	[self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	self.rightButton.backgroundColor = [UIColor orangeColor];
	[self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setCellWithImageName:(NSString *)imageName {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.leftImageView.image = [UIImage imageNamed:imageName];
	self.backImageView.image = [UIImage imageNamed:@"3.png"];
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
}


- (void)rightButtonClick:(UIButton *)butt{
	
	[self getSqliteData1];
	//创建一个查询  返回结果的对象
	NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"SetInfo"];
	//获取sqlite里面的所有对象 相当于是查询
	NSArray *temp = [self.context executeFetchRequest:request error:nil];
	SetInfo *setInfo = (SetInfo *)temp[0];
	
	NSString *cellRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"cellRow"];
	NSInteger row = cellRow.integerValue;
	switch (row) {
  case 0:  //首页
			setInfo.firstBackNum = [NSString stringWithFormat:@"%ld",(long)butt.tag];
			[self.context save:nil];  //回写
			break;
  case 1:  //章节页
			setInfo.chapeBackNum = [NSString stringWithFormat:@"%ld",(long)butt.tag];
			[self.context save:nil];  //回写
			break;
  case 2:   //书签页
			setInfo.bookMarkBackNum = [NSString stringWithFormat:@"%ld",(long)butt.tag];
			[self.context save:nil];  //回写
			break;
  case 3:   //读书页
			setInfo.readBackNum = [NSString stringWithFormat:@"%ld",(long)butt.tag];
			[self.context save:nil];  //回写
			break;
  case 4:   //设置页
			setInfo.settingBackNum = [NSString stringWithFormat:@"%ld",(long)butt.tag];
			[self.context save:nil];  //回写
			break;
  default:
			break;
	}
	
	UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"设置成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
	[alView show];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
