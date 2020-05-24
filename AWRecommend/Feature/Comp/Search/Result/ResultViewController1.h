//
//  ResultViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXScrollViewController.h"

@interface ResultViewController1 : JXScrollViewController
@property (nonatomic, assign) BOOL isPrecised;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *scope;

@end
