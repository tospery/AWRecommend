//
//  TestViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/23.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation TestViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"测试";
    
    self.items = @[@"aaaa", @"bbbb", @"cccc"];
    // self.items = @[@"aaaa"];
    
    [self.tableView registerClass:[JXCell class] forCellReuseIdentifier:[JXCell identifier]];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JXScreenScale(40);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
    
    if (!cell.accessoryView) {
        CGFloat slide = JXScreenScale(16);
        VBFPopFlatButton *rightButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, slide, slide) buttonType:buttonForwardType buttonStyle:buttonPlainStyle animateToInitialState:NO];
        rightButton.tintColor = [UIColor orangeColor];
        rightButton.userInteractionEnabled = NO;
        rightButton.lineThickness = 1.0;
        cell.accessoryView = rightButton;
    }
    
    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSArray *a = cell.subviews;
//    NSArray *b = cell.contentView.subviews;
//    int c = 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
