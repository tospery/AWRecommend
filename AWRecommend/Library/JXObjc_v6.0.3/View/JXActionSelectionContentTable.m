//
//  JXActionSelectionContentTable.m
//  JXSamples
//
//  Created by 杨建祥 on 16/6/2.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXActionSelectionContentTable.h"

@interface JXActionSelectionContentTable ()
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, assign) NSInteger index;

@end

@implementation JXActionSelectionContentTable
#pragma mark - Private methods
- (void)setup {
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    tableView.tintColor = JXColorHex(0x007AFF);
//    
//    //[tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kJXIdentifierCellSystem];
//    [tableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tintColor = JXColorHex(0x007AFF);
        [_tableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    }
    return _tableView;
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return kJXStdCellHeight;
    return [JXCellDefault height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXCellDefault *cell = [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_options[indexPath.row] description];
    //cell.textLabel.font = [UIFont jx_deviceRegularFontOfSize:15.0f];
    
    if (indexPath.row == _index) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = JXColorRGB(251.0f, 251.0f, 251.0f);
        cell.textLabel.textColor = tableView.tintColor;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _index = indexPath.row;
    [tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(actionSelection:didSelectIndex:withObject:)]) {
        [self.delegate actionSelection:(JXActionSelection *)self.superview didSelectIndex:(self.superview.tag - JXActionBarTagBegin) withObject:_options[indexPath.row]];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

#pragma mark - Public methods
- (instancetype)initWithOptions:(NSArray *)options defaultIndex:(NSInteger)index {
    if (self = [self initWithFrame:CGRectMake(0, 0, JXScreenWidth, options.count * kJXStdCellHeight)]) {
        _options = options;
        _index = index;
        [self setup];
    }
    return self;
}
@end

