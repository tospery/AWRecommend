//
//  ProfileViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ProfileViewController11.h"
#import "SettingCell.h"
#import "SettingNicknameViewController.h"

@interface ProfileViewController11 ()
@property (nonatomic, strong) JXAction *avatarAction;
@property (nonatomic, strong) RACCommand *avatarCommand;
@property (nonatomic, strong) RACCommand *modifyCommand;

@end

@implementation ProfileViewController11
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupNet];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark setup
- (void)setupVar {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyProfileDidChange:) name:kNotifyProfileDidChange object:nil];
}

- (void)setupView {
    self.navigationItem.title = @"修改个人信息";
    
    UINib *nib = [UINib nibWithNibName:@"SettingCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[SettingCell identifier]];
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.backgroundColor = self.contentView.backgroundColor;
    self.headerView.backgroundColor = self.contentView.backgroundColor;
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    // RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[fetchLocalDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        return JXArrTable(result);
    }];
    
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)

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
        }
        
        return [RACSignal empty];
    }];
}

- (id)fetchLocalData {
    return @[@"头像", @"昵称", @"性别", @"生日"];
}

//- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
//    return [HRInstance requestDhzyDaibanListWithPage:1];
//}

#pragma mark table
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [SettingCell heightWithData:object];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[SettingCell identifier] forIndexPath:indexPath];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    SettingCell *myCell = (SettingCell *)cell;
    myCell.data = object;
    myCell.textLabel.font = JXFont(14);
    
    if (3 == indexPath.row) {
        myCell.separatorImageView.hidden = YES;
    }else {
        myCell.separatorImageView.hidden = NO;
    }
}

#pragma mark - Accessor
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

- (JXAction *)avatarAction {
    if (!_avatarAction) {
        _avatarAction = [JXAction sheetWithAssetSheetMode:JXAssetSheetModeOnlyPhoto];
    }
    return _avatarAction;
}


#pragma mark - Action methods
#pragma mark - Notification methods
- (void)notifyProfileDidChange:(NSNotification *)notification {
    [self reloadData];
}

#pragma mark - Private
#pragma mark - Public
#pragma mark - Action
#pragma mark - Notification
#pragma mark - Delegate
#pragma mark - Class

@end












