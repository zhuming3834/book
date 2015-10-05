//
//  BookListTableViewCell.h
//  MyBook
//
//  Created by qf on 15/9/29.
//  Copyright (c) 2015年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtypeBooks.h"
#import "SearchBookModel.h"

@interface BookListTableViewCell : UITableViewCell

- (void)setBookListCellWith:(AtypeBooks *)booksModel;
- (void)setBookListCellWithSearchBookModel:(SearchBookModel *)searchBookModel;

@end
