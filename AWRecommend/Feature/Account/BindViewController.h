//
//  BindViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/2.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXScrollViewController.h"

@interface BindViewController : JXScrollViewController
@property (nonatomic, copy) JXVoidBlock didPassBlock;
@property (nonatomic, strong) UMSocialUserInfoResponse *wxRsp;

@end
