//
//  ThemeTableViewCell.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "ThemeTableViewCell.h"

@implementation ThemeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setTypeLabelTextWith:(BookClassfy *)bookClassfy{
	self.typeLabel.text = bookClassfy.name;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
