//
//  BookMark.h
//  MyBook
//
//  Created by qf on 15/9/17.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BookMark : NSManagedObject

@property (nonatomic, retain) NSString * bookID;
@property (nonatomic, retain) NSString * bookName;
@property (nonatomic, retain) NSString * bookDetailID;
@property (nonatomic, retain) NSString * chanpteName;

@end
