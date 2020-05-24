//
//  SettingViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/25.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SettingViewController2.h"
#import "SettingAvatarCell.h"
#import "SettingCell.h"
#import "SettingNicknameViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "ShareViewController.h"

@interface SettingViewController2 ()
@property (nonatomic, strong) JXAction *avatarAction;
@property (nonatomic, weak) IBOutlet UIButton *exitButton;
@property (nonatomic, strong) RACCommand *exitCommand;
@property (nonatomic, strong) RACCommand *avatarCommand;
@property (nonatomic, strong) RACCommand *modifyCommand;

@end

@implementation SettingViewController2
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
    [SMInstance configButtonStyle1:self.exitButton fontSize:16 borderRadius:0];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    //RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[fetchLocalDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        return JXArrEmpty(result, nil);
    }];
    
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
        //        // YJX_TODO
        //        //         *vc = [[CompResultDetailViewController alloc] init];
        //        //
        //        //        CompResultBrand *b = [CompResultBrand new];
        //        //        b.brandId = [[(CompResultDetail *)input.second uid] integerValue];
        //        //        vc.brand = b;
        //
        //        //        CompResultItem *item = [CompResultItem new];
        //        //        item.dId = [[(CompResultDetail *)input.second uid] integerValue];
        //        //
        //        //        CompResultDetail *d = input.second;
        //        //
        //        //        CompResultBrand
        //        //
        //        CompResultDetail *d = input.second;
        //        CompResultBrand *b = [CompResultBrand new];
        //        b.brandId = d.uid.integerValue;
        //
        //        MedicineViewController *vc = [MedicineViewController medicineNCWithDataSource:b];
        //        [self.navigationController presentViewController:vc animated:YES completion:NULL];
        //        //
        //        //        vc.hidesBottomBarWhenPushed = YES;
        //        //        [self.navigationController pushViewController:vc animated:YES];
        NSString *key = input.second;
        if ([key isEqualToString:@"头像"]) {
            [self.avatarAction displayInController:self clickBlock:^(NSInteger index) {
                @strongify(self)
                if (JXAssetPickerModeNone != index) {
                    JXAssetPickerController *picker = [[JXAssetPickerController alloc] init];
                    BOOL success = [picker setupWithMode:index willSuccess:^(UIImage *image, ALAsset *asset) {
                        @strongify(self)
                        [self.avatarCommand execute:image];
                    } didSuccess:NULL failure:^(NSError *error) {
                        [JXDialog showPopup:error.localizedDescription];
                    }];
                    if (success) {
                        [self presentViewController:picker animated:YES completion:NULL];
                    }
                }
            }];
        } else if ([key isEqualToString:@"昵称"]) {
            SettingNicknameViewController *vc = [[SettingNicknameViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([key isEqualToString:@"性别"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (gUser.sex != GenderTypeMale) {
                    [self.modifyCommand execute:RACTuplePack(gUser.nickName, gUser.dateOfBirth, @(GenderTypeMale))];
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (gUser.sex != GenderTypeFemale) {
                    [self.modifyCommand execute:RACTuplePack(gUser.nickName, gUser.dateOfBirth, @(GenderTypeFemale))];
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self.navigationController presentViewController:alert animated:YES completion:NULL];
            
            
            //            ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:@[@"男", @"女"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            //
            //            } cancelBlock:^(ActionSheetStringPicker *picker) {
            //
            //            } origin:self.view];
            //            picker.toolbarButtonsColor = [UIColor redColor];
            //            [picker showActionSheetPicker];
        }else if ([key isEqualToString:@"生日"]) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
            [minimumDateComponents setYear:1900];
            [minimumDateComponents setMonth:1];
            [minimumDateComponents setDay:1];
            NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
            NSDate *maxDate = [NSDate date];
            
            
            NSDate *selDate = [NSDate jx_dateFromString:@"1990-1-1" format:kJXFormatDateStyle1];
            if (0 != gUser.dateOfBirth) {
                selDate = [NSDate jx_dateFromString:gUser.dateOfBirth format:kJXFormatDateStyle1];
            }
            
            ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:selDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                NSString *selString = [selectedDate jx_stringWithFormat:kJXFormatDateStyle1];
                if (![selString isEqualToString:gUser.dateOfBirth]) {
                    [self.modifyCommand execute:RACTuplePack(gUser.nickName, selString, @(gUser.sex))];
                }
            } cancelBlock:^(ActionSheetDatePicker *picker) {
                
            } origin:self.view];
            picker.minimumDate = minDate;
            picker.maximumDate = maxDate;
            picker.toolbarBackgroundColor = SMInstance.mainColor;
            [picker showActionSheetPicker];
        }else if ([key isEqualToString:@"去好评"]) {
            [[UIApplication sharedApplication] openURL:JXURLWithStr(kAppStoreLink)];
        }else if ([key isEqualToString:@"关于我们"]) {
            AboutViewController *vc = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return [RACSignal empty];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyProfileDidChange:) name:kNotifyProfileDidChange object:nil];
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"设置";
    
    UINib *nib = [UINib nibWithNibName:@"SettingCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[SettingCell identifier]];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = JXColorHex(0xF5F5F5);
    
    // self.tableView.layoutMargins
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
    return @[@[@"头像", @"昵称", @"性别", @"生日"],
             @[@"好友推荐", @"帮助与反馈"],
             @[@"去好评", @"关于我们"]];
}

//- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
//    // return [HRInstance requestDhzyDaibanListWithPage:1];
//
//}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(NSString *)object {
    SettingCell *myCell = (SettingCell *)cell;
    myCell.data = object;
    // myCell.textLabel.text = object;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(NSString *)object {
    return [SettingCell heightWithData:object];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [JXCellDefault height];
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
//    return [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
//}


- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[SettingCell identifier] forIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JXScreenScale(10);
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UITableViewHeaderFooterView *)view forSection:(NSInteger)section {
    view.backgroundView.backgroundColor = JXColorHex(0xf5f5f5);
}

#pragma mark - Accessor methods
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
            [self reloadData];
            [JXDialog hideHUD];
        }];
    }
    return _modifyCommand;
}


- (RACCommand *)avatarCommand {
    if (!_avatarCommand) {
        _avatarCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance modifyWiseAccountHeadImg:input];
        }];
        [_avatarCommand.executing subscribe:self.executing];
        [_avatarCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_avatarCommand.executionSignals.switchToLatest subscribeNext:^(NSString *link) {
            @strongify(self)
            gUser.avatar = link;
            [self reloadData];
            [JXDialog hideHUD];
        }];
    }
    return _avatarCommand;
}

- (RACCommand *)exitCommand {
    if (!_exitCommand) {
        _exitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance exitLogin];
        }];
        // [_exitCommand.errors subscribe:self.errors];
        [_exitCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            
        }];
    }
    return _exitCommand;
}


- (JXAction *)avatarAction {
    if (!_avatarAction) {
        _avatarAction = [JXAction sheetWithAssetSheetMode:JXAssetSheetModeOnlyPhoto];
    }
    return _avatarAction;
}

- (IBAction)exitButtonPressed:(id)sender {
    [self.exitCommand execute:nil];
    [TMInstance removeObjectForKey:kTMTestList];
    [gUser logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action methods
#pragma mark - Notification methods
- (void)notifyProfileDidChange:(NSNotification *)notification {
    [self reloadData];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end






