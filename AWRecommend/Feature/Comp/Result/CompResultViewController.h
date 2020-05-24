//
//  CompResultViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/3.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXViewController.h"

@interface CompResultViewController : JXViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) PeopleType type;

@end
