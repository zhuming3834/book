//
//  SettingTableViewCell.h
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

- (void)setCellWithImageName:(NSString *)imageName;

@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UIImageView *leftImageView;
@property (nonatomic,strong)UIButton    *rightButton;

@end
