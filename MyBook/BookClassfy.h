//
//  BookClassfy.h
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookClassfy : NSObject

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;

- (NSArray *)setBookClassfyWith:(NSDictionary *)dice;

@end
