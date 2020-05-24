//
//  JXTableViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXScrollViewController.h"

@interface JXTableViewController : JXScrollViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) BOOL isNoMoreData;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) RACCommand *didSelectCommand;
@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, weak, readonly) UIView *headerView;
@property (nonatomic, weak, readonly) UIView *footerView;

//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
//
//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath object:(id)object;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object;
- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object;

- (NSUInteger)nextPageIndex;

//- (void)beginUpdate;
//- (void)endUpdate;

@end
