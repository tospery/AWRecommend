//
//  ChatHistoryViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/12.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ChatHistoryViewController.h"
#import "ChatHistoryCell.h"

@interface ChatHistoryViewController ()

@end

@implementation ChatHistoryViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        // self.shouldPullToRefresh = YES;
        self.shouldInfiniteScrolling = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupData];
    [self setupView];
    [self setupSignal];
    [self setupNet];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    // RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(ChatHistoryList *result) {
        NSMutableArray *items = [NSMutableArray arrayWithArray:self.dataSource.firstObject];
        [items addObjectsFromArray:result.datas];
    
        self.isNoMoreData = (result.datas.count < JXInstance.pageSize);
        if (self.isNoMoreData) {
            if (0 == items.count) {
                self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
                // self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty description:@""];
            }
        }
        
        return JXArrTable(items);
    }];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"咨询记录";
    
    UINib *cellNib = [UINib nibWithNibName:@"ChatHistoryCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[ChatHistoryCell identifier]];
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist

#pragma mark - Table
- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [HRInstance userAdvisoryRecordWithDoctorId:self.doctor.doctorId currentPage:page pageSize:JXInstance.pageSize];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    ChatHistoryCell *myCell = (ChatHistoryCell *)cell;
    myCell.data = object;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [ChatHistoryCell heightWithData:object];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[ChatHistoryCell identifier] forIndexPath:indexPath];
}

#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    
    if (JXErrorCodeDataEmpty == self.error.code) {
        return [NSMutableAttributedString jx_attributedStringWithString:@"暂时没有咨询记录~" color:JXColorHex(0x999999) font:JXFont(13)];
    }
    
    NSString *title = JXStrWithDft(self.error.localizedDescription, kStringDataEmpty);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:JXColorHex(0x999999) font:JXFont(15.0f)];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return JXImageWithName(@"jxres_loading");
    }
    
    if (JXErrorCodeDataEmpty == self.error.code) {
        return JXAdaptImage(JXImageWithName(@"img_consult"));
    }
    
    return JXObjWithDft([self.error jx_reasonImage], JXImageWithName(@"jxres_error_empty"));
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.error) {
        return nil;
    }
    
    if (JXErrorCodeDataEmpty == self.error.code) {
        return nil;
    }
    
    NSString *title = JXStrWithDft([self.error jx_retryTitle], kStringReload);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
}

#pragma mark - Public methods
#pragma mark - Class methods


@end
















