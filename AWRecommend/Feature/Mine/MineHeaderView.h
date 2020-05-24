//
//  MineHeaderView.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/7/24.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeaderView : UIView
@property (nonatomic, weak) IBOutlet UIButton *settingButton;
@property (nonatomic, weak) IBOutlet UIButton *messageButton;
@property (nonatomic, weak) IBOutlet UILabel *messageUnreadLabel;
@property (nonatomic, copy) JXVoidBlock loginDidPress;
@property (nonatomic, copy) JXVoidBlock setDidPress;
@property (nonatomic, copy) JXVoidBlock msgDidPress;

@end
