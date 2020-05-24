//
//  JXClassifyView.m
//  JXSamples
//
//  Created by 杨建祥 on 17/2/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXClassifyView.h"

@interface JXClassifyView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) BOOL onceTokenLayout;
@property (nonatomic, assign) BOOL onceTokenSelect;

//@property (nonatomic, strong) UIColor *selectedBackgroundColor;
//@property (nonatomic, strong) UIColor *selectedTitleColor;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation JXClassifyView
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self custom];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self custom];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(self.widthPercent);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self).multipliedBy(self.widthPercent);
//    }];
    
//    NSInteger total = [self getTotalClassifies];
//    if (0 != total) {
//        if (!self.onceTokenLayout) {
//            self.onceTokenLayout = YES;
//            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
//            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
//            
//            //UIView *view = [self getViewForRowAtIndexPath:indexPath];
//            //[self bringSubviewToFront:view];
//        }
//    }
    
//    self.tableView.separatorInset = UIEdgeInsetsZero;
//    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self configSelectedIndex];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
        _tableView.tableFooterView = [UIView new];
//        _tableView.separatorInset = UIEdgeInsetsZero;
//        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.separatorColor = [UIColor greenColor]; // self.selectedBackgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)custom {
    self.widthPercent = 0.25;
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(self.widthPercent);
    }];
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tableView.mas_trailing);
        make.top.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
//    // self.selectedIndex = -1;
//    [RACObserve(self, selectedIndex) subscribeNext:^(NSNumber *index) {
//        if (-1 != index.integerValue) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index.integerValue inSection:0];
//            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//        }
//    }];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    UIView *view = [self getViewForRowAtIndexPath:indexPath];
//    [self bringSubviewToFront:view];
    //[self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    
    self.backgroundColor = [UIColor whiteColor];
}

//- (UIColor *)backgroundColorForSelectedWithClassifyView:(JXClassifyView *)classifyView;
//- (UIColor *)titleColorForSelectedWithClassifyView:(JXClassifyView *)classifyView;

//@property (nonatomic, strong) UIColor *selectedBackgroundColor;
//@property (nonatomic, strong) UIColor *selectedTitleColor;
//- (UIColor *)selectedBackgroundColor {
//    if (!_selectedBackgroundColor) {
//        _selectedBackgroundColor = [self getBackgroundColorForSelected];
//    }
//    return _selectedBackgroundColor;
//}
//
//- (UIColor *)selectedTitleColor {
//    if (!_selectedTitleColor) {
//        _selectedTitleColor = [self getTitleColorForSelected];
//    }
//    return _selectedTitleColor;
//}

- (void)configSelectedIndex {
    NSInteger total = [self ds_totalClassifies];
    if (0 != total) {
        if (!self.onceTokenLayout) {
            self.onceTokenLayout = YES;
            
            //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
            [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self tableView:self.tableView didSelectRowAtIndexPath:self.selectedIndexPath];
            
            //UIView *view = [self getViewForRowAtIndexPath:indexPath];
            //[self bringSubviewToFront:view];
        }
    }
}

#pragma mark accessor
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

#pragma mark dataSource
//- (NSInteger)totalClassifiesWithClassifyView:(JXClassifyView *)classifyView;
//- (void)classifyView:(JXClassifyView *)classifyView didCreateCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
//- (UIView *)classifyView:(JXClassifyView *)classifyView viewForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)ds_totalClassifies {
    if ([self.dataSource respondsToSelector:@selector(totalClassifiesWithClassifyView:)]) {
        return [self.dataSource totalClassifiesWithClassifyView:self];
    }
    return 0;
}

- (void)ds_didCreateCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(classifyView:didCreateCell:forRowAtIndexPath:)]) {
        [self.dataSource classifyView:self didCreateCell:cell forRowAtIndexPath:indexPath];
    }
}

- (UIView *)ds_viewForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tag = 1298 + indexPath.row;
    UIView *view = [self.contentView viewWithTag:tag];
    if (!view && [self.dataSource respondsToSelector:@selector(classifyView:viewForRowAtIndexPath:)]) {
        view = [self.dataSource classifyView:self viewForRowAtIndexPath:indexPath];
        view.tag = tag;
        if ([self.contentView.subviews containsObject:view]) {
            if ([view isKindOfClass:[UITableView class]]) {
                [(UITableView *)view reloadData];
            }else {
                [view setNeedsDisplay];
            }
        }else {
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
    }
    return view;
}

- (void)ds_willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(classifyView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.dataSource classifyView:self willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

#pragma mark - Public
- (void)reloadData {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tableView reloadData];
    
    self.onceTokenLayout = NO;
    [self configSelectedIndex];
}

//- (NSString *)getTitleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.dataSource respondsToSelector:@selector(classifyView:titleForRowAtIndexPath:)]) {
//        return [[self.dataSource classifyView:self titleForRowAtIndexPath:indexPath] description];
//    }
//    return nil;
//}
//
//- (UIColor *)getBackgroundColorForSelected {
//    if ([self.dataSource respondsToSelector:@selector(backgroundColorForSelectedWithClassifyView:)]) {
//        return [self.dataSource backgroundColorForSelectedWithClassifyView:self];
//    }
//    return JXColorHex(0xF3F5F7);
//}
//
//- (UIColor *)getTitleColorForSelected {
//    if ([self.dataSource respondsToSelector:@selector(titleColorForSelectedWithClassifyView:)]) {
//        return [self.dataSource titleColorForSelectedWithClassifyView:self];
//    }
//    return JXColorHex(0xEF3338);
//}

// - (CGFloat)percentWidthWithClassifyView:(JXClassifyView *)classifyView;
//- (CGFloat)getPercentWidth {
//    if ([self.dataSource respondsToSelector:@selector(percentWidthWithClassifyView:)]) {
//        return [self.dataSource percentWidthWithClassifyView:self];
//    }
//    return 0.25;
//}

//- (NSInteger)getIndexForSelected {
//    if ([self.dataSource respondsToSelector:@selector(indexForSelectedWithClassifyView:)]) {
//        return [self.dataSource indexForSelectedWithClassifyView:self];
//    }
//    return 0;
//}

// - (UIView *)classifyView:(JXClassifyView *)classifyView viewForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self ds_totalClassifies];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
    
//    cell.separatorInset = UIEdgeInsetsZero;
//    cell.layoutMargins = UIEdgeInsetsZero;
    
    cell.backgroundColor = self.tableView.backgroundColor;
    cell.textLabel.font = JXFont(10);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    
    [self ds_didCreateCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self ds_willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JXScreenScale(40);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    
    BOOL animated = YES;
    if (!self.onceTokenSelect) {
        self.onceTokenSelect = YES;
        animated = NO;
    }
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
    UIView *view = [self ds_viewForRowAtIndexPath:indexPath];
    [self bringSubviewToFront:view];
}

@end










