//
//  NiceCommentViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceCommentViewController.h"
#import "NiceCommentCell.h"
#import "NiceCommentEmptyView.h"

@interface NiceCommentViewController ()
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NiceCommentEmptyView *emptyView;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) RACCommand *listCommand;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) RACCommand *commentCommand;

@property (nonatomic, strong) NiceComment *currentComment;

@end

@implementation NiceCommentViewController
- (instancetype)init {
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder {
    return UITableViewStylePlain;
}

- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIContentSizeCategoryDidChangeNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputbarDidMove:) name:SLKTextInputbarDidMoveNotification object:nil];
    
    //    // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
    //    [self registerClassForTextView:[MessageTextView class]];
}

- (NiceCommentEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[[NSBundle mainBundle] loadNibNamed:@"NiceCommentEmptyView" owner:self options:nil] firstObject];
    }
    return _emptyView;
}

- (BOOL)dataSourceIsEmpty {
    if (self.messages == nil || self.messages.count == 0) {
        return YES;
    }
    return NO;
}

//- (RACCommand *)listCommand {
//    if (!_listCommand) {
//        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *t) {
//            return [HRInstance selectCommmentWithPage:[t.first integerValue] articleId:[t.second integerValue]];
//        }];
//        //
//        //        [_listCommand.executing subscribe:self.executing];
//        //        [_listCommand.errors subscribe:self.errors];
//        [_listCommand.errors subscribeError:^(NSError * _Nullable error) {
//            __block BOOL pass = [gUser checkLoginWithFinish:^{
//                if (!pass) {
//                    self.error = nil;
//                    self.page = JXInstance.pageIndex;
//                    [self.messages removeAllObjects];
//                    
//                    [self.tableView reloadData];
//                    [self.listCommand execute:RACTuplePack(@(self.page), @3)];
//                }
//            } error:error];
//            
//            self.error = error;
//            [self.tableView reloadData]; // YJX_TODO
//            
//            if (NO == self.textInputbar.hidden) {
//                [self setTextInputbarHidden:YES animated:NO];
//            }
//        }];
//        
//        @weakify(self)
//        [_listCommand.executionSignals.switchToLatest subscribeNext:^(NiceCommentList *list) {
//            @strongify(self)
//            [self configList:list];
//        }];
//    }
//    return _listCommand;
//}

//- (RACCommand *)commentCommand {
//    if (!_commentCommand) {
//        _commentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *t) {
//            return [HRInstance addComment:[t.first integerValue] comment:t.second];
//        }];
//        [_listCommand.errors subscribeError:^(NSError * _Nullable error) {
//            __block BOOL pass = [gUser checkLoginWithFinish:^{
//                if (!pass) {
//                    [self.messages removeObject:self.currentComment];
//                    if (0 == self.messages.count) {
//                        self.error = error;
//                    }else {
//                        self.error = nil;
//                    }
//                    [self.tableView reloadData];
//                    [self.commentCommand execute:RACTuplePack(@3, self.currentComment.articleCommentsContext)];
//                }
//            } error:error];
//        }];
//        
//        // @weakify(self)
//        [_commentCommand.executionSignals.switchToLatest subscribeNext:^(id a) {
//
//        }];
//    }
//    return _commentCommand;
//}

- (void)configList:(NiceCommentList *)list {
    // YJX_TODO
    [self.messages addObjectsFromArray:list.datas];
    
    if (self.messages.count == 0) {
        self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
    }
    
    NSInteger count = self.messages.count;
    for (int i = 0; i < count; ++i) {
        NiceComment *n = self.messages[i];
        n.lc = (count - i);
    }
    [self.tableView reloadData];
    
    //    if (0 == self.messages.count) {
    //        if (YES == self.textInputbar.hidden) {
    //            [self setTextInputbarHidden:YES animated:NO];
    //        }
    //    }else {
    //        if (YES == self.textInputbar.hidden) {
    //            [self setTextInputbarHidden:NO animated:YES];
    //        }
    //    }
    
    if (YES == self.textInputbar.hidden) {
        [self setTextInputbarHidden:NO animated:YES];
    }
}

- (void)triggerLoad {
    self.error = nil;
    
    NSInteger count = self.messages.count;
    for (int i = 0; i < count; ++i) {
        NiceComment *n = self.messages[i];
        n.lc = (count - i);
    }
    [self.tableView reloadData];
    
    @weakify(self)
    [[HRInstance selectCommmentListForAPP:self.nice.jxID.integerValue commentId:0 offset:0] subscribeNext:^(NiceCommentList *list) {
        @strongify(self)
        [self.messages addObjectsFromArray:list.datas];
        
        if (0 == self.messages.count) {
            self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
        }
        
        if (list.totalSize <= self.messages.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        NSInteger count = self.messages.count;
        for (int i = 0; i < count; ++i) {
            NiceComment *n = self.messages[i];
            n.lc = (count - i);
        }
        [self.tableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTextInputbarHidden:NO animated:YES];
        });
    } error:^(NSError * _Nullable error) {
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                [self triggerLoad];
            }else {
                if (error) {
                    // JXHUDError(error.localizedDescription, YES);
                    // [JXDialog showPopup:error.localizedDescription];
                }
            }
        } error:error];
        
        self.error = error;
        
        NSInteger count = self.messages.count;
        for (int i = 0; i < count; ++i) {
            NiceComment *n = self.messages[i];
            n.lc = (count - i);
        }
        [self.tableView reloadData];
    }];
}

- (void)triggerRefresh {
    self.error = nil;
    
    NSInteger commentId = 0;
    NSInteger offset = 0;
    if (0 != self.messages.count) {
        NiceComment *firstObj = self.messages.firstObject;
        commentId = firstObj.jxID.integerValue;
    }
    
    @weakify(self)
    [[HRInstance selectCommmentListForAPP:self.nice.jxID.integerValue commentId:commentId offset:offset] subscribeNext:^(NiceCommentList *list) {
        @strongify(self)
        if (0 == self.messages.count) {
            [self.messages addObjectsFromArray:list.datas];
        }else {
            if (0 != list.datas.count) {
//                NiceComment *remoteObj = list.datas.lastObject;
//                NSInteger remoteID = remoteObj.jxID.integerValue;
//                
//                NSMutableArray *toRemovedArray = [NSMutableArray arrayWithCapacity:JXInstance.pageSize];
//                for (NiceComment *n in self.messages) {
//                    if (n.jxID.integerValue == remoteID) {
//                        [toRemovedArray addObject:n];
//                        break;
//                    }else if (n.jxID.integerValue > remoteID) {
//                        [toRemovedArray addObject:n];
//                    }else {
//                        break;
//                    }
//                }
//                
//                [self.messages removeObjectsInArray:toRemovedArray];
                
                [self.messages insertObjects:list.datas atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, list.datas.count)]];
            }
        }
        
        if (0 == self.messages.count) {
            self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        if (list.totalSize <= self.messages.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        NSInteger count = self.messages.count;
        for (int i = 0; i < count; ++i) {
            NiceComment *n = self.messages[i];
            n.lc = (count - i);
        }
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
//        __block BOOL pass = [gUser checkLoginWithFinish:^{
//            if (!pass) {
//                [self.tableView.mj_header beginRefreshing];
//            }
//        } error:error];
        
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                [self.tableView.mj_header beginRefreshing];
            }else {
                // JXHUDError(error.localizedDescription, YES);
                [JXDialog showPopup:error.localizedDescription];
            }
        } error:error];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)triggerMore {
    @weakify(self)
    
    NSInteger commentId = 0;
    NSInteger offset = JXInstance.pageSize;
    if (0 != self.messages.count) {
        NiceComment *comment = self.messages.lastObject;
        commentId = comment.jxID.integerValue;
    }
    
    [[HRInstance selectCommmentListForAPP:self.nice.jxID.integerValue commentId:commentId offset:offset] subscribeNext:^(NiceCommentList *list) {
        @strongify(self)
//        self.page += 1;
//
//        NiceComment *remoteObj = list.datas.firstObject;
//        NSInteger remoteID = remoteObj.jxID.integerValue;
//        
//        NSMutableArray *toRemovedArray = [NSMutableArray arrayWithCapacity:JXInstance.pageSize];
//
//        for (NSInteger i = (self.messages.count - 1); i >= 0; --i) {
//            NiceComment *n = self.messages[i];
//            if (n.jxID.integerValue == remoteID) {
//                [toRemovedArray addObject:n];
//                break;
//            }else if (n.jxID.integerValue < remoteID) {
//                [toRemovedArray addObject:n];
//            }else {
//                break;
//            }
//        }
//        
//        [self.messages removeObjectsInArray:toRemovedArray];
//        [self.messages addObjectsFromArray:list.datas];
        
        if (list.datas.count != 0) {
            [self.messages addObjectsFromArray:list.datas];
        }

        if (list.totalSize <= self.messages.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        NSInteger count = self.messages.count;
        for (int i = 0; i < count; ++i) {
            NiceComment *n = self.messages[i];
            n.lc = (count - i);
        }
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
//        __block BOOL pass = [gUser checkLoginWithFinish:^{
//            if (!pass) {
//                //                self.error = nil;
//                //                self.page = JXInstance.pageIndex;
//                //                [self.messages removeAllObjects];
//                //
//                //                [self.tableView reloadData];
//                //                [self.listCommand execute:RACTuplePack(@(self.page), @3)];
//                [self.tableView.mj_footer beginRefreshing];
//            }
//        } error:error];
        
        
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                [self.tableView.mj_footer beginRefreshing];
            }else {
                // JXHUDError(error.localizedDescription, YES);
                [JXDialog showPopup:error.localizedDescription];
            }
        } error:error];
        
        [self.tableView.mj_footer endRefreshing];
        
        //        self.error = error;
        //        [self.tableView reloadData]; // YJX_TODO
        //
        //        if (NO == self.textInputbar.hidden) {
        //            [self setTextInputbarHidden:YES animated:NO];
        //        }
    }];
}

#pragma mark - View lifecycle

- (void)backItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.translucent = YES;
    
    self.page = JXInstance.pageIndex;
    
    self.navigationItem.title = @"评论";
    
    self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(backItemPressed:), JXColorHex(0x333333));
    
    //    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectZero];
    //    emptyView.backgroundColor = [UIColor redColor];
    
    
    //    [self.scrollView addSubview:self.emptyView];
    //    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
    ////        make.leading.equalTo(self.view);
    ////        make.top.equalTo(self.view);
    ////        make.trailing.equalTo(self.view);
    ////        make.bottom.equalTo(self.textInputbar.mas_top);
    //        make.edges.equalTo(self.scrollView);
    //    }];
    
    
    // Example's configuration
    [self configureDataSource];
    [self configureActionItems];
    
    
    //    [RACObserve(self.messages, count) subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"count = %@", x);
    //    }];
    
    // SLKTVC's configuration
    self.bounces = NO;
    self.shakeToClearEnabled = NO;
    self.keyboardPanningEnabled = NO;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = NO;
    
    [self.leftButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self.leftButton setTintColor:SMInstance.mainColor];
    
    [self.rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:SMInstance.mainColor forState:UIControlStateNormal];
    
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 256;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    
    //    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    //    [self.textInputbar.editorLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    //    [self.textInputbar.editorRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    //
    //#if DEBUG_CUSTOM_BOTTOM_VIEW
    //    // Example of view that can be added to the bottom of the text view
    //
    //    UIView *bannerView = [UIView new];
    //    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    //    bannerView.backgroundColor = [UIColor blueColor];
    //
    //    NSDictionary *views = NSDictionaryOfVariableBindings(bannerView);
    //
    //    [self.textInputbar.contentView addSubview:bannerView];
    //    [self.textInputbar.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bannerView]|" options:0 metrics:nil views:views]];
    //    [self.textInputbar.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bannerView(40)]|" options:0 metrics:nil views:views]];
    //#endif
    //
    //#if !DEBUG_CUSTOM_TYPING_INDICATOR
    //    self.typingIndicatorView.canResignByTouch = YES;
    //#endif
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"NiceCommentCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[NiceCommentCell identifier]];
    self.tableView.backgroundColor = JXColorHex(0xF5F5F5);
    self.tableView.tableFooterView = [UIView new];
    
    RefreshGifHeader *header = [RefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(triggerMore)];
    
    // self.tableView.tableFooterView = [UIView new];
    
    //    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:MessengerCellIdentifier];
    //
    //    [self.autoCompletionView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:AutoCompletionCellIdentifier];
    //    [self registerPrefixesForAutoCompletion:@[@"@", @"#", @":", @"+:", @"/"]];
    //
    //    [self.textView registerMarkdownFormattingSymbol:@"*" withTitle:@"Bold"];
    //    [self.textView registerMarkdownFormattingSymbol:@"_" withTitle:@"Italics"];
    //    [self.textView registerMarkdownFormattingSymbol:@"~" withTitle:@"Strike"];
    //    [self.textView registerMarkdownFormattingSymbol:@"`" withTitle:@"Code"];
    //    [self.textView registerMarkdownFormattingSymbol:@"```" withTitle:@"Preformatted"];
    //    [self.textView registerMarkdownFormattingSymbol:@">" withTitle:@"Quote"];
    
    
    [self setTextInputbarHidden:YES animated:NO];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
   // [self.listCommand execute:RACTuplePack(@(self.page), @3)];
    [self triggerLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    self.tableView.contentInset = UIEdgeInsetsZero;
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark - Example's Configuration

- (void)configureDataSource {
    
    self.messages = [NSMutableArray arrayWithCapacity:JXInstance.pageSize];
    
    //    NSMutableArray *array = [[NSMutableArray alloc] init];
    //
    ////    for (int i = 100; i >= 1; i--) {
    ////        NiceComment *c = [NiceComment new];
    ////        c.jxID = JXStrWithInt(i);
    ////        c.articleCommentsContext = JXStrWithFmt(@"这是第%ld条评论", (long)i);
    ////        c.articleCommentsTime = @"2017-11-22 19:20:33";
    ////        c.user = [User new];
    ////        c.user.nickName = JXStrWithFmt(@"用户%ld", (long)i);
    ////
    ////        [array addObject:c];
    ////    }
    //
    //    self.messages = [[NSMutableArray alloc] initWithArray:array];
    
    //
    //    NSArray *reversed = [[array reverseObjectEnumerator] allObjects];
    //
    //    self.messages = [[NSMutableArray alloc] initWithArray:reversed];
    //
    //    self.users = @[@"Allen", @"Anna", @"Alicia", @"Arnold", @"Armando", @"Antonio", @"Brad", @"Catalaya", @"Christoph", @"Emerson", @"Eric", @"Everyone", @"Steve"];
    //    self.channels = @[@"General", @"Random", @"iOS", @"Bugs", @"Sports", @"Android", @"UI", @"SSB"];
    //    self.emojis = @[@"-1", @"m", @"man", @"machine", @"block-a", @"block-b", @"bowtie", @"boar", @"boat", @"book", @"bookmark", @"neckbeard", @"metal", @"fu", @"feelsgood"];
    //    self.commands = @[@"msg", @"call", @"text", @"skype", @"kick", @"invite"];
}

- (void)configureActionItems {
    
}

#pragma mark - Overriden Methods
- (BOOL)ignoreTextInputbarAdjustment {
    return [super ignoreTextInputbarAdjustment];
}

- (BOOL)forceTextInputbarAdjustmentForResponder:(UIResponder *)responder {
    if ([responder isKindOfClass:[UIAlertController class]]) {
        return YES;
    }
    
    // On iOS 9, returning YES helps keeping the input view visible when the keyboard if presented from another app when using multi-tasking on iPad.
    return SLK_IS_IPAD;
}

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status {
    // Notifies the view controller that the keyboard changed status.
    switch (status) {
        case SLKKeyboardStatusWillShow:     return NSLog(@"Will Show");
        case SLKKeyboardStatusDidShow:      return NSLog(@"Did Show");
        case SLKKeyboardStatusWillHide:     return NSLog(@"Will Hide");
        case SLKKeyboardStatusDidHide:      return NSLog(@"Did Hide");
    }
}

- (void)textWillUpdate {
    // Notifies the view controller that the text will update.
    
    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated
{
    // Notifies the view controller that the text did update.
    
    [super textDidUpdate:animated];
}

- (void)didPressLeftButton:(id)sender {
    // Notifies the view controller when the left button's action has been triggered, manually.
    
    [super didPressLeftButton:sender];
    
    //    UIViewController *vc = [UIViewController new];
    //    vc.view.backgroundColor = [UIColor whiteColor];
    //    vc.title = @"Details";
    //
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didPressRightButton:(id)sender {
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView refreshFirstResponder];
    
    if (self.error) {
        self.error = nil;
    }
    
    NiceComment *pre = self.messages.firstObject;
    NSInteger cID = 0;
    if (pre) {
        cID = pre.jxID.integerValue;
    }
    
    NiceComment *c = [NiceComment new];
    c.jxID = JXStrWithInt(++cID);
    c.articleCommentsContext = [self.textView.text copy];
    c.articleCommentsTime = [[NSDate date] jx_stringWithFormat:kJXFormatDatetimeStyle1];
    c.user = [NiceCommentUser new];
    c.user.nickName = [gUser displayName];
    c.user.avatar = gUser.avatar;
    c.lc = self.messages.count + 1;
    self.currentComment = c;
    
    @weakify(self)
    [[HRInstance addComment:self.nice.jxID.integerValue comment:c.articleCommentsContext] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewRowAnimation rowAnimation = self.inverted ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
        UITableViewScrollPosition scrollPosition = self.inverted ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop;
        
        [self.tableView beginUpdates];
        [self.messages insertObject:c atIndex:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
        [self.tableView endUpdates];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
        
        // Fixes the cell from blinking (because of the transform, when using translucent cells)
        // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
//        __block BOOL pass = [gUser checkLoginWithFinish:^{
//            if (!pass) {
//                self.textView.text = c.articleCommentsContext;
//            }
//        } error:error];
        
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                self.textView.text = c.articleCommentsContext;
            }else {
                // JXHUDError(error.localizedDescription, YES);
                [JXDialog showPopup:error.localizedDescription];
            }
        } error:error];
    }];
    
    [super didPressRightButton:sender];
    
    if (self.submitBlock) {
        self.submitBlock();
    }
    
    //    [self.commentCommand execute:RACTuplePack(@3, self.currentComment.articleCommentsContext)];
}

- (void)didPressArrowKey:(UIKeyCommand *)keyCommand {
    [super didPressArrowKey:keyCommand];
    //    if ([keyCommand.input isEqualToString:UIKeyInputUpArrow] && self.textView.text.length == 0) {
    //        [self editLastMessage:nil];
    //    }
    //    else {
    //        [super didPressArrowKey:keyCommand];
    //    }
}

- (NSString *)keyForTextCaching {
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (void)didPasteMediaContent:(NSDictionary *)userInfo {
    // Notifies the view controller when the user has pasted a media (image, video, etc) inside of the text view.
    [super didPasteMediaContent:userInfo];
    
    SLKPastableMediaType mediaType = [userInfo[SLKTextViewPastedItemMediaType] integerValue];
    NSString *contentType = userInfo[SLKTextViewPastedItemContentType];
    id data = userInfo[SLKTextViewPastedItemData];
    
    NSLog(@"%s : %@ (type = %ld) | data : %@",__FUNCTION__, contentType, (unsigned long)mediaType, data);
}

- (void)willRequestUndo
{
    // Notifies the view controller when a user did shake the device to undo the typed text
    
    [super willRequestUndo];
}

- (void)didCommitTextEditing:(id)sender
{
    //    // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text
    //    self.editingMessage.text = [self.textView.text copy];
    
    NSInteger count = self.messages.count;
    for (int i = 0; i < count; ++i) {
        NiceComment *n = self.messages[i];
        n.lc = (count - i);
    }
    [self.tableView reloadData];
    
    [super didCommitTextEditing:sender];
}

- (void)didCancelTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the left "Cancel" button
    
    [super didCancelTextEditing:sender];
}

- (BOOL)canPressRightButton
{
    return [super canPressRightButton];
}

- (BOOL)canShowTypingIndicator
{
#if DEBUG_CUSTOM_TYPING_INDICATOR
    return YES;
#else
    return [super canShowTypingIndicator];
#endif
}

- (BOOL)shouldProcessTextForAutoCompletion:(NSString *)text
{
    return [super shouldProcessTextForAutoCompletion:text];
}

//- (BOOL)shouldDisableTypingSuggestionForAutoCompletion
//{
//    return [super shouldDisableTypingSuggestionForAutoCompletion];
//}
//
//- (void)didChangeAutoCompletionPrefix:(NSString *)prefix andWord:(NSString *)word
//{
//    NSArray *array = nil;
//
//    self.searchResult = nil;
//
//    if ([prefix isEqualToString:@"@"]) {
//        if (word.length > 0) {
//            array = [self.users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", word]];
//        }
//        else {
//            array = self.users;
//        }
//    }
//    else if ([prefix isEqualToString:@"#"] && word.length > 0) {
//        array = [self.channels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", word]];
//    }
//    else if (([prefix isEqualToString:@":"] || [prefix isEqualToString:@"+:"]) && word.length > 1) {
//        array = [self.emojis filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", word]];
//    }
//    else if ([prefix isEqualToString:@"/"] && self.foundPrefixRange.location == 0) {
//        if (word.length > 0) {
//            array = [self.commands filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", word]];
//        }
//        else {
//            array = self.commands;
//        }
//    }
//
//    if (array.count > 0) {
//        array = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    }
//
//    self.searchResult = [[NSMutableArray alloc] initWithArray:array];
//
//    BOOL show = (self.searchResult.count > 0);
//
//    [self showAutoCompletionView:show];
//}
//
//- (CGFloat)heightForAutoCompletionView
//{
//    CGFloat cellHeight = [self.autoCompletionView.delegate tableView:self.autoCompletionView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    return cellHeight*self.searchResult.count;
//}


#pragma mark - SLKTextViewDelegate Methods

- (BOOL)textView:(SLKTextView *)textView shouldOfferFormattingForSymbol:(NSString *)symbol {
    //    if ([symbol isEqualToString:@">"]) {
    //
    //        NSRange selection = textView.selectedRange;
    //
    //        // The Quote formatting only applies new paragraphs
    //        if (selection.location == 0 && selection.length > 0) {
    //            return YES;
    //        }
    //
    //        // or older paragraphs too
    //        NSString *prevString = [textView.text substringWithRange:NSMakeRange(selection.location-1, 1)];
    //
    //        if ([[NSCharacterSet newlineCharacterSet] characterIsMember:[prevString characterAtIndex:0]]) {
    //            return YES;
    //        }
    //
    //        return NO;
    //    }
    
    return [super textView:textView shouldOfferFormattingForSymbol:symbol];
}

- (BOOL)textView:(SLKTextView *)textView shouldInsertSuffixForFormattingWithSymbol:(NSString *)symbol prefixRange:(NSRange)prefixRange
{
    //    if ([symbol isEqualToString:@">"]) {
    //        return NO;
    //    }
    
    return [super textView:textView shouldInsertSuffixForFormattingWithSymbol:symbol prefixRange:prefixRange];
}

#pragma mark - UITextViewDelegate Methods

- (BOOL)textView:(SLKTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [super textView:textView shouldChangeTextInRange:range replacementText:text];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if ([tableView isEqual:self.tableView]) {
    //        return self.messages.count;
    //    }
    //    else {
    //        return self.searchResult.count;
    //    }
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([tableView isEqual:self.tableView]) {
    //        return [self messageCellForRowAtIndexPath:indexPath];
    //    }
    //    else {
    //        return [self autoCompletionCellForRowAtIndexPath:indexPath];
    //    }
    
    return [self messageCellForRowAtIndexPath:indexPath];
}

- (NiceCommentCell *)messageCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NiceCommentCell *cell = (NiceCommentCell *)[self.tableView dequeueReusableCellWithIdentifier:[NiceCommentCell identifier]];
    
    //    if (cell.gestureRecognizers.count == 0) {
    //        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressCell:)];
    //        [cell addGestureRecognizer:longPress];
    //    }
    
    NiceComment *message = self.messages[indexPath.row];
    cell.data = message;
    
    //cell.textLabel.text = message.user.nickName;
    // cell.bodyLabel.text = message.articleCommentsContext;
    
    //    cell.indexPath = indexPath;
    //    cell.usedForMessage = YES;
    
    // Cells must inherit the table view's transform
    // This is very important, since the main table view may be inverted
    cell.transform = self.tableView.transform;
    
    return cell;
}

//- (MessageTableViewCell *)autoCompletionCellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MessageTableViewCell *cell = (MessageTableViewCell *)[self.autoCompletionView dequeueReusableCellWithIdentifier:AutoCompletionCellIdentifier];
//    cell.indexPath = indexPath;
//
//    NSString *text = self.searchResult[indexPath.row];
//
//    if ([self.foundPrefix isEqualToString:@"#"]) {
//        text = [NSString stringWithFormat:@"# %@", text];
//    }
//    else if (([self.foundPrefix isEqualToString:@":"] || [self.foundPrefix isEqualToString:@"+:"])) {
//        text = [NSString stringWithFormat:@":%@:", text];
//    }
//
//    cell.titleLabel.text = text;
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([tableView isEqual:self.tableView]) {
    //        Message *message = self.messages[indexPath.row];
    //
    //        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //        paragraphStyle.alignment = NSTextAlignmentLeft;
    //
    //        CGFloat pointSize = [MessageTableViewCell defaultFontSize];
    //
    //        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:pointSize],
    //                                     NSParagraphStyleAttributeName: paragraphStyle};
    //
    //        CGFloat width = CGRectGetWidth(tableView.frame)-kMessageTableViewCellAvatarHeight;
    //        width -= 25.0;
    //
    //        CGRect titleBounds = [message.username boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    //        CGRect bodyBounds = [message.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    //
    //        if (message.text.length == 0) {
    //            return 0.0;
    //        }
    //
    //        CGFloat height = CGRectGetHeight(titleBounds);
    //        height += CGRectGetHeight(bodyBounds);
    //        height += 40.0;
    //
    //        if (height < kMessageTableViewCellMinimumHeight) {
    //            height = kMessageTableViewCellMinimumHeight;
    //        }
    //
    //        return height;
    //    }
    //    else {
    //        return kMessageTableViewCellMinimumHeight;
    //    }
    return [NiceCommentCell heightWithData:self.messages[indexPath.row]];
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([tableView isEqual:self.autoCompletionView]) {
    //
    //        NSMutableString *item = [self.searchResult[indexPath.row] mutableCopy];
    //
    //        if ([self.foundPrefix isEqualToString:@"@"] && self.foundPrefixRange.location == 0) {
    //            [item appendString:@":"];
    //        }
    //        else if (([self.foundPrefix isEqualToString:@":"] || [self.foundPrefix isEqualToString:@"+:"])) {
    //            [item appendString:@":"];
    //        }
    //
    //        [item appendString:@" "];
    //
    //        [self acceptAutoCompletionWithString:item keepPrefix:YES];
    //    }
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you override this method, to call super.
    [super scrollViewDidScroll:scrollView];
}

#pragma mark DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = JXStrWithDft(self.error.localizedDescription, kStringDataEmpty);
    if (JXErrorCodeDataEmpty == self.error.code) {
        title = @"还没有评论\n快来抢沙发吧~"; // YJX_TODO 文本间隔
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

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIImage *image = JXImageWithColor(JXInstance.mainColor);
    image = [image scaleToSize:CGSizeMake(JXAdaptScreen(120), JXAdaptScreen(30)) usingMode:NYXResizeModeScaleToFill];
    image = [image jx_makeRadius:JXAdaptScreen(2.0)];
    
    CGFloat slide = JXAdaptValue(-84, -96, -106);
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, slide, 0, slide)];
    
    return image;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return JXImageWithName(@"jxres_loading");
    }
    if (JXErrorCodeDataEmpty == self.error.code) {
        return JXAdaptImage(JXImageWithName(@"img_comment"));
    }
    
    return JXObjWithDft([self.error jx_reasonImage], JXImageWithName(@"jxres_error_empty"));
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    
    return animation;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return JXAdaptScreen(-50);
}

#pragma mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return [self dataSourceIsEmpty];
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return !self.error; //JXRequestModeLoad == self.requestMode;
}

//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
//    //[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)];
//    //[self triggerLoad];
//
////    if (JXErrorCodeTokenInvalid == self.error.code) {
////        [self checkLoginWithError:nil finish:^{
////            [self triggerLoad];
////        }];
////    }else {
////        [self triggerLoad];
////    }
//    [self retryLoad];
//}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    //[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)];
    //[self triggerLoad];
    
    //    if (JXErrorCodeTokenInvalid == self.error.code) {
    //        [self checkLoginWithError:nil finish:^{
    //            [self triggerLoad];
    //        }];
    //    }else {
    //        [self triggerLoad];
    //    }
    
    //    if (JXErrorCodeTokenInvalid == self.error.code) {
    //        [gUser checkLoginWithFinish:^{
    //            [self triggerLoad];
    //        } error:nil];
    //    }else if (JXErrorCodeDataEmpty == self.error.code) {
    //        [self triggerLoad];
    //    }else if (JXErrorCodeNetworkException == self.error.code) {
    //        [self triggerLoad];
    //    }else {
    //        [self triggerLoad];
    //    }
    
    //    if (JXErrorCodeTokenInvalid == self.error.code) {
    //        [gUser checkLoginWithFinish:^{
    //            [self triggerLoad];
    //        } error:nil];
    //    }else if (<#expression#>)
    //
    //    else {
    //        [self triggerLoad];
    //    }
    
    // [self handleError:self.error];
}


#pragma mark - Lifeterm

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
