//
//  GetURLModel.h
//  MyBook
//
//  Created by qf on 15/9/5.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetURLModel : NSObject


- (NSString *)getTypesUrlStr;
- (NSString *)getSearchUrlStr:(NSString *)inputStr;
- (NSString *)getATypeBookSUrlStrWithTypeID:(NSString *)typeID;
- (NSString *)getABookUrlStrWithBookID:(NSString *)bookID;
- (NSString *)getAchapterUrlStrWithchapterID:(NSString *)chapterID;
@end
