//
//  AtypeBooks.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "AtypeBooks.h"

@implementation AtypeBooks

@synthesize id;


- (NSArray *)setAtypeBooksModelWithDictionary:(NSDictionary *)dice{
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	NSArray *booksArr = dice[@"showapi_res_body"][@"bookList"];
	for (NSDictionary *dic in booksArr) {
		AtypeBooks *bks = [[AtypeBooks alloc] init];
		[bks setValuesForKeysWithDictionary:dic];
		[arr addObject:bks];
	}
	return arr;
}


@end
