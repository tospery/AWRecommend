//
//  MessageListViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageCell.h"
#import "AlertViewController.h"

@interface MessageListViewController () <SWTableViewCellDelegate>
@property (nonatomic, strong) RACCommand *delCommand;

@end

@implementation MessageListViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.shouldInfiniteScrolling = YES;
        self.shouldPullToRefresh = YES;
    }
    return self;
}

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupNet];
}

#pragma mark setup
- (void)setupVar {
}

- (void)setupView {
    self.navigationItem.title = @"消息中心";
    
    UINib *nib = [UINib nibWithNibName:@"MessageCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[MessageCell identifier]];
    self.tableView.tableFooterView = [UIView new];
    
    self.contentView.backgroundColor = JXColorHex(0xF5F5F5);
    self.tableView.backgroundColor = JXColorHex(0xF5F5F5);
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    // RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(MessageList *list) {
        NSMutableArray *rows = [NSMutableArray arrayWithArray:self.dataSource.firstObject];
        if (JXRequestModeMore != self.requestMode) {
            [rows removeAllObjects];
        }
        [rows addObjectsFromArray:list.datas];
        
        self.isNoMoreData = (rows.count == list.totalSize);

        if (0 == rows.count) {
            self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
            return @[@[]];
        }else {
            self.error = nil;
        }
        
        return @[rows];
    }];
}

- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [[HRInstance listMessagesByPage:page] takeUntil:self.rac_willDeallocSignal];
}

#pragma mark table
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [MessageCell heightWithData:object];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[MessageCell identifier] forIndexPath:indexPath];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    MessageCell *myCell = (MessageCell *)cell;
    myCell.data = object;
    myCell.delegate = self;
    myCell.rightUtilityButtons = [self rightButtons];
}

#pragma mark empty
#pragma mark - Accessor
- (RACCommand *)delCommand {
    if (!_delCommand) {
        _delCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *mid) {
            return [HRInstance removeMessageById:mid.integerValue];
        }];
        [_delCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_delCommand.executionSignals.switchToLatest subscribeNext:^(id resp) {
            @strongify(self)
        }];
    }
    return _delCommand;
}


#pragma mark - Private
- (NSArray *)rightButtons {
    NSMutableArray *buttons = [NSMutableArray new];
    
    //    [buttons sw_addUtilityButtonWithColor: [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
    //                                    title:@"删除"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = JXColorHex(0xF5F5F5);
    [btn setImage:JXAdaptImage(JXImageWithName(@"ic_delete")) forState:UIControlStateNormal];
    [buttons addObject:btn];
    
    return buttons;
}

#pragma mark - Public
#pragma mark - Action
#pragma mark - Notification
#pragma mark - Delegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = JXStrWithDft(self.error.localizedDescription, kStringDataEmpty);
    if (JXErrorCodeDataEmpty == self.error.code) {
        title = @"消息为空"; // YJX_TODO 文本间隔
    }
    
    return [NSMutableAttributedString jx_attributedStringWithString:title color:JXColorHex(0x999999) font:JXFont(15.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = JXStrWithDft([self.error jx_retryTitle], kStringReload);
    if (JXErrorCodeDataEmpty == self.error.code) {
        return nil;
    }
    
    return [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            Message *m = [(MessageCell *)cell data];
            [self.delCommand execute:@(m.messageId.integerValue)];
            
            NSMutableArray *items = [NSMutableArray arrayWithArray:self.dataSource.firstObject];
            [items removeObject:m];
            
            if (0 == items.count) {
                self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
            }
            self.dataSource = JXArrTable(items);
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    return YES;
}


#pragma mark - Class



@end
