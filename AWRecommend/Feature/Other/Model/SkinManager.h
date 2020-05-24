//
//  SkinManager.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXSkinManager.h"

#define SMInstance                ([SkinManager sharedInstance])

@interface SkinManager : JXSkinManager

- (void)configButtonStyle2:(UIButton *)button;
- (void)configButtonStyle3:(UIButton *)button;

- (void)configAlertStyle;

@end
