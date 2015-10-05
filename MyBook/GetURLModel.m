//
//  GetURLModel.m
//  MyBook
//
//  Created by qf on 15/9/5.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "GetURLModel.h"

#define SHOWAPI_APPID  @"8046"
#define SHOWAPI_SIGN   @"7cf974270c9b4f4784ac7ae5a9c659f6"
/*
 *
 * URL获取顺序：某一类书---》其中的某一本---》其中的某一章节
 *
 */





@implementation GetURLModel

/**
 *  获取系统时间
 *
 *  @return 返回NSString类型的yyyyMMddHHmmss格式的时间
 */
- (NSString *)getDateStr{
	//得到当前系统日期
	NSDate *date1 = [NSDate date];
	//然后您需要定义一个NSDataFormat的对象
	NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
	//然后设置这个类的dataFormate属性为一个字符串，系统就可以因此自动识别年月日时间
	[dateFormat setDateFormat: @"yyyyMMddHHmmss"];
	//之后定义一个字符串，使用stringFromDate方法将日期转换为字符串
	NSString * show_timestamp = [dateFormat stringFromDate:date1];
	return show_timestamp;
}
/**
 *  获取图书总得分类的URL
 *
 *  @return 图书总分类的URL
 */
- (NSString *)getTypesUrlStr{
	NSString * show_timestamp = [self getDateStr];
	NSString * showapi_appid = SHOWAPI_APPID;
	NSString * showapi_sign = SHOWAPI_SIGN;
	NSString * temp = [NSString stringWithFormat:@"https://route.showapi.com/92-93?showapi_appid=%@&showapi_timestamp=%@&showapi_sign=%@",showapi_appid,show_timestamp,showapi_sign];
	//解决http中带中文字符的情况
	NSString * urlStr = [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return urlStr;
}
/**
 *  获取图书搜索的URL
 *
 *  @param inputStr 搜索栏输入的字符
 *
 *  @return 返回一个URL
 */
- (NSString *)getSearchUrlStr:(NSString *)inputStr{
	NSString * show_timestamp = [self getDateStr];
	NSString * showapi_appid = SHOWAPI_APPID;
	NSString * showapi_sign = SHOWAPI_SIGN;
	NSString * temp = [NSString stringWithFormat:@"https://route.showapi.com/92-94?keyword=%@&limit=&page=&showapi_appid=%@&showapi_timestamp=%@&showapi_sign=%@",inputStr,showapi_appid,show_timestamp,showapi_sign];
	//解决http中带中文字符的情况
	NSString * urlStr = [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return urlStr;
}
/**
 *  获取某一类书的URL
 *
 *  @param typeID 书类别的ID号
 *  ID号的范围: 1 ~ 10
 *  @return 一类书的ID的URL
 */
- (NSString *)getATypeBookSUrlStrWithTypeID:(NSString *)typeID{
	NSString * show_timestamp = [self getDateStr];
	NSString * showapi_appid = SHOWAPI_APPID;
	NSString * showapi_sign = SHOWAPI_SIGN;
	NSString * temp = [NSString stringWithFormat:@"https://route.showapi.com/92-92?id=%@&limit=&page=&showapi_appid=%@&showapi_timestamp=%@&type=&showapi_sign=%@",typeID,showapi_appid,show_timestamp,showapi_sign];
	//解决http中带中文字符的情况
	NSString * urlStr = [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return urlStr;
}
/**
 *  获取一本书的URL
 *
 *  @param bookID 书的ID
 *  ID号的范围: 1 ~ 1000 (不一定每个数字都有)
 *  @return 书的URL
 */
- (NSString *)getABookUrlStrWithBookID:(NSString *)bookID{
	NSString * show_timestamp = [self getDateStr];
	NSString * showapi_appid = SHOWAPI_APPID;
	NSString * showapi_sign = SHOWAPI_SIGN;
	NSString * temp = [NSString stringWithFormat:@"https://route.showapi.com/92-91?id=%@&showapi_appid=%@&showapi_timestamp=%@&showapi_sign=%@",bookID,showapi_appid,show_timestamp,showapi_sign];
	//解决http中带中文字符的情况
	NSString * urlStr = [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return urlStr;
}
/**
 *  获取一本书的某一章节的URL
 *
 *  @param chapterID 书的章节ID
 *
 *  @return 书章节的URL
 */
- (NSString *)getAchapterUrlStrWithchapterID:(NSString *)chapterID{
	NSString * show_timestamp = [self getDateStr];
	NSString * showapi_appid = SHOWAPI_APPID;
	NSString * showapi_sign = SHOWAPI_SIGN;
	NSString * temp = [NSString stringWithFormat:@"https://route.showapi.com/92-32?id=%@&showapi_appid=%@&showapi_timestamp=%@&showapi_sign=%@",chapterID,showapi_appid,show_timestamp,showapi_sign];
	//解决http中带中文字符的情况
	NSString * urlStr = [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return urlStr;
}








@end

























