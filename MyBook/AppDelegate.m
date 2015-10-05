//
//  AppDelegate.m
//  MyBook
//
//  Created by qf on 15/9/4.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataModel.h"

@interface AppDelegate ()

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
	if(ScreenHeight > 480){
		myDelegate.autoSizeScaleX = ScreenWidth/320;
		myDelegate.autoSizeScaleY = ScreenHeight/568;
	}else{
		myDelegate.autoSizeScaleX = 1.0;
//		myDelegate.autoSizeScaleY = 480/568;
		myDelegate.autoSizeScaleY = 1.0;
	}
	
	NSFileManager *manager=[NSFileManager defaultManager];
	NSString *filePath = [NSString stringWithFormat:@"%@/Documents/start.txt",NSHomeDirectory()];
	BOOL isHasFile=[manager fileExistsAtPath:filePath];

	if (isHasFile) {
//		NSLog(@"文件存在");
	}else{
//		NSLog(@"不文件存在");
		[manager createFileAtPath:filePath contents:nil attributes:nil];
		//创建一个空的书签表单和一个设置表单
		CoreDataModel *coreModel = [[CoreDataModel alloc] init];
		[coreModel creatCoreDataSetInfo];
		[coreModel creatCoreDataBookMark];
		[coreModel creatCoreDataSummaryModel];
	}
	// Override point for customization after application launch.
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
