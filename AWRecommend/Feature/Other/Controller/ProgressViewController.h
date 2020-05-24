//
//  ProgressViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXViewController.h"

@interface ProgressViewController : JXViewController
@property (nonatomic, assign) BOOL isBrand;
@property (nonatomic, assign) BOOL toFinish;
@property (nonatomic, copy) JXVoidBlock finishBlock;
@property (nonatomic, copy) JXVoidBlock backBlock;

@end
