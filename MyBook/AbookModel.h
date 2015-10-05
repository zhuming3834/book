//
//  AbookModel.h
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbookModel : NSObject

@property (nonatomic,copy)NSString *author;
@property (nonatomic,copy)NSNumber *bookclass;
@property (nonatomic,copy)NSString *count;
@property (nonatomic,copy)NSNumber *fcount;
@property (nonatomic,copy)NSString *from;
@property (nonatomic,copy)NSNumber *id;
@property (nonatomic,copy)NSString *img;
@property (nonatomic,copy)NSArray  *list;

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSNumber *rcount;
@property (nonatomic,copy)NSString *summary;

+ (AbookModel *)setAbookModelWithDictionary:(NSDictionary *)dice;

@end

































