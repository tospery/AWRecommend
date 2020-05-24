//
//  CompClassifyViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/3.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXViewController.h"

@interface CompClassifyViewController : JXViewController <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign) SearchClassifyType classify;

@end
