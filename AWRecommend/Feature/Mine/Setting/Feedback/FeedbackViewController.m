//
//  FeedbackViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/26.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, readwrite) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) RACCommand *submitCommand;

@end

@implementation FeedbackViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [SMInstance configButtonStyle1:self.submitButton fontSize:17 borderRadius:20];
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
    
//    RAC(self.submitButton, enabled) = [self.textView.rac_textSignal map:^id _Nullable(NSString *text) {
//        return @(text.length >= 4);
//    }];
    
//    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
//        return JXArrValue(items, [NSArray new]);
//    }] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"意见反馈";
    
//    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (NSString *)verifyInput {
    return [JXInputManager verifyInput:self.textView.text least:4 original:nil title:@"反馈内容"];
}

#pragma mark - Table
//- (id)fetchLocalData {
//    return nil;
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//    return [HRInstance requestDhzyDaibanListWithPage:1];
//}
//
//- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
//    DhzyDaibanCell *myCell = (DhzyDaibanCell *)cell;
//    myCell.data = object;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [DhzyDaibanCell height];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
//    return [tableView dequeueReusableCellWithIdentifier:[DhzyDaibanCell identifier] forIndexPath:indexPath];
//}

#pragma mark - Accessor methods
- (RACCommand *)submitCommand {
    if (!_submitCommand) {
        _submitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance addSuggestion:input];
        }];
        
        [_submitCommand.executing subscribe:self.executing];
        [_submitCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_submitCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            @strongify(self)
            [JXDialog showPopup:@"感谢您的反馈"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
    }
    return _submitCommand;
}


#pragma mark - Action methods
- (IBAction)submitButtonPressed:(id)sender {
//    if (![self verifyInput]) {
//        return;
//    }
//    
//    [self requestFeedbackWithMode:JXWebModeHUD];
    
    
    NSString *result = [self verifyInput];
    if (0 != result.length) {
        [JXDialog showPopup:result];
        return;
    }
    
    [self.submitCommand execute:self.textView.text];
}


#pragma mark - Notification methods

#pragma mark - Delegate methods
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        [self.label setHidden:NO];
    }else {
        [self.label setHidden:YES];
    }
}

#pragma mark - Public methods
#pragma mark - Class methods


@end
