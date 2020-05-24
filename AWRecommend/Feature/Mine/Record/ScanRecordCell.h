//
//  ScanRecordCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanRecordCell : SWTableViewCell
@property (nonatomic, strong) id data;

+ (NSString *)identifier;
+ (CGFloat)height;

@end
