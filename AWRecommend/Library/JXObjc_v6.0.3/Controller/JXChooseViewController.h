//
//  JXChooseViewController.h
//  ihealth
//
//  Created by 杨建祥 on 16/4/13.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import "JXViewController.h"

// YJX_TODO 重写，不用nib
@interface JXChooseViewController : JXViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIColor *tvTintColor;
@property (nonatomic, strong)  NSArray *items;

@end
