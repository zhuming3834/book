//
//  SetInfo.h
//  MyBook
//
//  Created by qf on 15/9/21.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SetInfo : NSManagedObject

@property (nonatomic, retain) NSString * fontSize;
@property (nonatomic, retain) NSString * firstBackNum;
@property (nonatomic, retain) NSString * bookMarkBackNum;
@property (nonatomic, retain) NSString * searchBackNum;
@property (nonatomic, retain) NSString * settingBackNum;
@property (nonatomic, retain) NSString * chapeBackNum;
@property (nonatomic, retain) NSString * readBackNum;

@end
