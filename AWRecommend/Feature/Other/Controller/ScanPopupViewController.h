//
//  ScanPopupViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/2.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXScrollViewController.h"

@interface ScanPopupViewController : JXScrollViewController
@property (nonatomic, copy) JXVoidBlock didCloseBlock;
@property (nonatomic, copy) JXVoidBlock didSkipBlock;
@property (nonatomic, copy) JXVoidBlock didLoginBlock;

@end
