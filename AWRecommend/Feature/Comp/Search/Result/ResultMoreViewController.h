//
//  ResultMoreViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXTableViewController.h"
#import "ShortcutSymptomRequest.h"

@interface ResultMoreViewController : JXTableViewController
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL isPrecised;
@property (nonatomic, strong) ShortcutSymptomRequest *symptomRequest;

@end
