//
//  BookListTableViewCell.m
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import "BookListTableViewCell.h"
#import "AtypeBooks.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface BookListTableViewCell ()

//@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *autherLabel;
//@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;


@property (strong, nonatomic) UIImageView *leftImage;
@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *autherLabel;
@property (strong, nonatomic) UILabel *summaryLabel;

@end

@implementation BookListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self creatMyCell];
	}
	return self;
}

- (void)creatMyCell{
	self.leftImage = [[UIImageView alloc] init];
	self.nameLabel = [[UILabel alloc] init];
	self.autherLabel = [[UILabel alloc] init];
	self.summaryLabel = [[UILabel alloc] init];
	
	self.frame = CGRectMake(0, 0, ScreenWidth, 120);
	
	self.leftImage.frame = CGRectMake(5, 5, 100, 110);
	self.nameLabel.frame = CGRectMake(110, 5, self.frame.size.width - 115, 25);
	self.autherLabel.frame = CGRectMake(110, 30, self.frame.size.width - 115, 25);
	self.summaryLabel.frame = CGRectMake(110, 55, self.frame.size.width - 115, 60);
	self.summaryLabel.font = [UIFont systemFontOfSize:11];
	self.summaryLabel.numberOfLines = 0;
	
	[self addSubview:self.leftImage];
	[self addSubview:self.nameLabel];
	[self addSubview:self.autherLabel];
	[self addSubview:self.summaryLabel];
}

- (void)setBookListCellWith:(AtypeBooks *)booksModel{
	[self.leftImage setImageWithURL:[NSURL URLWithString:booksModel.img] placeholderImage:[UIImage imageNamed:@"load-image.png"]];
	self.nameLabel.text = [NSString stringWithFormat:@"书名:%@",booksModel.name]; //书名
	self.autherLabel.text = [NSString stringWithFormat:@"作者:%@",booksModel.author]; //作者
	
	NSString * summaryStr = booksModel.summary;
	summaryStr = [summaryStr stringByReplacingOccurrencesOfString:@"&#" withString:@""];
	//summary开头存在一个 "\r\n"需要剔除掉
	NSString * subStr = [summaryStr substringFromIndex:2];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"&#" withString:@""];
	self.summaryLabel.text = subStr;
}

- (void)setBookListCellWithSearchBookModel:(SearchBookModel *)searchBookModel{
	[self.leftImage setImageWithURL:[NSURL URLWithString:searchBookModel.img] placeholderImage:[UIImage imageNamed:@"load-image.png"]];
	self.nameLabel.text = [NSString stringWithFormat:@"书名:%@",searchBookModel.name]; //书名
	self.autherLabel.text = [NSString stringWithFormat:@"作者:%@",searchBookModel.author]; //作者
	
	NSString * summaryStr = searchBookModel.content;
	summaryStr = [summaryStr stringByReplacingOccurrencesOfString:@"&#" withString:@""];
	//summary开头存在一个 "\r\n"需要剔除掉
	NSString * subStr = [summaryStr substringFromIndex:2];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
	subStr = [subStr stringByReplacingOccurrencesOfString:@"&#" withString:@""];
	self.summaryLabel.text = subStr;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
