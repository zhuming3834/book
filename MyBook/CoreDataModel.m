//
//  CoreDataModel.m
//  MyBook
//
//  Created by qf on 15/9/22.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "CoreDataModel.h"
#import <CoreData/CoreData.h>
#import "SetInfo.h"
#import "SummaryModel.h"
//#import "BookMark.h"
#import "FirstViewModel.h"

@interface CoreDataModel ()

@property (nonatomic,strong)NSPersistentStoreCoordinator * clCoor;
@property (nonatomic,strong)NSPersistentStore * clStore;
@property (nonatomic,strong)NSManagedObjectContext *clContext;

@property (nonatomic,strong)NSPersistentStoreCoordinator * smCoor;
@property (nonatomic,strong)NSPersistentStore * smStore;
@property (nonatomic,strong)NSManagedObjectContext *smContext;


@property (nonatomic,strong)NSPersistentStoreCoordinator * coor1;
@property (nonatomic,strong)NSPersistentStore * store1;

@property (nonatomic,strong)NSPersistentStoreCoordinator * coor2;
@property (nonatomic,strong)NSPersistentStore * store2;

@end

@implementation CoreDataModel


/*
 "showapi_res_body" : {
 "bookClass" : [
 */
- (NSArray *)getJsonData{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"classfi" ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	NSDictionary *dice = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
	NSArray *dataArr = dice[@"showapi_res_body"][@"bookClass"];
//	NSLog(@"dataArr = %@",dataArr);
	return dataArr;
}

/**
 *  创建图书分类的数据库
 *
 *  @param bookClasfy 图书类别模型
 */
- (void)creatCoreDataBooksClassfy{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"FirstViewModel" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	NSPersistentStoreCoordinator * coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/FirstviewModel.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	NSPersistentStore *store = [self.clCoor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = coor;
	
	//数据库没有数据就插入数据
	for (NSDictionary *dice in [self getJsonData]) {
		FirstViewModel *fmo = [NSEntityDescription insertNewObjectForEntityForName:@"FirstViewModel" inManagedObjectContext:self.clContext];
		fmo.id = dice[@"id"];
		fmo.name = dice[@"name"];
		[context save:nil];
	}
}
/**
 *  修改图书分类的数据库
 *
 *  @param bookClassfy 传入一类图书的模型
 */
- (void)modeifyFirstViewModelWith:(BookClassfy *)bookClassfy index:(NSInteger)index{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"FirstViewModel" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	NSPersistentStoreCoordinator * coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/FirstviewModel.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	NSPersistentStore *store = [self.clCoor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = coor;
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FirstViewModel"];
	NSArray *requestArr = [context executeFetchRequest:request error:nil];
	//修改数据库中的数据
	FirstViewModel *first = (FirstViewModel *)requestArr[index];
	if ([first.name isEqualToString:bookClassfy.name] && [first.id isEqualToString:bookClassfy.id]) {
		return;
	}
	else{ //数据不一样才修改
		first.name  = bookClassfy.name;
		first.id = bookClassfy.id;
		[context save:nil];
	}
}
/**
 *  获取图书分类的数据库
 *
 *  @param return 需要的数据
 */
- (NSArray *)getFirstViewModel{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"FirstViewModel" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	NSPersistentStoreCoordinator * coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/FirstviewModel.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	NSPersistentStore *store = [self.clCoor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = coor;
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FirstViewModel"];
	NSArray *requestArr = [context executeFetchRequest:request error:nil];
	return requestArr;
}

/**
 *  创建首页显的图书概要数据库
 */
- (void)creatCoreDataSummaryModel{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"SummaryModel" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	self.smCoor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/SummaryModel.sqlite",NSHomeDirectory()];
//	NSLog(@"db = %@",dbPath);
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	self.smStore = [self.smCoor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	self.smContext = [[NSManagedObjectContext alloc] init];
	self.smContext.persistentStoreCoordinator = self.smCoor;
	SummaryModel *fmo = [NSEntityDescription insertNewObjectForEntityForName:@"SummaryModel" inManagedObjectContext:self.smContext];
	fmo.summary = @"测试数据";
	
	[self.smContext save:nil];
}
/**
 *  修改SummaryModel数据库里面的数据
 *
 *  @param summary 需要修改的数据
 */
- (void)modeifySummaryModell:(NSString *)summary{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"SummaryModel" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	NSPersistentStoreCoordinator *sCoor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/SummaryModel.sqlite",NSHomeDirectory()];
//	NSLog(@"db = %@",dbPath);
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	self.smStore = [sCoor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = sCoor;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SummaryModel"];
	NSArray *requestArr = [context executeFetchRequest:request error:nil];
	//修改数据库中的数据
	SummaryModel *first = (SummaryModel *)requestArr[0];
	if ([first.summary isEqualToString:summary]) {
		return;
	}
	else{ //数据不一样才修改
		first.summary  = summary;
//		NSLog(@"修改成功");
		[context save:nil];
	}
}
/**
 *  获取SummaryModel数据里面的数据
 *
 *  @return 需要获取的数据
 */
- (NSString *)getSummaryModell{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"SummaryModel" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	NSPersistentStoreCoordinator *sCoor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/SummaryModel.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	self.smStore = [sCoor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = sCoor;

	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SummaryModel"];
	NSArray *requestArr = [context executeFetchRequest:request error:nil];
	//修改数据库中的数据
	SummaryModel *first = (SummaryModel *)requestArr[0];
	return first.summary;
}


- (void)creatCoreDataBookMark{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"BookMark" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	NSPersistentStoreCoordinator *coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString * dbPath = [NSString stringWithFormat:@"%@/Documents/bookMark.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	NSPersistentStore *store = [coor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = coor;
}
/**
 *  向书签数据库插入数据
 *
 *  @param bookName     书名
 *  @param chapeName    章节名
 *  @param bookID       书的ID
 *  @param bookDetailID 章节ID
 */
- (void)insterCoreDataBookMarkWithBookName:(NSString *)bookName chapeName:(NSString *)chapeName bookID:(NSString *)bookID bookDetailID:(NSString *)bookDetailID{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"BookMark" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	NSPersistentStoreCoordinator *coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString * dbPath = [NSString stringWithFormat:@"%@/Documents/bookMark.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	NSPersistentStore *store = [coor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = coor;

	/*
	 @dynamic bookID;
	 @dynamic bookName;
	 @dynamic bookDetailID;
	 @dynamic chanpteName;
	 */
	BookMark *bk = [NSEntityDescription insertNewObjectForEntityForName:@"BookMark" inManagedObjectContext:context];
	bk.bookDetailID = bookDetailID;
	bk.bookID = bookID;
	bk.bookName = bookName;
	bk.chanpteName = chapeName;
	[context save:nil];
}
/**
 *  获取书签数据库里面的数据
 *
 *  @return 返回数据里面的全部书签模型数组
 */
//- (NSArray *)getCoreDataBookMark{
//	// 1.取文件路径
//	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"BookMark" ofType:@"momd"];
//	// 2.取出CoreData在工程中的模型
//	NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
//	// 3.制作一个关联层 CoreData和sqlite关联
//	NSPersistentStoreCoordinator *coor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
//	// 4.创建一个数据库地址
//	NSString * dbPath = [NSString stringWithFormat:@"%@/Documents/bookMark.sqlite",NSHomeDirectory()];
//	// 5.关联层创建数据库返回的对象  创建失败store = nil
//	NSPersistentStore *store = [coor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
//	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
//	context.persistentStoreCoordinator = coor;
//	
//	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"BookMark"];
//	[request setReturnsObjectsAsFaults:NO];
//	NSArray *requestArr = [context executeFetchRequest:request error:nil];
//	[context save:nil];
//	
//	NSMutableArray *arr  = [[NSMutableArray alloc] init];
//	for (BookMark *bk in requestArr) {
//		NSDictionary *dic = @{@"bonkName":bk.bookName,@"bookID":bk.bookID,@"chanpteName":bk.chanpteName,@"bookDetailID":bk.bookDetailID};
//		[arr addObject:dic];
//	}
//	[[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"BookMark"];
//	
//	NSLog(@"arr = %@",arr);
//	return arr;
//}


- (void)creatCoreDataSetInfo{
	// 1.取文件路径
	NSString * corDataPath = [[NSBundle mainBundle] pathForResource:@"SetInfo" ofType:@"momd"];
	// 2.取出CoreData在工程中的模型
	NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:corDataPath]];
	// 3.制作一个关联层 CoreData和sqlite关联
	self.coor2 = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	// 4.创建一个数据库地址
	NSString * dbPath = [NSString stringWithFormat:@"%@/Documents/setInfo.sqlite",NSHomeDirectory()];
	// 5.关联层创建数据库返回的对象  创建失败store = nil
	self.store2 = [self.coor2 addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:0 error:nil];
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = self.coor2;
	
	
	SetInfo *bk = [NSEntityDescription insertNewObjectForEntityForName:@"SetInfo" inManagedObjectContext:context];
	bk.fontSize = @"18";
	bk.firstBackNum = @"1";
	bk.chapeBackNum = @"2";
	bk.readBackNum = @"3";
	bk.settingBackNum = @"4";
	bk.searchBackNum = @"5";
	bk.bookMarkBackNum = @"6";
	
	[context save:nil];
	
}

@end
