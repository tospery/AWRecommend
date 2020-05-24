//
//  ScanCommitViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanCommitViewController.h"

@interface ScanCommitViewController ()
@property (nonatomic, weak) IBOutlet UILabel *title1Label;
@property (nonatomic, weak) IBOutlet UILabel *title2Label;
@property (nonatomic, weak) IBOutlet UITextField *infoField;
@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segControl;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) RACCommand *submitCommand;

@end

@implementation ScanCommitViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [SMInstance configButtonStyle1:self.submitButton fontSize:16.0f borderRadius:2.0];
}

- (void)bindViewModel {
    [super bindViewModel];
    
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
    self.navigationItem.title = @"添加药品";
    
//    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
    
    self.title1Label.font = JXFont(14);
    self.title2Label.font = JXFont(14);
    self.infoField.font = JXFont(16);
    self.phoneField.font = JXFont(16);
    
    self.segControl.tintColor = SMInstance.mainColor;
    
    NSString *text = @"* 药品信息";
    NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:text color:JXColorHex(0x333333) font:JXFont(14)];
    [mas jx_addAttributeWithColor:[UIColor redColor] font:JXFont(14) range:NSMakeRange(0, 1)];
    self.title1Label.attributedText = mas;
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist

//#pragma mark - Table
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
        _submitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *t) {
            return [HRInstance addUserSeggestionsWithBarcode:t.first brandName:nil drugName:t.second phone:t.third];
        }];
        
        [_submitCommand.executing subscribe:self.executing];
        [_submitCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_submitCommand.executionSignals.switchToLatest subscribeNext:^(NSString *result) {
            @strongify(self)
            // JXHUDSuccess(@"提交成功~", NO);
            [JXDialog showPopup:@"提交成功~"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
    }
    return _submitCommand;
}

- (NSString *)verifyInput {
    return [JXInputManager verifyInput:self.infoField.text least:1 original:nil title:@"药品信息"];
}

#pragma mark - Action methods
- (IBAction)segControlChanged:(UISegmentedControl *)sc {
    self.infoField.text = nil;
    if (sc.selectedSegmentIndex == 0) {
        self.infoField.placeholder = @"请输入药品名";
    }else {
        self.infoField.placeholder = @"请输入条形码";
    }
}

- (IBAction)submitButtonPressed:(id)sender {
    NSString *verify = [self verifyInput];
    if (0 != verify.length) {
        [JXDialog showPopup:verify];
        return;
    }
    
    NSString *code = nil;
    NSString *name = nil;
    if (0 == self.segControl.selectedSegmentIndex) {
        name = self.infoField.text;
    }else {
        code = self.infoField.text;
    }
    [self.submitCommand execute:RACTuplePack(code, name, self.phoneField.text)];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end
