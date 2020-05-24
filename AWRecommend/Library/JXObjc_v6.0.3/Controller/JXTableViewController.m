//
//  JXTableViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXTableViewController.h"

@interface JXTableViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, weak, readwrite) IBOutlet UITableView *tableView;
@property (nonatomic, weak, readwrite) IBOutlet UIView *headerView;
@property (nonatomic, weak, readwrite) IBOutlet UIView *footerView;

@end

@implementation JXTableViewController
@synthesize dataSource;

#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[JXCell class] forCellReuseIdentifier:[JXCell identifier]];
    [self.tableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    [self.tableView registerClass:[JXCellValue1 class] forCellReuseIdentifier:[JXCellValue1 identifier]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kJXIdentifierCellSystem];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    
    self.tableView.backgroundColor = self.viewBgColor;
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    
//    [[[RACObserve(self, dataSource) skip:1] deliverOnMainThread] subscribeNext:^(id x) {
//        @strongify(self)
//        [self reloadData];
//    }];
    
    [[RACObserve(self, shouldPullToRefresh) distinctUntilChanged] subscribeNext:^(NSNumber *should) {
        @strongify(self)
        if (should.boolValue) {
            // YJX_TODO 是否有必要取消scrollView的headerRefresh
            [self setupRefresh];
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
    
    //[[self.requestRemoteDataCommand.errors filter:[self requestRemoteDataErrorsFilter]] subscribe:self.errors];
}


#pragma mark - Accessor
- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
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
//- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
//    return ^(NSError *error) {
//        BOOL isFilter = NO;
//        
//        [self catchError:error];
//        
//        switch (self.requestMode) {
//            case JXRequestModeLoad: {
////                if (JXErrorCodeTokenInvalid == error.code) {
////                    self.error = error;
////                }else if (JXErrorCodeDataEmpty == error.code) {
////                    self.error = error;
////                    isFilter = NO;
////                }else if (JXErrorCodeNetworkException == error.code ||
////                          JXErrorCodeServerException == error.code) {
////                    self.error = error;
////                    isFilter = NO;
////                }
//                
//                self.error = error;
//                if (JXErrorCodeTokenInvalid == error.code) {
//                    isFilter = YES;
//                }
//                
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            case JXRequestModeUpdate: {
//                self.error = error;
//                if (JXErrorCodeTokenInvalid == error.code) {
//                    isFilter = YES;
//                }
////                else if (JXErrorCodeDataEmpty == error.code) {
////                    self.error = error;
////                    isFilter = NO;
////                }else if (JXErrorCodeNetworkException == error.code ||
////                          JXErrorCodeServerException == error.code) {
////                    self.error = error;
////                    isFilter = NO;
////                }
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            case JXRequestModeRefresh: {
//                self.error = error;
//                if (JXErrorCodeTokenInvalid == error.code) {
//                    isFilter = YES;
//                }
//                [self.tableView.mj_header endRefreshing];
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            case JXRequestModeMore: {
//                if (JXErrorCodeTokenInvalid == error.code) {
//                    self.error = error;
//                    [self.tableView.mj_footer endRefreshing];
//                    isFilter = YES;
//                }else if (JXErrorCodeDataEmpty == error.code ||
//                          JXErrorCodeNetworkException == error.code ||
//                          JXErrorCodeServerException == error.code) {
//                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                }else {
//                    [self.tableView.mj_footer endRefreshing];
//                }
//                
//                self.requestMode = JXRequestModeNone;
//                break;
//            }
//            case JXRequestModeHUD: {
//                self.error = error;
//                if (JXErrorCodeTokenInvalid == error.code) {
//                    isFilter = YES;
//                }
//                [JXDialog hideHUD];
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            default:
//                break;
//        }
//        
//        return isFilter;
//    };
//}

- (BOOL)catchError:(NSError *)error {
    BOOL notFilter = YES;
    BOOL nedUpdate = YES;
    
    switch (self.requestMode) {
        case JXRequestModeLoad:
        case JXRequestModeUpdate: {
            break;
        }
        case JXRequestModeRefresh: {
            [self.tableView.mj_header endRefreshing];
            break;
        }
        case JXRequestModeMore: {
            if (JXErrorCodeDataEmpty == error.code) {
                nedUpdate = NO;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            break;
        }
        case JXRequestModeHUD: {
            [JXDialog hideHUD];
            break;
        }
        default:
            break;
    }
    
    if (JXErrorCodeLoginExpired == error.code) {
        notFilter = NO;
        
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                [self triggerLoad];
            }
        } error:error];
    } else if (JXErrorCodeDataEmpty == error.code) {
        notFilter = NO;
    }
    
    self.error = error;
    self.requestMode = JXRequestModeNone;
    if (nedUpdate) {
        self.dataSource = nil;
    }
    
    return notFilter;
}

- (NSUInteger)nextPageIndex {
    if (JXObjcPageStyleGroup == JXInstance.pageStyle) {
        return self.page + 1;
    }else if (JXObjcPageStyleOffset == JXInstance.pageStyle) {
        NSArray *lastRows = self.dataSource.lastObject;
        NSArray *lastObj = lastRows.lastObject;
        return [[(JXObject *)lastObj jxID] integerValue];
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
    [super reloadData];
    [self.tableView reloadData];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [JXCellDefault height];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
//    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath object:(id)object {
//    return [self tableView:tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    //return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    
}

- (void)triggerLoad {
    self.error = nil;
    
    self.requestMode = JXRequestModeLoad;
    self.dataSource = nil;
    
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.page = JXInstance.pageIndex;
    } completed:^{
        // int a = 0;
        self.requestMode = JXRequestModeNone;
        if (self.shouldInfiniteScrolling && self.isNoMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)triggerRefresh {
    self.error = nil;
    self.requestMode = JXRequestModeRefresh;
    
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        //@strongify(self)
    } completed:^{
        @strongify(self)
        self.requestMode = JXRequestModeNone;
        
        [self.tableView.mj_header endRefreshing];
        if (self.shouldInfiniteScrolling && self.isNoMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)triggerMore {
    self.requestMode = JXRequestModeMore;
    
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@([self nextPageIndex])] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.page += 1;
    } completed:^{
        self.requestMode = JXRequestModeNone;
        
        @strongify(self)
        if (self.isNoMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
}


//- (void)triggerUpdate {
////    self.requestMode = JXRequestModeUpdate;
////    [self beginUpdate];
////    
////    @weakify(self)
////    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(NSArray *items) {
////        @strongify(self)
////        self.requestMode = JXRequestModeNone;
////    } completed:^{
////        @strongify(self)
////        [self endUpdate];
////    }];
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
//          [JXDialog hideHUD];
//      }];
//}
//

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
    // UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
    
    id object = self.dataSource[indexPath.section][indexPath.row];
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath object:object];
    
    [self configCell:cell indexPath:indexPath object:object];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.didSelectCommand execute:RACTuplePack(indexPath, self.dataSource[indexPath.section][indexPath.row])];
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.tableView.tableHeaderView.hidden = YES;
    self.tableView.tableFooterView.hidden = YES;
}


- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView {
    self.tableView.tableHeaderView.hidden = NO;
    self.tableView.tableFooterView.hidden = NO;
}

@end
