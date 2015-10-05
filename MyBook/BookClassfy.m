//
//  BookClassfy.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "BookClassfy.h"

@implementation BookClassfy
@synthesize id;


- (NSArray *)setBookClassfyWith:(NSDictionary *)dice{
	NSMutableArray *book = [[NSMutableArray alloc] init];
	NSArray *bookClassfy = dice[@"showapi_res_body"][@"bookClass"];
	for (NSDictionary * dic in bookClassfy) {
		BookClassfy *bk = [[BookClassfy alloc] init];
		[bk setValuesForKeysWithDictionary:dic];
		[book addObject:bk];
	}
	return book;
}


@end
