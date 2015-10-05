//
//  ThemeTableViewCell.h
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BookClassfy.h"

@interface ThemeTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

- (void)setTypeLabelTextWith:(BookClassfy *)bookClassfy;


@end
