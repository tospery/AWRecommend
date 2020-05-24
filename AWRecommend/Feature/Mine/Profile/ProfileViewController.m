//
//  ProfileViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/7/25.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ProfileViewController.h"

#define lProfileTagAvatar       (@"lProfileTagAvatar")
#define lProfileTagName         (@"lProfileTagName")
#define lProfileTagGender       (@"lProfileTagGender")
#define lProfileTagBirthday     (@"lProfileTagBirthday")

@interface ProfileViewController ()

@end

@implementation ProfileViewController
- (instancetype)init {
    if (self = [super init]) {
        [self initializeForm];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIBarButtonItem jx_appearanceWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: [UIFont fontWithName:@"NotoSansHans-DemiLight" size:14.0]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIBarButtonItem jx_appearanceWithParam:@{kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: [UIFont fontWithName:@"NotoSansHans-DemiLight" size:14.0]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(backItemPressed:), JXColorHex(0x333333));
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveItemPressed:)];
    
    self.tableView.tintColor = SMInstance.mainColor;
    self.tableView.backgroundColor = JXColorHex(0xF5F5F5);
    self.tableView.separatorColor = JXColorHex(0xE7E7E7);
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initializeForm {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"修改个人信息"];
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:lProfileTagAvatar rowType:XLFormRowDescriptorTypeImage title:@"头像"];
    row.required = YES;
    row.height = JXAdaptScreen(60.0f);
    row.value = (gUser.avatar.length == 0) ? JXImageWithName(@"img_UserCenter_default") : JXURLWithStr(gUser.avatar);
    [row.cellConfig setObject:JXFont(14) forKey:@"textLabel.font"];
    [row.cellConfig setObject:JXColorHex(0x333333) forKey:@"textLabel.color"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:lProfileTagName rowType:XLFormRowDescriptorTypeText title:@"昵称"];
    row.height = JXAdaptScreen(40.0f);
    row.value = gUser.nickName;
    row.noValueDisplayText = @"暂无";
    [row.cellConfig setObject:JXFont(14) forKey:@"textLabel.font"];
    [row.cellConfig setObject:JXColorHex(0x333333) forKey:@"textLabel.color"];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row.cellConfig setObject:JXFont(14) forKey:@"textField.font"];
    [row.cellConfig setObject:JXColorHex(0x666666) forKey:@"textField.textColor"];
    // [row.cellConfigAtConfigure setObject:@"暂无" forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:lProfileTagGender rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"性别"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"男"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"女"]];
    row.noValueDisplayText = @"暂无";
    [row.cellConfig setObject:JXFont(14) forKey:@"textLabel.font"];
    [row.cellConfig setObject:JXColorHex(0x333333) forKey:@"textLabel.color"];
    [row.cellConfig setObject:JXFont(14) forKey:@"detailTextLabel.font"];
    [row.cellConfig setObject:JXColorHex(0x666666) forKey:@"detailTextLabel.color"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:lProfileTagBirthday rowType:XLFormRowDescriptorTypeDate title:@"生日"];
    row.height = JXAdaptScreen(40.0f);
    row.value = [NSDate jx_dateFromString:gUser.dateOfBirth format:kJXFormatDateStyle1];
    row.noValueDisplayText = @"暂无";
    [row.cellConfig setObject:JXFont(14) forKey:@"textLabel.font"];
    [row.cellConfig setObject:JXColorHex(0x333333) forKey:@"textLabel.color"];
    [row.cellConfig setObject:JXFont(14) forKey:@"detailTextLabel.font"];
    [row.cellConfig setObject:JXColorHex(0x666666) forKey:@"detailTextLabel.color"];
    [row.cellConfigAtConfigure setObject:[NSDate new] forKey:@"maximumDate"];
    [section addFormRow:row];
    
    self.form = form;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
}

- (void)backItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveItemPressed:(id)sender {
//    NSDictionary *aa = [self formValues];
//    NSArray *bb = [self formValidationErrors];
//    int cc = 0;
}

@end








