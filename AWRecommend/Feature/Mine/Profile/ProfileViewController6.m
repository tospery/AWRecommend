//
//  ProfileViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ProfileViewController6.h"
#import "ProfileAvatarCell.h"

#define lProfileAvatar      (@"lProfileAvatar")
#define lProfileName        (@"lProfileName")

@interface ProfileViewController6 ()

@end

@implementation ProfileViewController6
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self = [super initWithCoder:coder]) {
        [self initializeForm];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self = [super init]){
        [self initializeForm];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = SMInstance.viewBgColor;
}

- (void)initializeForm {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"修改个人信息"];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
//    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:lProfileAvatar rowType:XLFormRowDescriptorTypeImage title:@"头像"];
//    row.height = JXAdaptScreen(50.0f);
//    row.value = JXImageWithName(@"img_UserCenter_default");
//    row.onChangeBlock = ^(id  _Nullable oldValue, id  _Nullable newValue, XLFormRowDescriptor * _Nonnull rowDescriptor) {
//        int a = 0;
//    };
    
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:lProfileAvatar rowType:XLFormRowDescriptorTypeAvatar title:@"头像"];
    row.value = ((0 == gUser.avatar.length) ? JXImageWithName(@"img_UserCenter_default") : JXURLWithStr(gUser.avatar));
    row.height = JXAdaptScreen(50.0f);
    [row.cellConfig setObject:JXFont(15) forKey:@"textLabel.font"];
    [row.cellConfig setObject:JXColorHex(0x333333) forKey:@"textLabel.textColor"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:lProfileName rowType:XLFormRowDescriptorTypeText title:@"昵称"];
    row.height = JXAdaptScreen(40.0f);
    row.value = JXStrWithDft(gUser.nickName, @"暂无");
    [row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    [row.cellConfig setObject:JXFont(15) forKey:@"textLabel.font"];
    [row.cellConfig setObject:JXColorHex(0x333333) forKey:@"textLabel.textColor"];
    [row.cellConfig setObject:JXFont(15) forKey:@"textField.font"];
    [row.cellConfig setObject:JXColorHex(0x999999) forKey:@"textField.textColor"];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    // [row.cellConfig setObject:JXStrWithDft(gUser.nickName, @"暂无") forKey:@"textField.text"];
    [section addFormRow:row];
    
    self.form = form;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JXAdaptScreen(12.0f);
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue {
    int a = 0;
}

@end











