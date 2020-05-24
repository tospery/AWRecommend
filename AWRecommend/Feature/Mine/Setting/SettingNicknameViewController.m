//
//  SettingNicknameViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/26.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SettingNicknameViewController.h"

@interface SettingNicknameViewController ()
@property (nonatomic, weak) IBOutlet UITextField *nicknameField;
@property (nonatomic, strong) UIBarButtonItem *saveItem;
@property (nonatomic, strong) RACCommand *modifyCommand;

@end

@implementation SettingNicknameViewController
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

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [UIBarButtonItem jx_appearanceWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: [UIFont fontWithName:@"NotoSansHans-DemiLight" size:14.0]}];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [UIBarButtonItem jx_appearanceWithParam:@{kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: [UIFont fontWithName:@"NotoSansHans-DemiLight" size:14.0]}];
//    [self.navigationItem.rightBarButtonItem jx_configWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: JXFont(14)}];
//}

- (void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.saveItem, enabled) = [self.nicknameField.rac_textSignal map:^id _Nullable(NSString *nickname) {
        if (0 == nickname.length) {
            return @NO;
        }
        
        BOOL disabled = [nickname isEqualToString:gUser.nickName];
        return @(!disabled);
    }];
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
    self.navigationItem.title = @"修改昵称";
    
    self.navigationItem.rightBarButtonItem = self.saveItem;
    
    [self.navigationItem.rightBarButtonItem jx_configWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: JXColorHex(0x999999), kJXKeyTitleFont: JXFont(14)}];
    
    self.nicknameField.text = gUser.nickName;
    
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
- (UIBarButtonItem *)saveItem {
    if (!_saveItem) {
        _saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveItemPressed:)];
    }
    return _saveItem;
}

- (RACCommand *)modifyCommand {
    if (!_modifyCommand) {
        _modifyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *t) {
            return [HRInstance modifyWiseAccountInfo:t.first dateOfBirth:t.second  sex:[(NSNumber *)t.third integerValue]];
        }];
        
        [_modifyCommand.executing subscribe:self.executing];
        [_modifyCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_modifyCommand.executionSignals.switchToLatest subscribeNext:^(User *user) {
            @strongify(self)
            gUser.mobile = user.mobile;
            gUser.nickName = user.nickName;
            gUser.dateOfBirth = user.dateOfBirth;
            gUser.avatar = user.avatar;
            gUser.sex = user.sex;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyProfileDidChange object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            [JXDialog hideHUD];
        }];
    }
    return _modifyCommand;
}


#pragma mark - Action methods
- (void)saveItemPressed:(id)sender {
    [self.modifyCommand execute:RACTuplePack(self.nicknameField.text, gUser.dateOfBirth, @(gUser.sex))];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods

@end
