//
//  NiceDetailViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXScrollViewController.h"

@interface NiceDetailViewController : JXScrollViewController <WKNavigationDelegate, WKUIDelegate, MWPhotoBrowserDelegate>
@property (nonatomic, assign) NSInteger niceID;
@property (nonatomic, copy) NSString *shareIcon;

@end
