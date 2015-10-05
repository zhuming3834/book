//
//  SearchBookModel.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "SearchBookModel.h"

@implementation SearchBookModel

@synthesize id;
@synthesize description;


- (NSArray *)setSearchBookModelWithDictionary:(NSDictionary *)dice{
	NSArray *arr = dice[@"showapi_res_body"][@"bookList"];
	NSMutableArray *mArray = [[NSMutableArray alloc] init];
	for (NSDictionary *dic in arr) {
		SearchBookModel *smodel = [[SearchBookModel alloc] init];
		[smodel setValuesForKeysWithDictionary:dic];
		[mArray addObject:smodel];
	}
	return mArray;
}


@end
