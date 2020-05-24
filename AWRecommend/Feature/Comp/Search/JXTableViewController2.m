//
//  JXTableViewController2.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXTableViewController2.h"

@interface JXTableViewController2 ()
@property (nonatomic, assign) NSInteger page;

@end

@implementation JXTableViewController2
@synthesize dataSource;

#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    [self.tableView registerClass:[JXCellValue1 class] forCellReuseIdentifier:[JXCellValue1 identifier]];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    [[RACObserve(self, shouldPullToRefresh) distinctUntilChanged] subscribeNext:^(NSNumber *should) {
        @strongify(self)
        if (should.boolValue) {
            // YJX_TODO 是否有必要取消scrollView的headerRefresh
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
        }else {
            [self.tableView.mj_header removeFromSuperview];
            self.tableView.mj_header = nil;
        }
    }];
    
    [[RACObserve(self, shouldInfiniteScrolling) distinctUntilChanged] subscribeNext:^(NSNumber *should) {
        @strongify(self)
        if (should.boolValue) {
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(triggerMore)];
        }else {
            [self.tableView.mj_footer removeFromSuperview];
            self.tableView.mj_footer = nil;
        }
    }];
}


#pragma mark - Accessor
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}

//- (void)setIsLoading:(BOOL)isLoading {
//    _isLoading = isLoading;
//    // [self.tableView reloadEmptyDataSet];
//
//    if (isLoading) {
//        [self.tableView reloadData];
//    }
//}

//- (JXPage *)page {
//    if (!_page) {
//        _page = [[JXPage alloc] init];
//    }
//    return _page;
//}

#pragma mark - Private
- (BOOL)dataSourceIsEmpty {
    if (nil == self.dataSource) {
        return YES;
    }
    
    if ([self.dataSource isKindOfClass:[NSArray class]]) {
        NSArray *sections = self.dataSource;
        if (0 == sections.count) {
            return YES;
        }
        
        NSArray *rows = sections[0];
        if (1 == sections.count && 0 == rows.count) {
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - Public
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    return ^(NSError *error) {
        BOOL isFilter = YES;
        
        switch (self.requestMode) {
            case JXRequestModeLoad: {
                if (JXErrorCodeTokenInvalid == error.code) {
                    self.error = error;
                }else if (JXErrorCodeDataEmpty == error.code) {
                    self.error = error;
                    isFilter = NO;
                }
                self.requestMode = JXRequestModeNone;
                self.dataSource = nil;
                break;
            }
            case JXRequestModeUpdate: {
                if (JXErrorCodeTokenInvalid == error.code) {
                    self.error = error;
                }else if (JXErrorCodeDataEmpty == error.code) {
                    self.error = error;
                    isFilter = NO;
                }
                self.requestMode = JXRequestModeNone;
                self.dataSource = nil;
                break;
            }
            case JXRequestModeRefresh: {
                if (JXErrorCodeTokenInvalid == error.code) {
                    self.error = error;
                }else if (JXErrorCodeDataEmpty == error.code) {
                    self.error = error;
                    isFilter = NO;
                }
                [self.tableView.mj_header endRefreshing];
                self.requestMode = JXRequestModeNone;
                self.dataSource = nil;
                break;
            }
            case JXRequestModeMore: {
                if (JXErrorCodeTokenInvalid == error.code) {
                    self.error = error;
                    [self.tableView.mj_footer endRefreshing];
                }else if (JXErrorCodeDataEmpty == error.code) {
                    isFilter = NO;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.tableView.mj_footer endRefreshing];
                }
                
                self.requestMode = JXRequestModeNone;
                break;
            }
            case JXRequestModeHUD: {
                if (JXErrorCodeTokenInvalid == error.code) {
                    self.error = error;
                }else if (JXErrorCodeDataEmpty == error.code) {
                    self.error = error;
                    isFilter = NO;
                }
                JXHUDHide();
                self.requestMode = JXRequestModeNone;
                self.dataSource = nil;
                break;
            }
            default:
                break;
        }
        
        return isFilter;
    };
}

- (NSUInteger)nextPageIndex {
    if (JXObjcPageStyleGroup == JXInstance.pageStyle) {
        return self.page + 1;
    }else if (JXObjcPageStyleOffset == JXInstance.pageStyle) {
        NSArray *lastRows = self.dataSource.lastObject;
        NSArray *lastObj = lastRows.lastObject;
        return [[(JXObject *)lastObj uid] integerValue];
    }
    
    JXLogError(@"pageStyle错误");
    return 0;
}

- (void)beginUpdate {
    // self.navigationItem.title = @"更新中";
}

- (void)endUpdate {
    //self.navigationItem.title = self.navTitle;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [JXCellDefault height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    
}

- (void)triggerLoad {
    self.requestMode = JXRequestModeLoad;
    self.dataSource = nil;

    @weakify(self)
    [[[self.requestRemoteDataCommand execute:RACTuplePack(@(JXInstance.pageIndex), self.requestParam)] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.page = JXInstance.pageIndex;
        self.requestMode = JXRequestModeNone;
    } completed:^{
        
    }];
}

//- (void)triggerRefresh {
//    //self.error = nil;
//    self.requestMode = JXRequestModeRefresh;
//    
//    @weakify(self)
//    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(id x) {
//        //@strongify(self)
//        //self.page = 1;
//        @strongify(self)
//        self.requestMode = JXRequestModeNone;
//    }/* error:^(NSError *error) {
//      @strongify(self)
//      [self handleError:error mode:JXRequestModeRefresh];
//      [self.tableView.mj_header endRefreshing];
//      }*/ completed:^{
//          @strongify(self)
//          [self.tableView.mj_header endRefreshing];
//      }];
//}
//
//- (void)triggerMore {
//    //self.error = nil;
//    self.requestMode = JXRequestModeMore;
//    
//    @weakify(self)
//    [[[self.requestRemoteDataCommand execute:@([self nextPageIndex])] deliverOnMainThread] subscribeNext:^(id x) {
//        @strongify(self)
//        self.page += 1;
//        self.requestMode = JXRequestModeNone;
//    }/* error:^(NSError *error) {
//      @strongify(self)
//      [self handleError:error mode:JXRequestModeMore];
//      [self.tableView.mj_footer endRefreshing];
//      }*/ completed:^{
//          @strongify(self)
//          if (self.isNoMoreData) {
//              [self.tableView.mj_footer endRefreshingWithNoMoreData];
//          }else {
//              [self.tableView.mj_footer endRefreshing];
//          }
//      }];
//}
//
//- (void)triggerHUD {
//    //self.error = nil;
//    self.requestMode = JXRequestModeHUD;
//    
//    JXHUDProcessing(nil);
//    @weakify(self)
//    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(id x) {
//        //@strongify(self)
//        //self.page = 1;
//        @strongify(self)
//        self.page = JXInstance.pageIndex;
//        self.requestMode = JXRequestModeNone;
//    }/* error:^(NSError *error) {
//      @strongify(self)
//      [self handleError:error mode:self.requestMode];
//      }*/ completed:^{
//          JXHUDHide();
//      }];
//}
//
//- (void)triggerUpdate {
//    //    // [self.tableView.mj_header beginRefreshing];
//    //
//    // self.navigationItem.title = @"更新中";
//    //    [self triggerLoad];
//    
//    //self.error = nil;
//    self.requestMode = JXRequestModeUpdate;
//    [self beginUpdate];
//    //self.isLoading = YES;
//    @weakify(self)
//    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(NSArray *items) {
//        @strongify(self)
//        //self.requestMode = JXRequestModeNone;
//        self.page = 1;
//        //        if (JXDataIsEmpty(items)) {
//        //            [self reloadData];
//        //        }
//    } error:^(NSError *error) {
//        @strongify(self)
//        [self endUpdate];
//        [self handleError:error mode:self.requestMode];
//        self.requestMode = JXRequestModeNone;
//        [self reloadData];
//    } completed:^{
//        [self endUpdate];
//        self.requestMode = JXRequestModeNone;
//    }];
//    
//    //[[self.requestRemoteDataCommand execute:@1] deliverOnMainThread] sub
//}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = self.dataSource[indexPath.section][indexPath.row];
    return [self heightForRowAtIndexPath:indexPath object:object];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
    
    id object = self.dataSource[indexPath.section][indexPath.row];
    [self configCell:cell indexPath:indexPath object:object];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.didSelectCommand execute:RACTuplePack(indexPath, self.dataSource[indexPath.section][indexPath.row])];
}

@end
