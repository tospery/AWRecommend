//
//  JXChooseViewController.m
//  ihealth
//
//  Created by 杨建祥 on 16/4/13.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import "JXChooseViewController.h"

@interface JXChooseViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation JXChooseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (self.tvTintColor) {
        self.tableView.tintColor = self.tvTintColor;
    }
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXCellDefault height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXCellDefault *cell = [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier]];
    id<JXChooseObjectProtocol> item = self.items[indexPath.row];
    cell.textLabel.text = [item cellTitle];
    if ([item hasSelected]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (id<JXChooseObjectProtocol> item in self.items) {
        [item setupSelected:NO];
    }
    id<JXChooseObjectProtocol> item = self.items[indexPath.row];
    [item setupSelected:YES];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJXNotifyDidChoose object:item];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Public methods
#pragma mark - Class methods


@end



