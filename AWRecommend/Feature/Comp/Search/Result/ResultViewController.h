//
//  ResultViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/4/6.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXScrollViewController.h"
#import "ShortcutSymptomRequest.h"

@interface ResultViewController : JXScrollViewController
@property (nonatomic, assign) BOOL isPrecised;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *scope;

@property (nonatomic, strong) ShortcutSymptomRequest *symptomRequest;

@end
