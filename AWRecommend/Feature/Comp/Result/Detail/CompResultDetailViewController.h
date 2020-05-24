//
//  CompResultDetailViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXViewController.h"

@interface CompResultDetailViewController : JXViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) CompResultBrand *brand;

@end
