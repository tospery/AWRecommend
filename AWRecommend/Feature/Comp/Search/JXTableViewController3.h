//
//  JXTableViewController.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXViewController.h"

//typedef NS_ENUM(NSInteger, JXTableViewRequestMode){
//    JXTableViewRequestModeNone,
//    JXTableViewRequestModeLoad,
//    JXTableViewRequestModeRefresh,
//    JXTableViewRequestModeMore
//};

@interface JXTableViewController : JXViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
// @property (nonatomic, strong) NSError *error;

@property (nonatomic, assign) BOOL shouldPullToRefresh;
@property (nonatomic, assign) BOOL shouldInfiniteScrolling;

@property (nonatomic, weak, readonly) UISearchBar *searchBar;
@property (nonatomic, weak, readonly) UITableView *tableView;

@property (nonatomic, assign) JXRequestMode requestMode;

- (void)reloadData;

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object;

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSArray *sectionIndexTitles;

@property (nonatomic, assign, readonly) NSUInteger page;
//@property (nonatomic, assign) NSUInteger perPage;

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, strong) RACCommand *didSelectCommand;
@property (nonatomic, strong, readonly) RACCommand *requestRemoteDataCommand;

@property (nonatomic, assign) BOOL isNoMoreData;

- (id)fetchLocalData;
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

// - (NSUInteger)offsetForPage:(NSUInteger)page;
- (NSUInteger)nextPageIndex;

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;

- (void)beginUpdate; //:(BOOL)updated;
- (void)endUpdate;

- (void)retryLoad;
- (void)triggerLoad;
- (void)triggerUpdate;
- (void)triggerHUD;

@end



