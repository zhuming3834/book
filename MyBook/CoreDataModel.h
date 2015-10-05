//
//  CoreDataModel.h
//  MyBook
//
//  Created by qf on 15/9/22.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookClassfy.h"
#import "BookMark.h"

@interface CoreDataModel : NSObject

- (void)creatCoreDataSetInfo;


- (void)creatCoreDataBookMark;
- (void)insterCoreDataBookMarkWithBookName:(NSString *)bookName chapeName:(NSString *)chapeName bookID:(NSString *)bookID bookDetailID:(NSString *)bookDetailID;
//- (NSArray *)getCoreDataBookMark;


- (void)creatCoreDataBooksClassfy;
- (void)modeifyFirstViewModelWith:(BookClassfy *)bookClassfy index:(NSInteger)index;
- (NSArray *)getFirstViewModel;

- (void)creatCoreDataSummaryModel;
- (void)modeifySummaryModell:(NSString *)summary;
- (NSString *)getSummaryModell;

//- (NSArray *)getJsonData;

@end
