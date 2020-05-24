//
//  LocateSearchViewController.h
//  TIMChat
//
//  Created by 杨建祥 on 16/11/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "JXViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface LocateSearchViewController : JXViewController <UISearchBarDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSString *cityName;

@end
