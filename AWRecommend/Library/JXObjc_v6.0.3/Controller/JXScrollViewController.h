//
//  JXScrollViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXViewController.h"

/// 联调，看各个方法是不是在只执行一次的时候，是不是只执行了一次（YJX_TODO）
// TODO
// 1. 本地数据

@interface JXScrollViewController : JXViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIScrollViewDelegate>
@property (nonatomic, assign) BOOL shouldPullToRefresh;
@property (nonatomic, assign) BOOL shouldInfiniteScrolling;
@property (nonatomic, assign) JXRequestMode requestMode;
@property (nonatomic, strong) id requestParam;
@property (nonatomic, strong) id dataSource;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

//@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
// @property (nonatomic, weak, readonly) UISearchBar *searchBar;
//@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong, readonly) RACCommand *requestRemoteDataCommand;

- (id)fetchLocalData;
- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page;
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

- (void)setupRefresh;

- (void)triggerLoad;
- (void)triggerUpdate;
- (void)triggerHUD;
- (void)triggerRefresh;
- (void)triggerMore;

- (void)reloadData; // 更新UI

- (void)beginUpdate;
- (void)endUpdate;

- (BOOL)catchError:(NSError *)error;
- (void)handleError:(NSError *)error;

@end






