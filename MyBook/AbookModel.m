//
//  AbookModel.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "AbookModel.h"
#import "ChapetModel.h"

@implementation AbookModel

@synthesize id;

+ (AbookModel *)setAbookModelWithDictionary:(NSDictionary *)dice{
	NSDictionary *bookDetailsDice = dice[@"showapi_res_body"][@"bookDetails"];
	AbookModel *bookModel = [[AbookModel alloc] init];
	
	[bookModel setValue:bookDetailsDice[@"author"] forKey:@"author"];
	[bookModel setValue:bookDetailsDice[@"bookclass"] forKey:@"bookclass"];
	[bookModel setValue:bookDetailsDice[@"count"] forKey:@"count"];
	[bookModel setValue:bookDetailsDice[@"fcount"] forKey:@"fcount"];
	
	[bookModel setValue:bookDetailsDice[@"from"] forKey:@"from"];
	[bookModel setValue:bookDetailsDice[@"id"] forKey:@"id"];
	[bookModel setValue:bookDetailsDice[@"img"] forKey:@"img"];
	
	[bookModel setValue:bookDetailsDice[@"name"] forKey:@"name"];
	[bookModel setValue:bookDetailsDice[@"rcount"] forKey:@"rcount"];
	[bookModel setValue:bookDetailsDice[@"summary"] forKey:@"summary"];
	
	
	NSArray *chaperArr = bookDetailsDice[@"list"];
	NSMutableArray *chap = [[NSMutableArray alloc] init];
	for (NSDictionary *dic in chaperArr) {
		ChapetModel *cmodel = [[ChapetModel alloc] init];
		[cmodel setValuesForKeysWithDictionary:dic];
		[chap addObject:cmodel];
	}
	[bookModel setValue:chap forKey:@"list"];
	return bookModel;
}





@end


















