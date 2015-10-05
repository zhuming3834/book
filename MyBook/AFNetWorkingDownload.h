//
//  AFNetWorkingDownload.h
//  MyBook
//
//  Created by qf on 15/9/4.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AFNetWorkingDownloadDelegate <NSObject>

- (void)getDownloadData:(NSData *)recData withAFNetWorking:(id)AFNetWorking;

@end



@interface AFNetWorkingDownload : NSObject

@property (nonatomic,copy)NSString * identity;

@property (nonatomic,strong)id<AFNetWorkingDownloadDelegate>delegate;

- (void)downloadDataFromURLString:(NSString *)URLString;


@end
